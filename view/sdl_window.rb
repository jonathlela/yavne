require 'sdl'

module View

class SDLWindow

 attr_reader :screen, :width, :height

  def initialize (width, height, bpp)
    @width = width
    @height = height
    @bpp = bpp
    @screen = init_SDL()
  end

  def init_SDL ()
    SDL.init(SDL::INIT_VIDEO)    
    SDL.setGLAttr(SDL::GL_RED_SIZE,5)
    SDL.setGLAttr(SDL::GL_GREEN_SIZE,5)
    SDL.setGLAttr(SDL::GL_BLUE_SIZE,5)
    SDL.setGLAttr(SDL::GL_DEPTH_SIZE,16)
    SDL.setGLAttr(SDL::GL_DOUBLEBUFFER,1)
    return SDL.setVideoMode(@width,@height,@bpp,SDL::OPENGL)  
  end

  def gl_swap ()
    SDL.GLSwapBuffers()
  end

  def set_caption (fps)
    SDL::WM.setCaption(fps,"")
  end

end

end
