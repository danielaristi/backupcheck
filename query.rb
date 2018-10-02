#!/bin/ruby

def sqlProjectExists()
string="select id from project where name=$1"
return string
end

def sqlProjectInsert()
string="insert into project (id,name,path,type,server) values (default,$1,$2,$3,$4)"
return string
end

def sqlProjectWithoutCheck()
string="select * from project where id not in (select id_project from backup) limit $1"
return string
end

def sqlProjectOldCheck()
string="with max as(select id_project,max(date_checked) from backup group by id_project order by max limit $1) select id,name,path,type,server from project p,max m where p.id=m.id_project"
return string
end

def sqlInsertBackup()
string="insert into backup values (default,$1,$2,now(),true);"
return string
end

def sqlInsertBackupError()
string="insert into backup values (default,$1,$2,now(),false);"
return string
end

def sqlListDatabases()
string="select datname as \"1\" from pg_database where datname not in ('template1','template0','postgres','replication') limit $1;"
return string
end

def sqlGetQueriesForCheck()
string="select query as \"1\" from query_check qc, type_db t where  t.id=qc.id_type and t.name=$1;"
return string
end




