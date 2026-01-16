require_relative 'spec_helper'
require_relative '../lib/request'

class RequestTest < Minitest::Test
  def test_request_is_class
    request_string = File.read('../get-index.request.txt')
    request = Request.new(request_string: request_string)
    assert(request.kind_of? Object)
  end
  def test_parses_http_method_from_simple_get
    request_string = File.read('../get-index.request.txt')
    request = Request.new(request_string: request_string)
    assert_equal 'GET', request.method
  end
 def test_parses_resource_from_simple_get
   request_string = File.read('../get-index.request.txt')
   request = Request.new(request_string: request_string)
   assert_equal '/', request.resource
 end
 def test_value_exists
   request_string = File.read('../get-index.request.txt')
   request = Request.new(request_string: request_string)
   refute_nil request.method
 end
 def test_value_if_nil
   request_string = File.read('../get-index.request.txt')
   request = Request.new(request_string: request_string)
   refute_nil request.method, "Method returns nil"
   refute_nil request.resource, "Resource returns nil"
   refute_nil request.version, "Version returns nil"
   refute_nil request.params, "Parameters returns nil"
   refute_nil request.headers, "Headers returns nil"
 end

end