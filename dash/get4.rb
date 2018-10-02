#!/bin/ruby

require 'jenkins-json-api'

jenkins = Jenkins::Jenkins.new 'jenkins-mandb.areaprod.b2b:8080'


jenkins.get_all_jobs.each do |job|
  if job.name =~ /myjobpattern/
    puts job.name
    job.build_async # sending request async, useful if there is many job
  end
end
