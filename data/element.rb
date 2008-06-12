module Model

  class Element
    
    NO_TIME="notime"
    
    @@ids = 0

    attr_reader :time, :type, :id

    def initialize(time=NO_TIME)
      @@ids += 1
      @id = @@ids
      @time = time
    end
    
  end

end
