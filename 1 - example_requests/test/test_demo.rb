require_relative '../lib/request'


request_string = File.read('../get-index.request.txt')
request = Request.new(request_string: request_string)
