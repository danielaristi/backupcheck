#!/bin/ruby

load 'class.rb'
load 'error.rb'
require 'timeout'

def getAmProject(project)

vtlpath="/storage/certificador2/"

	p "bandera"

	date=Time.now.strftime("%Y%m%d")
	cmd="ls #{project.getPath} > /dev/null"
	amcommand(cmd,project)
	tmppath="#{project.getPath}/tmp/#{project.getName}#{date}"
	cmd="mkdir -p #{tmppath}"
	amcommand(cmd,project)
	cmd="x=$(mktemp);/usr/sbin/amtape #{project.getName} show 2>$x; grep date $x |awk '{print $4\" \"$1$2}'|sed -e 's/://g'|sort -r|awk '{print $2\" \"$1}'| head -n 1; rm -f ${mktemp} > /dev/null"
	slotdatetmp=amcommand(cmd,project)
	
	p cmd
	
	p slotdatetmp
	p slotdatetmp.gsub("\n","").split(" ")

	slotdate=slotdatetmp.gsub("\n","").split(" ")



	cmd="/usr/sbin/amtape #{project.getName} #{slotdate[0].gsub("slot","slot ")}"
	amcommand(cmd,project)
	
#	cmd="(/usr/sbin/amverify #{project.getName})"
#	elsif project.getServer == 'amanda.areaprod.b2b'
#	cmd="(/usr/sbin/amcheckdump #{project.getName})"
#	end
#	print "FAIL\tError en amverify o amcheckdump para #{project.getName} por timeout\n"
#        pgInsert(sqlInsertBackupError,[project.getId,slotdate[1].to_s[0..7]])
#	status[0]=1
#	end

		cmd="cd #{tmppath} && /usr/sbin/amrestore file:#{project.getPath} &>/dev/null"
		status=amcommand(cmd,project)
		if status[0].to_i != 0 and project.getServer == 'amanda.areaprod.b2b'
		print "FAIL\tError en amrestore en #{slotdate[0]} para #{project.getName}\n"
		pgInsert(sqlInsertBackupError,[project.getId,slotdate[1].to_s[0..7]])
		end
#	cmd="du -sk #{tmppath} | awk '{ print $1 / 1024/1024 }'"
#	cmd="ls #{tmppath}|awk '{print \"tar tvf \"$1}'|sh|awk '{ SUM += $3} END { print (SUM/1024/1024/1024)*1.1 }'"
#	p cmd
#	puts amcommand(cmd,project)
#	p "espacio de backup"

##########agregar logica de seleccion de particion en destino vtl.areaprod.b2b
        
		if status[0].to_i == 0 or project.getServer == 'amanda-db.areaprod.b2b'
		cmd="scp -r #{tmppath} root@certificador.areaprod.b2b:#{vtlpath}"
	        status=amcommand(cmd,project)
			if status[0].to_i!=0
			print "FALLO\tNo se pudo copiar el archivo a root@certificador.areaprod.b2b:#{vtlpath}\n"
			exit 3
			end
			if (tmppath.count "/") >= 6
				cmd="rm -rf #{tmppath}"
				amcommand(cmd,project)
				return vtlpath+File.basename(tmppath)
			else
				p "No se ha podido borrar la ruta temporal ya que parece que es muy corta  #{tmppath}"
				exit 3
			end
		end
	end
