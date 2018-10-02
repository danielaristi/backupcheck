#!/bin/ruby

require 'rubygems'
require 'net/ssh'
require 'etc'
require 'yaml'
load 'class.rb'

def command (cmd,config)
Net::SSH.start(config['server'],config['amuser'], :password=> config['ampass']) do |ssh|
t=ssh_exec!(ssh,cmd)
std=Stdget.new(t[0],t[1],t[2],t[3])
output=nil
error=nil

if std.get_exit_signal != nil 
	error=std.get_exit_signal
else 
	error=std.get_exit_code
end

if error != 0
        puts std.get_stderr_data
	exit error
end
if std.get_stdout_data != nil
	output=std.get_stdout_data
	return output
end
end
end


def amcommand (cmd,project)
config=YAML::load_file('server.conf')
config=config[project.getServer.gsub(".areaprod.b2b","")]
Net::SSH.start(config['server'],config['amuser'],:password=>config['ampass']) do |ssh|
t=ssh_exec!(ssh,cmd)
std=Stdget.new(t[0],t[1],t[2],t[3])
output=nil
error=nil

#p "------------------------"
#print t[0].to_s+"\n"
#print t[1].to_s+"\n"
#print t[2].to_s+"\n"
#print t[3].to_s+"\n"
#p "------------------------"


if std.get_exit_signal != nil
        error=std.get_exit_signal
else
        error=std.get_exit_code
end

if error != 0
        print std.get_stderr_data
        return error
end
if std.get_stdout_data != nil
        output=std.get_stdout_data
	return output
end
end
end

def vtlcommand(cmd,config)
keys = ["/var/lib/rundeck/.ssh/id_rsa"]
Net::SSH.start(config['vtlserver'],config['user'], :keys => keys) do |ssh|
t=ssh_exec!(ssh,cmd)
std=Stdget.new(t[0],t[1],t[2],t[3])
output=nil
error=nil

if std.get_exit_signal != nil
        error=std.get_exit_signal
else
        error=std.get_exit_code
end

if error != 0
        print std.get_stderr_data
end
if std.get_stdout_data != nil
        output=std.get_stdout_data
end
       return error,output
end
end

def ssh_exec!(ssh, command)
  stdout_data =""
  stderr_data =""
  exit_code = nil
  exit_signal = nil
  ssh.open_channel do |channel|
    channel.exec(command) do |ch, success|
      unless success
        abort "FAILED: couldn't execute command (ssh.channel.exec)"
      end
      channel.on_data do |ch,data|
        stdout_data+=data
      end

      channel.on_extended_data do |ch,type,data|
        stderr_data+=data
      end

      channel.on_request("exit-status") do |ch,data|
        exit_code = data.read_long
      end

      channel.on_request("exit-signal") do |ch, data|
        exit_signal = data.read_long
      end
    end
  end
  ssh.loop
        [stdout_data,stderr_data,exit_code,exit_signal]
end


def bmcommand (cmd,project)
config=YAML::load_file('server.conf')
config=config[project.getType]
keys = ["/var/lib/rundeck/.ssh/id_rsa"]
Net::SSH.start(config['server'],config['barmanuser'], :keys => keys) do |ssh|
#Net::SSH.start(config['server'],config['barmanuser'],:password=>config['barmanpass']) do |ssh|
t=ssh_exec!(ssh,cmd)
std=Stdget.new(t[0],t[1],t[2],t[3])
output=nil
error=nil


if std.get_exit_signal != nil
        error=std.get_exit_signal
else
        error=std.get_exit_code
end

if error != 0
        print std.get_stderr_data
        return error
end
if std.get_stdout_data != nil
        output=std.get_stdout_data
        return output
end
end
end

def vtlpgcommand (cmd,config)
keys = ["/var/lib/rundeck/.ssh/id_rsa"]
Net::SSH.start(config['vtlserver'],'postgres', :keys => keys) do |ssh|
t=ssh_exec!(ssh,cmd)
std=Stdget.new(t[0],t[1],t[2],t[3])

output=nil
error=nil

if std.get_exit_signal != nil
        error=std.get_exit_signal
else
        error=std.get_exit_code
end

if error != 0
        p std.get_stderr_data
end
if std.get_stdout_data != nil
        output=std.get_stdout_data
end
       return error,output
end
end


