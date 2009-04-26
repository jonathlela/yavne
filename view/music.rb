require 'sdl'

module View

  class Music

    attr_reader :loop

    def initialize (path, loops)
      @music = SDL::Mixer::Music.load(path)
      @loops = loops
    end

    def play? ()
      SDL::Mixer.play_music?()
    end

    def pause? ()
      SDL::Mixer.pause_music?()
    end

    def play ()
      SDL::Mixer.play_music(@music, @loops)
    end

    def pause ()
      if play?() then
        SDL::Mixer.pause_music()
      end
    end

    def resume ()
      SDL::Mixer.resume_music()
    end

    def halt ()
      SDL::Mixer.halt_music()
    end

  end

end
