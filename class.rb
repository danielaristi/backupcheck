#!/bin/ruby

class Project
        def initialize(id,name,path,type,server)
        @id=id
        @name=name
        @path=path
        @type=type
	@server=server
        end
	
	def getName
        return @name
	end

	def getId
        return @id
        end

	def getType
	return @type
	end

	def getPath
	return @path
	end

	def getServer
	return @server
	end

end

class Stdget
        def initialize(stdout_data,stderr_data,exit_code,exit_signal)
        @stdout_data=stdout_data
        @stderr_data=stderr_data
        @exit_code=exit_code
        @exit_signal=exit_signal
        end

        def get_stdout_data
        return @stdout_data
        end

        def get_stderr_data
        return @stderr_data
        end

        def get_exit_code
        return @exit_code
        end

        def get_exit_signal
        return @exit_signal
        end

end

