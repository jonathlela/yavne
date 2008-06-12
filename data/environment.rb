module Model

  class Environment

    def initialize(variables=Hash.new(),default_value=nil)
      @variables = variables
      @default_value = default_value
    end  

    def get(key) 
      @variables[key]
    end

    def set(key,value)
      @variables[key] =  value
    end

  end

end
