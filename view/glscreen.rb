require 'opengl'

module View

class Gl_screen

  attr_reader :width, :height

  def initialize(width,height)
    @width = width
    @height = height
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
