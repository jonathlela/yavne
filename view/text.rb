require 'sdl'
require 'opengl'

module View

  class Text < SingleRenderable

    attr_reader :text, :color, :font, :size

    def initialize(text,color,font,size)
      super()
      @text = text
      @color = color
      @font = font
      @size = size
      update()
    end
    
    def update()
      font = SDL::TTF.open(@font,@size)
      w,h = font.text_size(@text)
      rmask = 0xff000000
      gmask = 0x00ff0000
      bmask = 0x0000ff00
      amask = 0x000000ff
      mask =SDL::Surface.new(
                             SDL::HWSURFACE,
                             w, h, 32,
                             amask,bmask,gmask,rmask)
      mask.fill_rect(0,0, w,h, [0,0,0,255])
      font.drawBlendedUTF8(mask,@text,0,0,255,255,255)
      text = SDL::Surface.new(
                              SDL::HWSURFACE,
                              w, h, 32,
                              amask,bmask,gmask,rmask)
      text.fill_rect(0,0,w,h, @color)
      @pixels = as_alpha(text.pixels, mask.pixels)
      @w = text.w
      @h = text.h
    end 
    
    def as_alpha(pixels, alpha)
      i = 3
      while i < pixels.size
        pixels[i] = alpha[i-1]
        i += 4
      end
      pixels
    end
    
    def self.text_size(text,font,size)
      font = SDL::TTF.open(font,size)
      return font.text_size(text)
    end

    def texturize(i)
      GL.BindTexture(GL::TEXTURE_2D,i)
      GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_MAG_FILTER,GL::LINEAR)
      GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_WRAP_S,GL::REPEAT)
      GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_WRAP_T,GL::REPEAT)
      GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_MIN_FILTER,GL::LINEAR)
      GL.TexImage2D(GL::TEXTURE_2D,0,GL::RGBA,@w,@h,0,
                    GL::RGBA,GL::UNSIGNED_BYTE,@pixels)
    end
    
  end



end
