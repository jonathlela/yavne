module View

  class EventQueue    

    def initialize ()
      @poll = Array.new()
    end

    def push (event)
      @poll.push(event)
    end

    def fetch ()
      return @poll.shift()
    end

  end

end
