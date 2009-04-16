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

    def play ()
      SDL::Mixer.play_music(@music,@loops)
    end

  end

end
