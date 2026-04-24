require_relative "response.rb"

class Router
  
  attr_reader :initialized_routes

  def initialize()
    @responseHandler = Response.new()
    @initialized_routes = []
  end

  def add_route(method, resource, &block)
    regex = convert_resource_to_regex(resource)

    new_route = Hash.new
    new_route["method"] = method
    new_route["resource"] = resource
    new_route["regex"] =  regex
    new_route["blocks"] = block
    @initialized_routes << new_route
    new_route
  end

  def handle_post_resource(request, params)
    resource = request.resource

    @initialized_routes.each do |route|
      if route["regex"] && route["regex"].match(resource) 
        p "matched #{route["regex"]} with #{resource}"
        call = route["blocks"].call(params)
      end
    end
  end

  def handle_resource(resource)
    resource = resource.resource
    if resource == nil then return end
    @initialized_routes.each do |route|
      if route["regex"] && route["regex"].match(resource) 
        match = route["regex"].match(resource).captures
        hashmatch = Hash.new(match)
        call = route["blocks"].call(match)
        @responseHandler.build(call)
        return call  
      end
    end
    return resource
  end

  private 
  
  

  def convert_resource_to_regex(resource)
  resource = "^#{resource}$"
  resource.split("/").each do |l|
    if l[0] == ":"
      name = l[1..]
      resource.gsub!(l, "(?<#{name}>" + '\w+)')
    end
  end
  Regexp.new(resource)
end
end

