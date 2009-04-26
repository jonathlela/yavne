require "view/event.rb"

module View

  class PlayFinishedCallback
   
    def initialize(poll,mediatracker,i,step)
      event = Event.new(Event::PLAY_FINISHED,step)
      event.attach_data(i)
      Thread.new() {
        while true do
          playable = mediatracker.get_playable(i)
          if !playable.play?() && !playable.pause?() then
            break
          end
          sleep(0.1)
        end
        poll.push(event)
      }
    end
 
  end

end
