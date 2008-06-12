require 'sdl'
require 'opengl'
require "view/glscreen.rb"
require "view/image.rb"
require "view/text.rb"
require "view/mediatracker.rb"
require "view/timer.rb"
require "view/time.rb"
require "view/pollevent.rb"
require "view/event.rb"

$KCODE="UTF8"

module View

class Gui
  
  attr_reader :is_finished
  attr_accessor :controller

  def initialize()
    @is_finished = false
    @render = Screen.new(800,600,16)
    @mediatracker = MediaTracker.new()
    SDL::Mouse.show()
    SDL::TTF.init()
    @fps = 0    
    @last_fps = SDL::get_ticks()/1000
    @fps_timer = Timer.new(100)
    @event_timer = Timer.new(1000)
    @pollevent = PollEvent.new()
    @step = 0
  end
 
  def calculate_hpos(elt)
    image = @mediatracker.get_renderable(elt)
    case elt.horizontal.kind
    when Model::Position::ABSOLUTE
      case elt.horizontal.pos
      when Model::HorizontalPosition::LEFT
        return elt.horizontal.margin
      when Model::HorizontalPosition::CENTER
        return (@render.width/2) - (image.w/2) + elt.horizontal.margin
      when Model::HorizontalPosition::RIGHT
        return @render.width - (image.w) - elt.horizontal.margin
      end
    when Model::Position::RELATIVE
      relative = @mediatracker.get_renderable(elt.horizontal.relative)
      rel = calculate_hpos(elt.horizontal.relative)
      case elt.horizontal.pos
      when Model::HorizontalPosition::LEFT
        return rel - image.w - elt.horizontal.margin
      when Model::HorizontalPosition::CENTER
        return rel + (relative.w/2) + elt.horizontal.margin
      when Model::HorizontalPosition::RIGHT
        return rel + relative.w + elt.horizontal.margin
      end
    when Model::Position::ALIGNED
      relative = @mediatracker.get_renderable(elt.horizontal.relative)
      rel = calculate_hpos(elt.horizontal.relative)
      case elt.horizontal.pos
      when Model::HorizontalPosition::LEFT
        return rel + elt.horizontal.margin
      when Model::HorizontalPosition::CENTER
        return rel + (relative.w/2) - (image.w/2) + elt.horizontal.margin
      when Model::HorizontalPosition::RIGHT
        return rel + relative.w - image.w - elt.horizontal.margin
      end
    end
  end

  def calculate_vpos(elt)
    image = @mediatracker.get_renderable(elt)
    case elt.vertical.kind
    when Model::Position::ABSOLUTE
      case elt.vertical.pos
      when Model::VerticalPosition::TOP
        return elt.vertical.margin
      when Model::VerticalPosition::MIDDLE
        return (@render.height/2) - (image.h/2) + elt.vertical.margin
      when Model::VerticalPosition::BOTTOM
        return @render.height - (image.h) - elt.vertical.margin
      end
    when Model::Position::RELATIVE
      relative = @mediatracker.get_renderable(elt.vertical.relative)
      rel = calculate_vpos(elt.vertical.relative)
      case elt.vertical.pos
      when Model::VerticalPosition::TOP
        return rel - image.w - elt.vertical.margin
      when Model::VerticalPosition::MIDDLE
        return rel + (relative.h/2) + elt.vertical.margin
      when Model::VerticalPosition::BOTTOM
        return rel + relative.h + elt.vertical.margin
      end
    when Model::Position::ALIGNED
      relative = @mediatracker.get_renderable(elt.vertical.relative)
      rel = calculate_vpos(elt.vertical.relative)
      case elt.vertical.pos
      when Model::VerticalPosition::TOP
        return rel + elt.vertical.margin
      when Model::VerticalPosition::MIDDLE
        return rel + (relative.h/2) - (image.h/2) + elt.vertical.margin
      when Model::VerticalPosition::BOTTOM
        return rel + relative.h - image.h  - elt.vertical.margin
      end
    end
  end

  def update_elt(elt)
    if elt.time != Model::Element::NO_TIME then
      Time.new(@pollevent,elt.time,elt.id,@step)
    end
    element = @mediatracker.get_renderable(elt)
    element.set_pos(calculate_hpos(elt),calculate_vpos(elt))
    return element
  end

  def update(state)
    @step += 1
    @elements = Array.new()
    if state.background != nil then
      @elements.push(update_elt(state.background))
    end
    if state.sprites != nil then
      sprites = state.sprites.collect { |img|
        update_elt(img)
      }
      @elements.concat sprites
    end
    if state.textbox != nil then
      @elements.push(update_elt(state.textbox))
    end
    if state.text != nil then
      @elements.push(update_elt(state.text))
    end
    @elements.each_index { |i|
      @elements[i].texturize(i)
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
          controller.on_timeout(event.data)
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
        controller.on_click()
      end
    end
  end

  def render()
    GL.MatrixMode(GL::MODELVIEW)     
    GL.LoadIdentity()
    GL.Clear(GL::COLOR_BUFFER_BIT)
    @elements.each_index { |i|
      @elements[i].render(i)
    }
    SDL.GLSwapBuffers()
  end

end

end


