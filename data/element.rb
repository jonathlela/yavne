module Model

  class Element
    
    NO_TIME="notime"
    
    @@ids = 0

    attr_reader :type, :id

    def initialize
      @@ids += 1
      @id = @@ids
    end
    
    def compound?() 
      return @compound
    end

  end

  class SingleElement < Element
    
    attr_accessor :time 

    def initialize(time=NO_TIME)
      super()
      @compound = false
      @time = time
    end

  end

  class CompoundElement < Element

    attr_reader :elements

    def initialize(elements)
      super()
      @compound = true
      @elements = Hash.new()
      elements.each { |elt|
        add(elt)
      }
    end

    def add(element)
      @elements[element.id] = element
    end

  end


end
