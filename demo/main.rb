$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+ "/..")

require "data/model.rb"
require "data/modelfactory.rb"
require "controller/controller.rb"
require "view/sdlwindow.rb"
require "view/gui.rb"

data = Model::ModelFactory.createFromFile("game.xml")
controller = Controller::Controller.new(data)
window = View::SDL_window.new(800,600,16)
app = View::Gui.new(controller,window)
controller.view = app
app.init()
app.update_state(data.state)
app.main()
