module View

  class Controller

    def initialize(controller,view)
      @main_controller = controller
      @view = view
    end

    def on_click()
      not_fully_rendered = Array.new()
      @view.renderables.each { |elt|
        if !elt.fully_rendered?() then
          not_fully_rendered.push(elt)
        end
      }
      if not_fully_rendered.empty? then
         @main_controller.on_click()
      else
        not_fully_rendered.pop().next()
        
      end
    end
    
    def on_timeout(data)
      @main_controller.on_timeout(data)
    end

  end

end
