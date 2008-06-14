module Controller

  class Controller
  
    attr_accessor :view
    
    def initialize(data)
      @data = data
      @environment = data.environment
      @state = data.state
    end
    
    def on_click()
      @state = @data.next_state(@state)
      @view.update_state(@state)
    end
    
    def on_timeout(data)
      @state = @data.next_state(@state)
      @view.update_state(@state)
    end
    
  end
  
end
