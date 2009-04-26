require 'sdl'

module View

  class Sound

    attr_reader :loops, :channel

    @@channels = Hash.new(0)

    def initialize (path, loops)
      @sound = SDL::Mixer::Wave.load(path)
      @loops = loops
    end

    def play? ()
      if @channel != nil then
        now_num = @@channels[@channel]
        if now_num == @chan_num then
          SDL::Mixer.play?(@channel)
        else
          false
        end
      else
        false
      end
    end

    def pause? ()
      if @channel != nil then
        now_num = @@channels[@channel]
        if now_num == @chan_num then
          if SDL::Mixer.pause?(@channel) != 0 then
            true
          else
            false
          end
        else
          false
        end
      else
        false
      end
    end

    def play ()
      @channel = SDL::Mixer.play_channel(-1, @sound, @loops)
      @chan_num = @@channels[@channel] + 1
      @@channels[@channel] = @chan_num
    end

    def pause ()
      if play?() then
        SDL::Mixer.pause(@channel)
      end
    end

    def resume ()
      if pause?() then
        SDL::Mixer.resume(@channel)
      end
    end

    def halt ()
      if @channel != nil then
        now_num = @@channels[@channel]
        if now_num == @chan_num then
          SDL::Mixer.halt(@channel)
        end
      end
    end

  end

end
