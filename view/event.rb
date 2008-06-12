module View

  class Event

    TIMEOUT="timeout"

    attr_reader :type, :data, :step

    def initialize(type,step)
      @type = type
      @step = step
    end

    def attach_data(data)
      @data = data
    end

    def type?(kind)
      return @type == kind
    end

  end

end
