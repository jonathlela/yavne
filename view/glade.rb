#!/usr/bin/env ruby
require 'gtkglext'
require 'libglade2'

## -----------------------------------------------------------------------------
## A generic class for OpenGL application functions.
## -----------------------------------------------------------------------------
class GLRender
  attr_reader :fov

  def initialize(fov = 90.0)
    @fov = fov
  end

  ## Initialise OpenGL state for 3D rendering.
  def init()
    GL.ShadeModel(GL::SMOOTH)
    GL.Enable(GL::DEPTH_TEST)
    GL.DepthFunc(GL::LEQUAL)
    GL.ClearColor(0.0, 0.0, 0.0, 0.0)
    GL.Hint(GL::PERSPECTIVE_CORRECTION_HINT, GL::NICEST)
    true
  end

  ## Resize OpenGL viewport.
  def resize(width, height)
    GL.Viewport(0, 0, width, height)

    GL.MatrixMode(GL::PROJECTION)
    GL.LoadIdentity()
    GLU.Perspective(@fov, width.to_f() / height.to_f(), 0.1, 1024.0)
    
    GL.MatrixMode(GL::MODELVIEW)
    GL.LoadIdentity()
  end

  ## Render OpenGL scene.
  def draw()
    GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    GL.LoadIdentity()

    ## Scene view translation. ---------------------------------------------->>>
    GL.Translate(0.0, 0.0, -1.0)
    GL.Rotate(0.0, 0.0, 0.0, 0.0)
    ## -------------------------------------------------------------------------

    ## Scene Rendering Code ------------------------------------------------->>>
    GL.Begin(GL::TRIANGLES)
      GL.Color3f(0, 0, 1)
      GL.Vertex2f(-1, -1)
      GL.Color3f(0, 1, 0)
      GL.Vertex2f(1, 1)
      GL.Color3f(1, 0, 0)
      GL.Vertex2f(1, -1)
    GL.End()
    ## -------------------------------------------------------------------------

    GL.Flush()
  end
end

## -----------------------------------------------------------------------------
## A GtkDrawingArea widget with OpenGL rendering capabilities.
## -----------------------------------------------------------------------------
class GLDrawingArea < Gtk::DrawingArea
  def initialize(width, height, fov, gl_config)
    super()
    set_size_request(width, height)
    set_gl_capability(gl_config)

    ## Create an OpenGL renderer instance.
    @render = GLRender.new(fov)

    ## Signal handler for drawing area initialisation.
    signal_connect_after("realize") do
      gl_begin() { @render.init() }
    end

    ## Signal handler for drawing area reshapes.
    signal_connect_after("configure_event") do
      gl_begin() { @render.resize(allocation.width, allocation.height) }
    end

    ## Signal handler for drawing area expose events.
    signal_connect_after("expose_event") do
      gl_begin() do
        @render.draw()
      end

      gl_drawable.swap_buffers() if gl_drawable.double_buffered?
    end

    ## Add mouse button press/release signal event handlers
    add_events(Gdk::Event::BUTTON_PRESS_MASK |
               Gdk::Event::BUTTON_RELEASE_MASK)

    signal_connect_after("button_press_event") { button_press_event() }
    signal_connect_after("button_release_event") { button_release_event() }
  end

  def gl_begin()
    gl_drawable.gl_begin(gl_context) { yield }
  end

  def button_press_event()
    puts "button_press_event"
    true
  end

  def button_release_event()
    puts "button_release_event"
    true
  end
end

class GladeGlGlade
  include GetText

  attr :glade
  
  def initialize(path_or_data, root = nil, domain = nil, localedir = nil, flag = GladeXML::FILE)
    ## Initialise Gtk[GLExt] library.
    Gtk.init()
    Gtk::GL.init()

    ## Obtain a valid OpenGL context configuration.
    gl_config = Gdk::GLConfig.new(Gdk::GLConfig::MODE_DEPTH |
                                  Gdk::GLConfig::MODE_DOUBLE |
                                  Gdk::GLConfig::MODE_RGBA)
    width = 800
    height = 600
    fov = 90.0
    
    ## Glade
    bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {|handler| method(handler)}

    @area = @glade.get_widget("vbox1")
    @gl_area = GLDrawingArea.new(width, height, fov, gl_config)
    @area.add(@gl_area)
    @area.show_all()
  end

  def on_window1_key_press_event(widget, arg0)
    puts "key_press_event"
    true
  end

  def on_window1_key_release_event(widget, arg0)
    puts "key_release_event"
    true
  end

  def on_window1_delete_event(widget, arg0)
    puts "Closing application."
    widget.destroy()
    Gtk.main_quit()
  end

  
end


# Main program
if __FILE__ == $0
  # Set values as your own application. 
  PROG_PATH = "glade-gl.glade"
  PROG_NAME = "YOUR_APPLICATION_NAME"
  GladeGlGlade.new(PROG_PATH, nil, PROG_NAME)
  Gtk.main
end
