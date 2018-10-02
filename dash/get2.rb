#!/bin/ruby

require "json"
require 'net/http'
require 'uri'

uri = URI.parse("http://jenkins-mandb.areaprod.b2b:8080/api/json?tree=jobs[name,color]")
request = Net::HTTP::Get.new(uri)
request.basic_auth("daristizabal", "colombia2016-")

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

data=JSON.parse(response.body)

p data["name"]
