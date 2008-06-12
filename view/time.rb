require "view/event.rb"

module View

  class Time
   
    def initialize(poll,time,i,step)
      event = Event.new(Event::TIMEOUT,step)
      event.attach_data(i)
      Thread.new() {
        sleep(time/1000.0)
        poll.push(event)
      }
    end
 
  end

end
