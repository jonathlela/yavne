require 'opengl'

module View

class Renderable

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
  end

end

end
