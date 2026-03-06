class Response 
  
  def initialize()
    @public = "./public/"
    @file_to_resource = Hash.new()
  end

  def load(file, resource)
    path = @public + file
    @file_to_resource[resource] = path
    p "file_to_resource = #{@file_to_resource}"
  end
  def build(resource, session)
    path = @file_to_resource[resource]

    if path
      p "path to build = #{path}"

      if File.exist?(path)
        content = File.binread(path)
        content_type = "text/html"

        return content, content_type
      end


    end
  end

end