require 'sdl'
require 'opengl'

require "view/controller.rb"
require "view/sdl_window.rb"
require "view/gl_screen.rb"
require "view/image.rb"
require "view/text.rb"
require "view/mediatracker.rb"
require "view/positionner.rb"
require "view/timer.rb"
require "view/time_callback.rb"
require "view/state_changed_callback.rb"
require "view/play_finished_callback.rb"
require "view/texturemanager.rb"
require "view/event_queue.rb"
require "view/control_event.rb"
require "view/event.rb"


$KCODE="UTF8"

module View

class Gui
  
  attr_reader :is_finished, :renderables, :step

  def initialize (controller, window, control_event_handler)
    @controller = Controller.new(controller,self)
    @window = window
    @control_event_handler = control_event_handler
  end

  def init()
    @is_finished = false
    @is_paused = false
    @render = GLScreen.new(@window.width,@window.height)
    @mediatracker = MediaTracker.new()
    @positionner = Positionner.new(@render,@mediatracker)
    @texturemanager = TextureManager.new()
    SDL::Mouse.show()
    SDL::TTF.init()
    SDL.init(SDL::INIT_AUDIO)
    SDL::Mixer.open(44100, SDL::Mixer::DEFAULT_FORMAT, SDL::Mixer::DEFAULT_CHANNELS, 1024)
    @fps = 0    
    @last_fps = SDL::get_ticks()/1000
    @fps_timer = Timer.new(100)
    @event_timer = Timer.new(100)
    @game_event_queue = EventQueue.new()
    @control_event_queue = EventQueue.new()
    @renderables = Array.new()
    @playables = Array.new()
    @step = 0
  end

  def init_view ()
    @render.init_view()
  end
 
  def update_time(elt)
    if elt.compound? then
      elt.elements.each_value { |elt|
        update_time(elt)
      }
    else
      if elt.time == Model::Playable::STATE_CHANGE then
        StateChangedCallback.new(@game_event_queue,self,elt,@step)
      elsif elt.time ==  Model::Playable::UNTIL_LAST then
        PlayFinishedCallback.new(@game_event_queue,@mediatracker,elt,@step)
      elsif elt.time != Model::Timeable::NO_TIME then
        TimeCallback.new(@game_event_queue,elt.time,elt,@step)
      end

    end
  end
  
  def update_render(elt)
    update_time(elt)
    element = @mediatracker.get_renderable(elt)
    if element.compound? then
      element.reset()
    end
    element.set_pos(@positionner.calculate_hpos(elt),@positionner.calculate_vpos(elt))
    return element
  end
  
  def update_play(elt)
    update_time(elt)
    return @mediatracker.get_playable(elt)
  end
  
  def update_state(state)
    @step += 1
    @renderables = Array.new()
    if state.background != nil then
      elt = state.background
      @renderables.push(update_render(elt))
    end
    if !state.sprites.empty? then
      sprites = state.sprites.collect { |img|
        update_render(img)
      }
      @renderables.concat(sprites)
    end
    if state.textbox != nil then
      elt = state.textbox
      @renderables.push(update_render(elt))
    end
    if state.music != nil then
      elt = state.music
      @playables.push(update_play(elt))
    end
    if state.sfx != nil then
      elt = state.sfx
      @playables.push(update_play(elt))
    end
    update()
  end
  
  def update()
    @renderables.each { |elt|
      @texturemanager.load(elt)
    }
    @playables.each { |elt|
      if !elt.play?() then
        elt.play()
      end
    }
  end
  
  def run()
    if @event_timer.render?() && !@is_paused then
      handle_game_event()
      handle_control_event()
    end
    if @fps_timer.render?() then
      @fps = @fps + 1
      now = SDL::get_ticks()/1000
      if now != @last_fps then
        @window.set_caption(@fps.to_s)
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
  
  def handle_game_event ()
    while event = @game_event_queue.fetch() do
      if event.step == @step then
        if event.type?(Event::TIME_OUT)
          @controller.on_timeout(event.data.id)
        end
      end
      if event.type?(Event::STATE_CHANGED)
        playable = @mediatracker.get_playable(event.data)
        if playable.play?() then
          playable.halt()
        end
        @playables.delete(playable)
      end
      if event.type?(Event::PLAY_FINISHED)
        playable = @mediatracker.get_playable(event.data)
        @playables.delete(playable)
      end
    end
  end
  
  def handle_control_event ()
    @control_event_handler.handle_event(@control_event_queue)
    while event = @control_event_queue.fetch() do
      if event.type == ControlEvent::MOUSE_BUTTON_RELEASED then
        @controller.on_click()
      end
      if event.type == ControlEvent::QUIT then
        @is_finished = true
        exit
      end
    end
  end
  
  def render_element(element)
    if element.compound? then
      element.render_elements.each { |elt|
        render_element(elt)
      }
    else
      i = @texturemanager.get(element)
      element.render(i)
    end
  end
 

  def pause ()
    @playables.each { |play|
      play.pause()
    }
  end
  
  def resume ()
    @playables.each { |play|
      play.resume()
    }
  end

  def pause_game ()
    if !@is_paused then
      pause()
      @is_paused = true
    end
  end

  def resume_game ()
    if @is_paused then
      resume()
      @is_paused = false
    end
  end

  def render()
    GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    GL.LoadIdentity()
    @renderables.each { |elt|
      render_element(elt)
    }
    @window.gl_swap()
  end

  def main()
    while !@is_finished do
      run()
    end
  end

end

end
