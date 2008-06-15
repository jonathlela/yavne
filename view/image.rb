require 'sdl'
require 'opengl'
require "view/renderable.rb"

module View

class Image < SingleRenderable

  def initialize(path)
    super()
    image= SDL::Surface.load(path)
    @w = image.w
    @h = image.h
    @pixels = image.pixels
  end

  def texturize(i)
    GL.BindTexture(GL::TEXTURE_2D,i)
    GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_MAG_FILTER,GL::NEAREST)
    GL.TexParameter(GL::TEXTURE_2D,GL::TEXTURE_MIN_FILTER,GL::NEAREST)
    GL.TexImage2D(GL::TEXTURE_2D,0,GL::RGBA,@w,@h,0,
                  GL::RGBA,GL::UNSIGNED_BYTE,@pixels)
  end

end

end
