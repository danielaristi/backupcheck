#!/bin/ruby

require 'pg'
load 'class.rb'

def pgExists (query,params) 
conn = PG.connect( :host=>'localhost', :dbname=>'rundeck', :user=>'postgres', )
conn.prepare('statement1',query)
res=conn.exec_prepared('statement1',params)
conn.close
if res.ntuples > 0
return true
else
return false
end
end

def pgGetProjectToCheck ()
conn = PG.connect( :host=>'localhost', :dbname=>'rundeck', :user=>'postgres', )
conn.prepare('statement1',sqlProjectWithoutCheck)
result=conn.exec_prepared('statement1',[1])
if result.ntuples>0
	result.each do |row|
		conn.close
		project=Project.new(row['id'],row['name'],row['path'],row['type'],row['server'])
		return project
		end
else
conn.prepare('statement2',sqlProjectOldCheck)
result=conn.exec_prepared('statement2',[1])
        result.each do |row|
                conn.close
		project=Project.new(row['id'],row['name'],row['path'],row['type'],row['server'])
                return project
                end
end
raise "NO EXISTEN CARGADOS PROYECTOS EN LA BASE DE DATOS"
end

def pgInsert(query,params)
conn = PG.connect( :host=>'localhost', :dbname=>'rundeck', :user=>'postgres', )
conn.prepare('statement1',query)
conn.exec_prepared('statement1',params)
conn.close
end

def pgVtlSelect(query,params,server,db)

conn = PG.connect( :host=>"#{server}", :dbname=>"#{db}", :user=>'postgres')
conn.prepare('statement1',query)
result=conn.exec_prepared('statement1',params)
value=Array.new
result.each do |row|
value.push row['1']
end
conn.close
return value
end

def pgVtlNoParamSelect(query,server,db)

conn = PG.connect( :host=>"#{server}", :dbname=>"#{db}", :user=>'postgres')
result=conn.exec(query)
value=Array.new
result.each do |row|
value.push row['1']
end
conn.close
return value
end

def pgRundeckSelect(query,params)
conn = PG.connect( :host=>'localhost', :dbname=>'rundeck', :user=>'postgres')
conn.prepare('statement1',query)
result=conn.exec_prepared('statement1',params)
value=Array.new
result.each do |row|
value.push row['1']
end
conn.close
return value
end
