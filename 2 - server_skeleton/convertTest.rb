def convert_resource_to_regex(resource)
  p "resource = #{resource}"

  regex = "^"
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
  final = Regexp.new(regex)
  return final
end

p convert_resource_to_regex("/hello/:id/ok")