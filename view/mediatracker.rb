require "view/image.rb"
require "view/text.rb"
require "view/textbox.rb"
require "view/music.rb"
require "view/sound.rb"

module View

  class MediaTracker

    def initialize()
      @renderables = Hash.new()
      @playables = Hash.new()
    end

    def get_renderable(render)
      id = render.id
      if @renderables.has_key?(id) then
        return @renderables[id]
      else
        if render.compound? then
          case render.type
          when "textbox"
            boxid = render.box.id
            if @renderables.has_key?(boxid) then
              box = @renderables[boxid]
            else
              box = Image.new(render.box.path)
              @renderables[boxid] = box
            end
            render = Textbox.new(box,render.texts)
          end
        else
          case render.type
          when "image"
            render = Image.new(render.path)
          when "text"
            render = Text.new(render.text,render.color,render.font,render.size)
          end
        end
        @renderables[id] = render
        return render
      end
    end

    def get_playable(play)
      id = play.id
      if @playables.has_key?(id) then
        return @playables[id]
      else
        case play.type
          when "music"
          if play.loops == Model::Music::INFINITE_LOOPS then
            play = Music.new(play.path,-1)
          else
            play = Music.new(play.path,play.loops)
          end
          when "sound"
          if play.loops == Model::Sound::INFINITE_LOOPS then
            play = Sound.new(play.path,-1)
          else
            play = Sound.new(play.path,play.loops)
          end
        end
      end
      @playables[id] = play
      return play
    end

  end
  
end
