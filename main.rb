require "data/data.rb"
require "controller/controller.rb"
require "view/gui.rb"

data = Model::Model.new()
app = View::Gui.new()
app.update(data.state)
controller = Controller::Controller.new(app,data)
app.controller = controller

while !app.is_finished
  app.run()
end
