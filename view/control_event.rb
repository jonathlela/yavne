module View

  class ControlEvent
    
    MOUSE_BUTTON_PRESSED = "mouse_button_pressed"
    MOUSE_BUTTON_RELEASED = "mouse_button_released"
    QUIT = "quit"

    attr_reader :type

  end

  class MouseButtonPressed < ControlEvent
    
    def initialize ()
      @type = ControlEvent::MOUSE_BUTTON_PRESSED
    end

  end

  class MouseButtonReleased < ControlEvent
    
    def initialize ()
      @type = ControlEvent::MOUSE_BUTTON_RELEASED
    end

  end

  class Quit < ControlEvent
    
    def initialize ()
      @type = ControlEvent::QUIT
    end

  end

end
