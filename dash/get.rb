#!/bin/ruby

require 'net/http'
require 'uri'
require 'json'

JENKINS="http://jenkins-mandb.areaprod.b2b"
PORT=8080

#uri = URI.parse("http://jenkins-inf.areaprod.b2b:8080/job/snapshot/lastSuccessfulBuild/api/json")
#uri = URI.parse("http://jenkins-inf.areaprod.b2b:8080/api/json?pretty=true")
#request = Net::HTTP::Get.new(uri)
#request.basic_auth("daristizabal", "colombia2016-")

#req_options = {
#  use_ssl: uri.scheme == "https",
#}

#response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
#http.request(request)
#end

#response.code
#response.body
j=`curl -s --globoff --user daristizabal:colombia2016- http://jenkins-mandb.areaprod.b2b:8080/api/json?tree=jobs[name,color]`
jobs=JSON.parse(j)

jobs['name']['color'].each do |child|
    puts child['name']['color']
end

