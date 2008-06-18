require "data/element.rb"

module Model

  class Music < SingleElement

    attr_reader :path, :loops

    INFINITE_LOOP = "infinite loop"

    def initialize(path,loops=INFINITE_LOOP,time=Element::NO_TIME)
      super(time)
      @path = path
      @loops = loops
      @type = "music"
    end

  end

end
