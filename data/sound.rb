require "data/element.rb"

module Model

  class Sound < SingleElement

    attr_reader :path, :loops

    INFINITE_LOOP = "infinite loop"

    def initialize(path,loops=0,time=Element::NO_TIME)
      super(time)
      @path = path
      @loops = loops
      @type = "sound"
    end

  end

end
