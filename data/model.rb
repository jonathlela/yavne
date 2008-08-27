require "data/state/stateloader.rb"
require "data/state/state.rb"
require "data/environment.rb"

module Model

  class Model

    attr_reader :environment, :state
  
    def initialize(env, state)
      @state = state
      @environment = env
    end
    
    def next_state(state)
      state.next(@environment)
    end
    
  end
  
end
