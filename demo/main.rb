$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+ "/..")

require "data/model.rb"
require "data/modelfactory.rb"
require "controller/controller.rb"
require "view/gui.rb"

data = Model::ModelFactory.createFromFile("game.xml")
controller = Controller::Controller.new(data)
app = View::Gui.new(controller)
controller.view = app
app.update_state(data.state)

while !app.is_finished
  app.run()
end
