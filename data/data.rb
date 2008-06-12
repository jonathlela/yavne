require "data/environment.rb"
require "data/state.rb"
require "data/image.rb"
require "data/text.rb"

module Model

class Model

  attr_reader :environment, :state
  
  def initialize()
    env = load_environment()
    state = load_state()
    @environment = env
    @state = state
  end

  def next_state(state)
    state.next(@environment)
  end

  def load_environment()
    Environment.new()
  end

  def load_state()
    background = Image.new("data/Beach time.png")
    background.middle()
    background.center()
    textbox = Image.new("data/text.png")
    textbox.center()
    textbox.bottom()
    text1 = Text.new("Hello World!",[1,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",24,1000)
    text1.align_left(textbox,5)
    text1.align_top(textbox,5)
    text2 = Text.new("Hello Only!",[0,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",24,1000)
    text2.align_right(textbox,5)
    text2.align_bottom(textbox,5)
    image1= Image.new("data/image.png")
    image1.left()
    image1.top_of(textbox)
    image2= Image.new("data/image2.png")
    image2.right()
    image2.top_of(textbox)
    state1= State.new()
    state2= State.new()
    state1.background = background
    state2.background = background
    state1.sprites = [image1]
    state2.sprites = [image2]
    state1.textbox = textbox
    state2.textbox = textbox
    state1.text = text1
    state2.text = text2
    next1=lambda {|x| state2}
    next2=lambda {|x| state1}
    state1.next=next1
    state2.next=next2
    return state1
  end

end

end
