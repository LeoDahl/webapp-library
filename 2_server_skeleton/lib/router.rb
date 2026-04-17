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
   # p new_route

    new_route
  end

  def handle_post_resource(request, params)
    #p "Begin handling of post resource"
    #p "handle_post params: #{params}"
    #p "handle_post resource: #{request.resource}"
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

    p "HR resource = #{resource}"

    @initialized_routes.each do |route|
      #p "#{route["regex"]} tried to match with #{resource}"
      if route["regex"] && route["regex"].match(resource) 
        match = route["regex"].match(resource).captures
       # p "match with #{match}"
        #binding.break
       # p route["regex"]
       # p "call is handled"
        hashmatch = Hash.new(match)
        call = route["blocks"].call(match)
       # p "call is #{call}"
       # p "handler resource call is #{resource}"
        @responseHandler.build(call)
        return call  
      end
    end
    #p "potentially a file?"
    return resource
  end

  private 
  
  

  def convert_resource_to_regex(resource)
    parts = resource.split("/")
    parts = parts.reject! {|p| p.empty?}

    if resource == "/"
     # p "empty route"
      return Regexp.new("^/$")
    end
    parts.map! do |part|
     # p part
      #resource.gsub(/:(\w+)/, "?(<#{$1}>)\w+")

      if part[0] == ":"
        name = part[1..]
        "(?<#{name}>" + '\w+)'
      else
        part
      end
    end
    #p parts.join("/")
    Regexp.new("^\/#{parts.join("/")}$")
    #Regexp.new(parts.join("/"))
    end
end

