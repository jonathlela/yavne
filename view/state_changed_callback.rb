require "view/event.rb"

module View

  class StateChangedCallback
   
    def initialize(poll,app,i,step)
      event = Event.new(Event::STATE_CHANGED,step)
      event.attach_data(i)
      Thread.new() {
        while true do
          if app.step != step then
            break
          end
          sleep(0.01)
        end
        poll.push(event)
      }
    end
 
  end

end
