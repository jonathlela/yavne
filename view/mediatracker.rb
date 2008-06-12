require "view/image.rb"
require "view/text.rb"

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
        case render.type
          when "image"
          render = Image.new(render.image)
          when "text"
          render = Text.new(render.text,render.color,render.font,render.size)
        end
          @renderables[id] = render
        return render
      end
    end

  end

end
