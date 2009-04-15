require "view/control_event.rb"

module View

  class SDL_controller

    def handle_event (queue)
      while event = SDL::Event2.poll do
        if event.kind_of?(SDL::Event2::Quit)
          queue.push(Quit.new())
        end
        if event.kind_of?(SDL::Event2::MouseButtonDown)
          queue.push(Mouse_button_pressed.new())
        end
      end
    end

  end

end
