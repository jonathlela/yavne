require 'sdl'

module View

  class Timer

    attr_reader :sleep_time
    
    def initialize(fps)
      @fps = fps
      if @fps == 0
        @frame_interval = 0;
      else
        @frame_interval = 1000 / @fps
      end
      now = SDL.get_ticks()
      @next = now + @frame_interval
      @sleep_time = 0 #@frame_interval / 1000

    end
    
    def render?()
      res = false
      if @fps == 0
        res = true
      else
        now = SDL.get_ticks()
        if now >= @next
          while( (@next += @frame_interval) < now)
            #p "skip";
          end
          @sleep_time = (@next - now) / 1000.0 
          res = true
        end
      end
      return res
    end
    
  end
  
end
