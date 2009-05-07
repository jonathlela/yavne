module Controller

  class Controller
  
    attr_accessor :view
    
    def initialize(data)
      @data = data
      @environment = data.environment
      @state = data.state
    end
    
    def load_new_state ()
      @state = @data.next_state(@state)
      @view.update_state(@state)
    end

    def on_click()
      load_new_state()
      @view.play()
    end
    
    def on_timeout(data)
      load_new_state()
      @view.play()
    end
    
  end
  
end
