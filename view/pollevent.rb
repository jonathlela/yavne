module View

  class PollEvent    

    def initialize ()
      @poll = Array.new()
    end

    def push (event)
      @poll.push(event)
    end

    def poll ()
      return @poll.shift()
    end

  end

end
