class Router
  
  attr_reader :initialized_routes

  def initialize()
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

  def handle_resource(resource)
    method = resource.method
    resource = resource.resource

    @initialized_routes.each do |route|
      if route["regex"] && route["regex"].match(resource) 
        match = route["regex"].match(resource).captures
    

        route["blocks"].call(match)
      end
    end
  end

  private 
  

  def convert_resource_to_regex(resource)
    regex = "^"
  
    split = resource.split("/")
    split.each_with_index do |section, index| 
      # /ok/:id/test
      # ^\/ok (?<:id>\w+) test
      if section[0] == ":"
        section = "(?<#{section}>\\w+)"
      end 
      
      if !section != ""  
        regex += section + "/" 
      end
      
    end
    regex += "?$"
    final = Regexp.new(regex)
    return final
  end
end

