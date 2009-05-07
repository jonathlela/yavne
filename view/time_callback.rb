require "view/event.rb"

module View

  class TimeCallback
   
    def initialize(poll,time,clock,i,step)
      event = Event.new(Event::TIME_OUT,step)
      event.attach_data(i)
      alarm = clock.get_time() + time
      Thread.new() {
        while true do
          if clock.get_time() >= alarm  then
            break
          end
          sleep(0.01)
        end
        poll.push(event)
      }
    end
 
  end

end
