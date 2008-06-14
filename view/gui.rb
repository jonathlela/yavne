require 'sdl'
require 'opengl'
require "view/controller.rb"
require "view/glscreen.rb"
require "view/image.rb"
require "view/text.rb"
require "view/mediatracker.rb"
require "view/positionner.rb"
require "view/timer.rb"
require "view/time.rb"
require "view/pollevent.rb"
require "view/event.rb"


$KCODE="UTF8"

module View

class Gui
  
  attr_reader :is_finished, :elements

  def initialize(controller)
    @controller = Controller.new(controller,self)
    @is_finished = false
    @render = Screen.new(800,600,16)
    @mediatracker = MediaTracker.new()
    @positionner = Positionner.new(@render,@mediatracker)
    SDL::Mouse.show()
    SDL::TTF.init()
    @fps = 0    
    @last_fps = SDL::get_ticks()/1000
    @fps_timer = Timer.new(100)
    @event_timer = Timer.new(1000)
    @pollevent = PollEvent.new()
    @step = 0
  end
 
  def update_time(elt)
    if elt.compound? then
      elt.elements.each_value { |elt|
        update_time(elt)
      }
    else
      if elt.time != Model::Element::NO_TIME then
        Time.new(@pollevent,elt.time,elt.id,@step)
      end
    end
  end

  def update_elt(elt)
    update_time(elt)
    element = @mediatracker.get_renderable(elt)
    if element.compound? then
      element.reset()
    end
    element.set_pos(@positionner.calculate_hpos(elt),@positionner.calculate_vpos(elt))
    return element
  end

  def update_state(state)
    @step += 1
    @elements = Array.new()
    if state.background != nil then
      @elements.push(update_elt(state.background))
    end
    if state.sprites != nil then
      sprites = state.sprites.collect { |img|
        update_elt(img)
      }
      @elements.concat(sprites)
    end
    if state.textbox != nil then
      @elements.push(update_elt(state.textbox))
    end
    update()
  end

  def update()
    i = 0
    @elements.each { |elt|
      i = elt.texturize(i)
    }
  end

  def run()
    handle_event()
    if @event_timer.render?() then
      handle_event()
      handle_sdl_event()
    end
    if @fps_timer.render?() then
      @fps = @fps + 1
      now = SDL::get_ticks()/1000
      if now != @last_fps then
        SDL::WM.setCaption(@fps.to_s,"")
        @last_fps = now
        @fps = 0
      end
      render()
    end
    if @event_timer.sleep_time < @fps_timer.sleep_time then
      sleep(@event_timer.sleep_time)
    else
      sleep(@fps_timer.sleep_time)
    end
  end

  def handle_event()
    while event = @pollevent.poll
      if event.step == @step then
        if event.type?(Event::TIMEOUT)
          @controller.on_timeout(event.data)
        end
      end
    end
  end

  def handle_sdl_event()
    while event = SDL::Event2.poll
      if event.kind_of?(SDL::Event2::Quit)
        @is_finished = true
        exit
      end
      if event.kind_of?(SDL::Event2::MouseButtonDown)
        @controller.on_click()
      end
    end
  end

  def render()
    GL.MatrixMode(GL::MODELVIEW)     
    GL.LoadIdentity()
    GL.Clear(GL::COLOR_BUFFER_BIT)
    i = 0
    @elements.each { |elt|
      i = elt.render(i)
    }
    SDL.GLSwapBuffers()
  end

end

end


