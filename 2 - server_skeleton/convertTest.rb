def convert_resource_to_regex(resource)
  p "resource = #{resource}"

  regex = "^"
  if !resource.include?(":")
    p "no index"
  end

  split = resource.split("/")
  p split
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
  regex += "$"
  p regex
  final = Regexp.new(regex)
  return final
end

regexToMatch =  convert_resource_to_regex("/hello/:id/ok/")
resource = "/hello/Value/ok/"

p regexToMatch
p regexToMatch.match(resource)
