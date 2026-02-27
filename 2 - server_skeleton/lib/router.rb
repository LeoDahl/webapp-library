class Router
  
  attr_reader :initialized_routes

  def initialize()
    @initialized_routes = []
  end

  def add_route(method, resource, &block)

    regex = convert_resource_to_regex()

    new_route = Hash.new
    new_route["method"] = method
    new_route["resource"] = resource
    new_route["param_index"] = get_param_index_from_resource(resource)
    new_route["blocks"] = block
    @initialized_routes << new_route
    p "New route added : #{@initialized_routes}"
    new_route
  end

  def handle_resource(resource)
    method = resource.get_method
    resource = resource.get_resource

    requested_route = @initialized_routes[method][resource] 
    p @initialized_routes

    if requested_route
      p "route exist"
      requested_route["blocks"].call()
    else
      p "route does not exist"
    end
  end

  private 
  
  def convert_resource_to_regex(resource)
    p "resource = #{resource}"

    if !resource.include?(":")
      p "no index"
      return nil
    end

    split = resource.split("/")
    p split
    split.each_with_index do |section, index| 
      # /ok/:id/test
      # ^\/ok (?<:id>\w+) test
      if section[0] == ":"
        section = "(?<#{section}>\\w+)"
      end 
      regex += section + "/"
      
    end
    regex += "$"
    final = Regexp.new("\\^" + regex)
    return final
  end
end

