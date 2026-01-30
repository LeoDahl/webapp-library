require_relative '../lib/request'

#request_string = File.read('../get-fruits-with-filter.request.txt')
request_string = File.read('../post-login.request.txt')
request = Request.new(request_string: request_string)


p request.params   #=> {'username' => 'grillkorv', 'password' => 'verys3cret!'}