require "data/state/stateloader.rb"
require "data/state/state.rb"
require "data/environment.rb"

module Model

  class ModelFactory
      
    def ModelFactory.createFromFile(filename)
      state = StateLoader.new.load_file(File.new(filename))
      environment = Environment.new
      return Model.new(environment, state)
    end
  end
    
end