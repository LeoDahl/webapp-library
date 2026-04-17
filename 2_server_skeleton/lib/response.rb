class Response 
  
  def initialize()
    @public = "./public"
    @file_to_resource = Hash.new()
  end

  def load(file)
    path = @public + file
    @file_to_resource[resource] = path
    #p "file_to_resource = #{@file_to_resource}"
  end



  def build(resource)
   # p "build ran"
    #p "resource = #{resource}"

    file = @public + resource

    if @file_to_resource[resource]  
      #p "resource found binded to block"
      build_from_block(resource)
    elsif File.exist?(file) and File.directory?(file) == false
      filetype = detect_filetype(resource)
      content = File.binread(file)
      content_type = get_content_type(resource)
      return content, content_type 
    else
      content = File.binread("./public/html/404.html")
      content_type = "text/html"
      return content, content_type
    end
  end

  private

  def detect_filetype(path)
    newpath = path.split(".")
    return newpath[-1]
  end
  def get_content_type(type)
   # p "GET CONTENT TYPE IS RAN"
    valid_image_files = ["jpeg","png","jpg"]

    if type == "jpg"
      return "image/png"
    end
  end
  def build_from_block(resource)
    path = @file_to_resource[resource]

    if path 
      #p "path is real"

      if File.exist?(path)
        content = File.binread(path)
        content_type = "text/html"

        return content, content_type
      end
    end
  end

end