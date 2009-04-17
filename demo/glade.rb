# -*- encoding: utf-8 -*-

# Author::    Jonathan Marchand  (mailto:first_name.last_name@azubato.net)
# Copyright:: Copyright (c) 2006-2009 Jérémy Marchand & Jonathan Marchand
# License::   GNU General Public License (GPL) version 3

#--###########################################################################
# YAVNE - Yet Another Visual Novel Editor                                    #
# Copyright © 2008-2009 Jérémy Marchand & Jonathan Marchand                  #
# Mails : first_name.last_name@azubato.net                                   #
#                                                                            #
# YAVNE is free software: you can redistribute it and/or modify              #
# it under the terms of the GNU General Public License as published by       #
# the Free Software Foundation, either version 3 of the License, or          #
# (at your option) any later version.                                        #
#                                                                            #
# YAVNE is distributed in the hope that it will be useful,                   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
############################################################################++

$KCODE = "UTF-8"

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+ "/..")

require 'gtkglext'
require 'libglade2'

require "data/model.rb"
require "data/modelfactory.rb"
require "controller/controller.rb"
require "view/gui.rb"

class Gtk_control_event_queue

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
  
  def initialize (width, height, gl_config)
    super()
    set_size_request(width, height)
    set_gl_capability(gl_config)

    @width = width
    @height = height

    @data = Model::ModelFactory.create_from_file("../demo/game.xml")
    @controller = Controller::Controller.new(@data)
    @control_event_queue = Gtk_control_event_queue.new()

    @run = false

    ##Signal handler for drawing area initialisation.
    signal_connect_after("realize") {
      @app.init()
    }

    # Signal handler for drawing area expose events.
    signal_connect_after("expose_event") {
      gl_begin() {
        if !@run then
          @app.update_state(@data.state)
          @app.init_view()
          Thread.new() {@app.main()}
          @run = true
        end
      }
    }

    ## Add mouse button press/release signal event handlers
    add_events(Gdk::Event::BUTTON_PRESS_MASK |
               Gdk::Event::BUTTON_RELEASE_MASK)

    signal_connect_after("button_press_event") {
      @control_event_queue.push(View::Mouse_button_pressed.new())
    }
    signal_connect_after("button_release_event") { 
       @control_event_queue.push(View::Mouse_button_released.new())
    }

    @app = View::Gui.new(@controller,self,@control_event_queue)
    @controller.view = @app
  end

  def gl_begin ()
    gl_drawable.gl_begin(gl_context) { yield }
  end

  def gl_swap ()
    if gl_drawable.double_buffered? then
      gl_drawable.swap_buffers()
    end
  end

  def set_caption (fps)
    parent.parent.title = fps
  end

end

class GladeGlGlade
  include GetText

  attr :glade
  
  def initialize (path_or_data, root = nil, domain = nil, localedir = nil, 
                  flag = GladeXML::FILE)
    ## Initialise Gtk[GLExt] library.
    Gtk.init()
    Gtk::GL.init()

    ## Obtain a valid OpenGL context configuration.
    gl_config = Gdk::GLConfig.new(Gdk::GLConfig::MODE_DEPTH |
                                  Gdk::GLConfig::MODE_DOUBLE |
                                  Gdk::GLConfig::MODE_RGBA)

    width = 800
    height = 600
    
    ## Glade
    bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {
      |handler| method(handler)
    }

    @area = @glade.get_widget("vbox")
    @gl_area = GLDrawingArea.new(width, height, gl_config)
    @area.add(@gl_area)
    @area.show_all()
  end

  def on_window_key_press_event (widget, arg0)
    puts "key_press_event"
    true
  end

  def on_window_key_release_event (widget, arg0)
    puts "key_release_event"
    true
  end

  def on_about_activate (widget)
    @glade.get_widget("aboutdialog").show
  end

  def on_quit_activate (widget)
    puts "Closing application."
    Gtk.main_quit()
  end

  def on_window_delete_event (widget, arg0)
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
