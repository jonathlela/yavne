module Controller

class Controller
  
  def initialize(view,data)
    @data = data
    @environment = data.environment
    @state = data.state
    @view = view
  end

  def on_click()
    @state = @data.next_state(@state)
    @view.update(@state)
  end

  def on_timeout(data)
    @state = @data.next_state(@state)
    @view.update(@state)
  end

end

end
