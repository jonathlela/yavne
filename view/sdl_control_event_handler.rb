require "view/control_event.rb"

module View

  class SDLControlEventHandler

    def handle_event (queue)
      while event = SDL::Event2.poll do
        if event.kind_of?(SDL::Event2::Quit)
          queue.push(Quit.new())
        end
        if event.kind_of?(SDL::Event2::MouseButtonDown)
          queue.push(MouseButtonReleased.new())
        end
      end
    end

  end

end
