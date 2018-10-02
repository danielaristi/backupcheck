
#SERVERJENKINS=ARGV[0]
SERVERJENKINS="jenkins-mandb.areaprod.b2b"

def getjson(url)
#uri = URI.parse("http://#{SERVERJENKINS}:8080/api/json?tree=jobs[name,color]")
uri = URI.parse("http://#{SERVERJENKINS}:8080#{url}")
request = Net::HTTP::Get.new(uri)
request.basic_auth("daristizabal", "colombia2016-")
req_options = {
  use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
    end
data=JSON.parse(response.body)

if data.length>0
return data
else
p "Se ha obtenido un valor vacio desde el jenkins"
exit 0
end
end

SCHEDULER.every '2s' do

@client = JenkinsApi::Client.new(:server_ip => 'jenkins-mandb.areaprod.b2b',
         :username => 'daristizabal', :password => 'colombia2016-')
# The following call will return all jobs matching 'Testjob'
jobs=@client.job.list("^*")

array=Array.new
jobs.length.times do |i|
x=getjson("/job/#{jobs[i]}/lastBuild/api/json?tree=result,timestamp,estimatedDuration")

if x['result']=='FAILURE'
array.push x
end
end
j=array[0]
p j['result']

#send_event('buzzwords', { items: buzzword_counts.values })


#  send_event('valuation', { current: current_valuation, last: last_valuation })
#  send_event('karma', { current: current_karma, last: last_karma })
#  send_event('synergy',   { value: rand(100) })
end
