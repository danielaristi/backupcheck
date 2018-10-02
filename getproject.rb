#!/bin/ruby

require 'yaml'
require 'pathname'
load 'error.rb'
load 'pgsql.rb'
load 'class.rb'
load 'amget.rb'
load 'barmanget.rb'

def getNextProject()
	config=YAML::load_file('server.conf')
	project=pgGetProjectToCheck()
	config=config[project.getServer.gsub(".areaprod.b2b","")]

	print "#{project.getName}\t#{project.getServer}\t#{project.getType}\n"

	if project.getType=='amanda'
		
		vtlpath=getAmProject(project).to_s+"/"
		if project.getServer=='amanda.areaprod.b2b'
			cmd="ls #{vtlpath}*.?.* |head -n 1|rev|cut -c 17-|cut -c -8|rev"
		elsif project.getServer=='amanda-db.areaprod.b2b'
			cmd="ls #{vtlpath}*.? |head -n 1|rev|cut -c 3-|cut -c -8|rev"
		else
			print "FAIL\tEl proyecto #{project.getName} no corresponde a amanda.areaprod.b2b ó amanda-db.areaprod.b2b"
			exit 3
		end
		bckdate=vtlcommand(cmd,config)[1].gsub("\n","")

		cmd="cd #{vtlpath} && ls *.? |awk '{print \"tar xvf #{vtlpath}\"$1}'|sh"
		retval=vtlcommand(cmd,config)[0] #posicion 0 de error estandar, 1 de salida estandar
	        if (vtlpath.count "/") >= 3
                cmd="rm -rf #{vtlpath}"
                vtlcommand(cmd,config)
	        else
                p "No se ha podido borrar la ruta temporal en vtl que parece que es muy corta  #{vtlpath}"
                exit 3
	        end
		if retval==0
		pgInsert(sqlInsertBackup,[project.getId,bckdate])
		else
		p "El resplado del proyecto #{project.getName} genero error en la extraccion del tar se guarda registro en DB como fallido"
		pgInsert(sqlInsertBackupError,[project.getId,bckdate])
		exit retval
		end

	elsif project.getType=='barman'
		getBarmanProject(project)
	end
	


end

