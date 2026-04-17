require_relative 'spec_helper'

def convert_resource_to_regex(resource)
  p "resource = #{resource}"

  
end

def test2(resource)
  parts = resource.split("/")
  parts = parts.reject! {|p| p.empty?}

  if resource == "/"
   # p "empty route"
    return Regexp.new("/")
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
  p parts.join("/")
  p Regexp.new("^\/#{parts.join("/")}$")
  #Regexp.new(parts.join("/"))
end


reg = test2("/ok/:capture/test")
p reg.match("/ok/skibidi/test")