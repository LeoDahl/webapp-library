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


def gsubtest(resource)
  resource = "^#{resource}$"
  resource.split("/").each do |l|
    if l[0] == ":"
      name = l[1..]
      resource.gsub!(l, "(?<#{name}>" + '\w+)')
    end
  end
  Regexp.new(resource)
end

string = "/skibidi/:one/:two"

a = convert_resource_to_regex(string)
p a 
p a.match("/skibidi/hello/bye")
#gsubtest("hello/test/:skibidi/test")