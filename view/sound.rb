require 'sdl'

module View

  class Sound

    attr_reader :loops, :channel

    def initialize(path,loops)
      @sound = SDL::Mixer::Wave.load(path)
      @loops = loops
    end

    def play?()
      SDL::Mixer.play?(@channel)
    end

    def play()
      @channel = SDL::Mixer.play_channel(-1,@sound,@loops)
    end

  end

end
