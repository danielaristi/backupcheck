u:Gem::Specification�[I"
2.6.2:ETi	I"pg; TU:Gem::Version[I"0.20.0; TIu:	Time@I�    :	zoneI"UTC; FI"SPg is the Ruby interface to the {PostgreSQL RDBMS}[http://www.postgresql.org/]; TU:Gem::Requirement[[[I">=; TU;[I"
2.0.0; TU;	[[[I">=; TU;[I"0; TI"	ruby; T[o:Gem::Dependency
:
@nameI"hoe-mercurial; T:@requirementU;	[[[I"~>; TU;[I"1.4; T:
@type:development:@prereleaseF:@version_requirementsU;	[[[I"~>; TU;[I"1.4; To;

;I"hoe-deveiate; T;U;	[[[I"~>; TU;[I"0.7; T;;;F;U;	[[[I"~>; TU;[I"0.7; To;

;I"hoe-highline; T;U;	[[[I"~>; TU;[I"0.2; T;;;F;U;	[[[I"~>; TU;[I"0.2; To;

;I"	rdoc; T;U;	[[[I"~>; TU;[I"4.0; T;;;F;U;	[[[I"~>; TU;[I"4.0; To;

;I"rake-compiler; T;U;	[[[I"~>; TU;[I"
1.0.3; T;;;F;U;	[[[I"~>; TU;[I"
1.0.3; To;

;I"rake-compiler-dock; T;U;	[[[I"~>; TU;[I"
0.6.0; T;;;F;U;	[[[I"~>; TU;[I"
0.6.0; To;

;I"hoe; T;U;	[[[I"~>; TU;[I"	3.12; T;;;F;U;	[[[I"~>; TU;[I"	3.12; To;

;I"hoe-bundler; T;U;	[[[I"~>; TU;[I"1.0; T;;;F;U;	[[[I"~>; TU;[I"1.0; To;

;I"
rspec; T;U;	[[[I"~>; TU;[I"3.0; T;;;F;U;	[[[I"~>; TU;[I"3.0; T0[I"ged@FaerieMUD.org; TI"lars@greiz-reinsdorf.de; T[I"Michael Granger; TI"Lars Kanis; TI"5Pg is the Ruby interface to the {PostgreSQL RDBMS}[http://www.postgresql.org/].

It works with {PostgreSQL 9.1 and later}[http://www.postgresql.org/support/versioning/].

A small example usage:

  #!/usr/bin/env ruby

  require 'pg'

  # Output a table of current connections to the DB
  conn = PG.connect( dbname: 'sales' )
  conn.exec( "SELECT * FROM pg_stat_activity" ) do |result|
    puts "     PID | User             | Query"
    result.each do |row|
      puts " %7d | %-16s | %s " %
        row.values_at('procpid', 'usename', 'current_query')
    end
  end; TI"&https://bitbucket.org/ged/ruby-pg; TT@[I"BSD-3-Clause; T{ 