#!/bin/ruby

load 'error.rb'
load 'pgsql.rb'
load 'query.rb'
load 'class.rb'
require 'pathname'

def getAmandaProjects(server)
config=YAML::load_file('server.conf')
config=config[server]
cmd="grep tapedev /etc/amanda/*/amanda.conf|grep -v '#'|awk -F: '{print $3}'|sed -e 's/\\/\"//g' -e 's/\"//g'"
paths=command(cmd,config)
paths.each_line do |line|
	path=line.gsub("\n","")
	project=line.gsub("/slots","").gsub("\n","")
	project=[File.basename(project)]
if pgExists(sqlProjectExists,project)==false
	pgInsert(sqlProjectInsert,[project.join(),path,config['type'],config['server']])
	end
	
end
end

def getBarmanProjects(server)

config=YAML::load_file('server.conf')
config=config[server]
cmd="list=$(barman list-server|awk '{print $1}');for x in $list; do barman show-server $x|grep backup_directory|awk '{print $2}'; done;"
paths=command(cmd,config)
paths.each_line do |line|
	path=line.gsub("\n","")
	project=line.gsub("\n","")
	project=[File.basename(project)]
if pgExists(sqlProjectExists,project)==false
	pgInsert(sqlProjectInsert,[project.join(),path,config['type'],config['server']])
	end
end
end

def checkDuplicateAmanda(server1,server2)
config=YAML::load_file('server.conf')
config1=config[server1]
cmd="cd /etc/amanda; ls"
paths1=command(cmd,config1)
config2=config[server2]
cmd="cd /etc/amanda; ls"
paths2=command(cmd,config2)
a1=paths1.gsub("\n"," ").split(" ")
a2=paths2.gsub("\n"," ").split(" ")
	a1.length.times do |i|
		a2.length.times do |j|
			if a1[i]==a2[j]
			p "El proyecto #{a1[i]}==#{a2[j]} se encuentra duplicado en los amanda"
			exit 3
			end
		end
	end
end
