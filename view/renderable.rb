require 'opengl'
require "view/positionnable.rb"

module View

  class Renderable
    
    attr_reader :w, :h

    include Positionnable

    def fully_rendered?()
      return @rendered
    end

    def compound?()
      return @compound
    end

  end

  class SingleRenderable < Renderable

    attr_reader :pixels

    def initialize()
      @compound = false
      @rendered = true
    end

    def render(i,x=@x,y=@y)
      GL.Enable(GL::TEXTURE_2D)
      GL.PushMatrix()
      GL.BindTexture(GL::TEXTURE_2D,i)
      GL.Begin(GL::QUADS)
      GL.Color4f(1.0,1.0,1.0,1.0)
      GL.TexCoord(0,0)
      GL.Vertex(x,y,0)
      GL.TexCoord(1,0)
      GL.Vertex(x+@w,y,0)
      GL.TexCoord(1,1)
      GL.Vertex(x+@w,y+@h,0)
      GL.TexCoord(0,1)
      GL.Vertex(x,y+@h,0)
      GL.End()
      GL.PopMatrix()
      GL.Disable(GL::TEXTURE_2D)
      return i + 1
    end
    
  end
  
  class CompoundRenderable < Renderable
    
    attr_reader :elements, :render_elements

    def initialize()
      @compound = true
    end

    # Won't work for multi compound elements!
    # Must do a real texture manager

    def render(i,x=@x,y=@y)
      @elements.each { |elt|
        if @render_elements.include? elt then
          i = elt.render(i)
        else
          i += 1 # Work only if skipped element was single
        end
      }
      return i
    end

    def texturize(i)
      @elements.each { |elt|
        i = elt.texturize(i)
      }
      return i
    end
    
  end
  

end
