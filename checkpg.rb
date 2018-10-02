#!/bin/ruby

load 'class.rb'
load 'error.rb'

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

	p lastbck

	lastbck=bmcommand(cmd,project).gsub("\n","")
		
	p cmd

	cmd="/usr/bin/barman recover #{project.getName} #{lastbck} --remote-ssh-command \"ssh root@#{config['vtlserver']}\" #{tmppath}"
	bmcommand(cmd,project)
	exit 0


        if (tmppath.count "/") >= 6
                cmd="rm -rf #{tmppath}"
                amcommand(cmd,project)
                return vtlpath+File.basename(tmppath)
        else
                p "No se ha podido borrar la ruta temporal ya que parece que es muy corta  #{tmppath}"
                exit 3
        end



end
