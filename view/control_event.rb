module View

  class Control_event
    
    MOUSE_BUTTON_PRESSED = "mouse_button_pressed"
    MOUSE_BUTTON_RELEASED = "mouse_button_released"
    QUIT = "quit"

    attr_reader :type

  end

  class Mouse_button_pressed < Control_event
    
    def initialize ()
      @type = Control_event::MOUSE_BUTTON_PRESSED
    end

  end

  class Mouse_button_released < Control_event
    
    def initialize ()
      @type = Control_event::MOUSE_BUTTON_RELEASED
    end

  end

  class Quit < Control_event
    
    def initialize ()
      @type = Control_event::QUIT
    end

  end

  class EventQueue 
    
    def initialize ()
      @queue = Array.new()
    end

    def fetch ()
      return @queue.shift()
    end

    def push (event)
      @queue.push(event)
    end

  end

end
