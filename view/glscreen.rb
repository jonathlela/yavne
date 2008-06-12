require 'sdl'
require 'opengl'

module View

class Screen
  
  attr_reader :screen, :width, :height

  def initialize(width,height,bpp)
    @width = width
    @height = height
    @bpp = bpp
    @screen = init_SDL()
    init_view()
  end

  def init_SDL()
    SDL.init(SDL::INIT_VIDEO)    
    SDL.setGLAttr(SDL::GL_RED_SIZE,5)
    SDL.setGLAttr(SDL::GL_GREEN_SIZE,5)
    SDL.setGLAttr(SDL::GL_BLUE_SIZE,5)
    SDL.setGLAttr(SDL::GL_DEPTH_SIZE,16)
    SDL.setGLAttr(SDL::GL_DOUBLEBUFFER,1)
    return SDL.setVideoMode(@width,@height,@bpp,SDL::OPENGL)  
  end

  def init_view()
    GL.MatrixMode(GL::PROJECTION)
    GL.LoadIdentity()
    GL.Ortho(0,@width,@height,0,-100,100)
    GL.MatrixMode(GL::MODELVIEW)     
    GL.LoadIdentity()
    GL.ClearColor(0.0,0.0,0.0,1.0)
    GL.BlendFunc(GL::SRC_ALPHA,GL::ONE_MINUS_SRC_ALPHA)
    GL.Enable(GL::BLEND)
    GL.GenTextures(2)
  end

end

end
