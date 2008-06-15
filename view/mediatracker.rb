require "view/image.rb"
require "view/text.rb"
require "view/textbox.rb"

module View

  class MediaTracker

    def initialize()
      @renderables = Hash.new()
      @musics = Hash.new()
    end

    def get_renderable(render)
      id = render.id
      if @renderables.has_key?(id) then
        return @renderables[id]
      else
        if render.compound? then
          case render.type
          when "textbox"
            boxid = render.box.id
            if @renderables.has_key?(boxid) then
              box = @renderables[boxid]
            else
              box = Image.new(render.box.path)
              @renderables[boxid] = box
            end
            render = Textbox.new(box,render.texts)
          end
        else
          case render.type
          when "image"
            render = Image.new(render.path)
          when "text"
            render = Text.new(render.text,render.color,render.font,render.size)
          end
        end
        @renderables[id] = render
        return render
      end
    end
    
  end
  
end
