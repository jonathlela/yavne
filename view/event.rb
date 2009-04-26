module View

  class Event

    TIME_OUT = "time_out"
    STATE_CHANGED = "state_changed"
    PLAY_FINISHED = "play_finished"

    attr_reader :type, :data, :step

    def initialize (type, step)
      @type = type
      @step = step
    end

    def attach_data (data)
      @data = data
    end

    def type? (kind)
      return @type == kind
    end

  end

end
