#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+ "/..")

require 'sdl'
require 'gtkglext'
require 'libglade2'

require "data/model.rb"
require "data/modelfactory.rb"
require "controller/controller.rb"
require "view/sdlwindow.rb"
require "view/gui.rb"
require "view/image.rb"

class Gtk_controller

  def initialize ()
    @queue = Array.new()
  end

  def push (event)
    @queue.push(event)
  end

  def shift ()
    return @queue.shift()
  end

  def handle_event (queue)
    while event = shift() do
      queue.push(event)
    end
  end
  
end

class GLDrawingArea < Gtk::DrawingArea

  attr_reader :width, :height
  
  def initialize(width, height, fov, gl_config)
    super()
    set_size_request(width, height)
    set_gl_capability(gl_config)

    @width = width
    @height = height

    @data = Model::ModelFactory.createFromFile("../demo/game.xml")
    @controller = Controller::Controller.new(@data)
    @control_event = Gtk_controller.new()

    @run = false

    ##Signal handler for drawing area initialisation.
    signal_connect_after("realize") do
      p "realize"
      @app.init()
      p "realize2"
    end

    ## Signal handler for drawing area reshapes.
    #signal_connect_after("configure_event") do
    #  gl_begin() { @render.resize(allocation.width, allocation.height) }
    #end

    # Signal handler for drawing area expose events.
    signal_connect_after("expose_event") do
      gl_begin() do
        p "expose"
        if !@run then
          @app.update_state(@data.state)
          @app.init_view()
          Thread.new() {@app.main()}
          @run = true
        end
        p "expose2"
      end
    end

    #  gl_drawable.swap_buffers() if gl_drawable.double_buffered?
    #end

    ## Add mouse button press/release signal event handlers
    add_events(Gdk::Event::BUTTON_PRESS_MASK |
               Gdk::Event::BUTTON_RELEASE_MASK)

    signal_connect_after("button_press_event") {
      @control_event.push(View::Mouse_button_pressed.new())
      button_press_event()
    }
    #signal_connect_after("button_release_event") {  SDL::Event.push(SDL::Event.new())}

    @app = View::Gui.new(@controller,self,@control_event)
    @controller.view = @app
  end

  def gl_begin()
    gl_drawable.gl_begin(gl_context) { yield }
  end

  def gl_swap()
    if gl_drawable.double_buffered? then
      gl_drawable.swap_buffers()
    end
  end

  def button_press_event()
    puts "button_press_event"
    true
  end

  def button_release_event()
    puts "button_release_event"
    true
  end

    def set_caption (fps)
    parent.parent.title = fps
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
  PROG_PATH = "gui.glade"
  PROG_NAME = "YOUR_APPLICATION_NAME"
  GladeGlGlade.new(PROG_PATH, nil, PROG_NAME)
  Gtk.main()
end
