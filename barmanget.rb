#!/bin/ruby

require 'resolv'
load 'class.rb'
load 'error.rb'
load 'query.rb'
load 'pgsql.rb'

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

def getBarmanProject(project)
	config=YAML::load_file('server.conf')
	config=config[project.getServer.gsub(".areaprod.b2b","")]
	vtlpath="/storage/certificador3/"
	date=Time.now.strftime("%Y%m%d")
	cmd="ls #{project.getPath} > /dev/null"
	bmcommand(cmd,project)
	tmppath="#{vtlpath}data_pg_#{project.getName}"
	cmd="mkdir -p #{tmppath} > /dev/null"
	vtlcommand(cmd,config)
	cmd="barman list-backup #{project.getName} |head -n 1|awk '{print $2}'"
	lastbck=bmcommand(cmd,project).gsub("\n","")
		if lastbck.length < 4
		cmd="rm -rf #{tmppath}"
		vtlcommand(cmd,config)
		p "no existe ningun backup para #{project.getName}"
	 	pgInsert(sqlInsertBackupError,[project.getId,nil])
		exit 1
		end
	cmd="/usr/bin/barman recover #{project.getName} #{lastbck} --remote-ssh-command \"ssh root@#{config['vtlserver']}\" #{tmppath}"
	bmcommand(cmd,project)
###

	bmbckdate=lastbck[0,8] #obtiene la fecha del backup cargado actualmente
        if (tmppath.count "/") >= 3
	cmd="chown -R postgres: #{tmppath} && chmod -R 0700 #{tmppath} "
	vtlcommand(cmd,config)
	end

	cmd="cat #{tmppath}/PG_VERSION"  #obtiene la version del postgres de la version cargada
	pgversion=vtlcommand(cmd,config)

	if pgversion[0]=0
		pgversion=pgversion[1]
	else
		p "Error en obtener la version de postgres para el backup de #{project.getName}"
		exit 1
	end	
	pgbin="/usr/pgsql-#{pgversion.gsub("\n","")}/bin/"
	cmd="killall -9 postgres &> /dev/null || exit 0 "
	vtlcommand(cmd,config)
	ipvtl=local_ip
	cmd="echo \"host    all         all        #{ipvtl}/32      trust\" > #{tmppath}/pg_hba.conf" #Agrega la execion desde el rundeck al hba
	vtlcommand(cmd,config)
	cmd="#{pgbin}pg_ctl start -D #{tmppath} >/dev/null"
	out=vtlpgcommand(cmd,config)
	if out[0] != 0
		print "FAIL\tLa base de datos retorno un error en la subida para #{tmppath}"
		exit 3
	end

	sleep 10
	limit=2
	cmd="egrep -qs \"ready to accept|listo para aceptar conexiones\" #{tmppath}/pg_log/*.log > /dev/null"
	while limit >= 2
		out=vtlpgcommand(cmd,config)
		if out[0].to_i != 0
		sleep 20
		limit=limit+1
		else
		dbs=pgVtlSelect(sqlListDatabases,[10],config['vtlserver'],'postgres')
		limit=0
		end
	end

	if dbs.length < 1
		p "El backup no contiene bases de datos"
		pgInsert(sqlInsertBackupError,[project.getId,bmbckdate])
		exit 1
	end


	dbs.length.times do | i |	#recorre las bases de datos
		queries=""
		p dbs[i]
		queries=pgRundeckSelect(sqlGetQueriesForCheck,[dbs[i]])
		if queries.length >= 1
		queries.length.times do | j |	#recorre las queries cargadas segun cada tipo de DB
		result=""
		result=pgVtlNoParamSelect(queries[j],config['vtlserver'],dbs[i])   # prueba cada querie en el backup cargado
			if result[0]!="t"
	                pgInsert(sqlInsertBackupError,[project.getId,bmbckdate])   #inserta fracaso en la base de datos de control
			print "FAIL\ten la query #{queries[j]}\n"
			exit 1
			else
			print "OK\ten la query #{queries[j]}\n"
			end
		end
		else
		print "FAIL\tNo existen al menos una query cargada en la tabla query_check para la base de datos #{dbs[i]}\n"
		exit 3
		end
	end

        pgInsert(sqlInsertBackup,[project.getId,bmbckdate])     #inserta exito en la base de datos de control para elbackup completo
        print "OK\ten ejecucion de todas las queries para el proyecto ID:#{project.getId}\tNombre:#{project.getName}\n"

        if (tmppath.count "/") >= 3
	        cmd="#{pgbin}pg_ctl stop -m f -D #{tmppath} >/dev/null"
	        vtlpgcommand(cmd,config)
		cmd="rm -rf #{tmppath}"
		vtlcommand(cmd,config)

        else
                p "No se ha podido borrar la ruta temporal ya que parece que es muy corta  #{tmppath}"
                exit 3
        end


end
