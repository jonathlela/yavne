require 'sdl'

module View

  class Timer

    attr_reader :sleep_time
    
    def initialize(rate)
      @rate = rate
      if @rate == 0
        @next = 0
        @sleep_time = 0
      else
        now = SDL.get_ticks()
        @next = (1000 / @rate) + now
        @sleep_time = 0
      end
    end
    
    def render?()
      res = false
      if @rate == 0
        res = true
      else
        now = SDL.get_ticks()
        if now >= @next
          @next = (1000 / @rate) + now
          @sleep_time = (@next - now) / 1000.0 
          res = true
        end
      end
      return res
    end
    
  end
  
end
