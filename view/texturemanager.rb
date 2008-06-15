require "view/renderable.rb"

module View

  class TextureManager

    def initialize()
      @textures = Hash.new()
      @counter = 0
    end

    def load(element)
      if element.compound? then
        element.elements.each { |elt|
          load(elt)
        }
      else
        id = element.id
        if !@textures.has_key?(id) then
          @textures[id] = @counter
          element.texturize(@counter)
          @counter += 1
        end        
      end
    end
    
    def get(element)
      @textures[element.id]
    end

  end

end
