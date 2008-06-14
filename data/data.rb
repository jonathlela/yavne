require "data/environment.rb"
require "data/state.rb"
require "data/image.rb"
require "data/text.rb"
require "data/textbox.rb"

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
    box = Image.new("data/text.png")
    text10 = Text.new("Hello World! This surely will go beyond a simple line if I don't stop adding unnecessary words at the end of the line.",[1,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",30)
    text11 = Text.new("Oh magic! I've been mistaken, the programmer is so neat!",[1,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",30)
    text12 = Text.new("Let me see now if it cans go deeper.",[1,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",30)
    text13 = Text.new("エッチなのはいけないと思います！",[1,1,1,1],"/usr/share/fonts/truetype/kochi/kochi-gothic.ttf",30)
    text2 = Text.new("Hello Only!",[0,1,1,1],"/usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf",30,1000)
    textbox1 = Textbox.new(box)
    textbox1.add_text(text10)
    textbox1.add_text(text11)
    textbox1.add_text(text12)
    textbox1.add_text(text13)
    textbox1.center()
    textbox1.bottom()
    textbox2 = Textbox.new(box)
    textbox2.add_text(text2)
    textbox2.center()
    textbox2.bottom()
    image1= Image.new("data/image.png")
    image1.left()
    image1.top_of(textbox1)
    image2= Image.new("data/image2.png")
    image2.right()
    image2.top_of(textbox2)
    state1= State.new()
    state2= State.new()
    state1.background = background
    state2.background = background
    state1.sprites = [image1]
    state2.sprites = [image2]
    state1.textbox = textbox1
    state2.textbox = textbox2
    next1=lambda {|x| state2}
    next2=lambda {|x| state1}
    state1.next=next1
    state2.next=next2
    return state1
  end

end

end
