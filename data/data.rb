require "data/loader.rb"
require "data/environment.rb"
require "data/state.rb"

module Model
  
  class Model

    attr_reader :environment, :state
  
    def initialize(file)
      env = load_environment()
      load = Loader.new(file)
      @state = load.init
      @environment = env
    end
    
    def next_state(state)
      state.next(@environment)
    end
    
    def load_environment()
      Environment.new()
    end
    
  end
  
end
