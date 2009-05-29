# -*- encoding: utf-8 -*-

# Author::    Jonathan Marchand  (mailto:first_name.last_name@azubato.net)
# Copyright:: Copyright (c) 2006-2009 Jérémy Marchand & Jonathan Marchand
# License::   GNU General Public License (GPL) version 3

#--###########################################################################
# YAVNE - Yet Another Visual Novel Editor                                    #
# Copyright © 2008-2009 Jérémy Marchand & Jonathan Marchand                  #
# Mails : first_name.last_name@azubato.net                                   #
#                                                                            #
# YAVNE is free software: you can redistribute it and/or modify              #
# it under the terms of the GNU General Public License as published by       #
# the Free Software Foundation, either version 3 of the License, or          #
# (at your option) any later version.                                        #
#                                                                            #
# YAVNE is distributed in the hope that it will be useful,                   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of             #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
# GNU General Public License for more details.                               #
#                                                                            #
# You should have received a copy of the GNU General Public License          #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
############################################################################++

$KCODE = "UTF-8"

$LOAD_PATH << File.expand_path(File.dirname(__FILE__)+ "/..")

require "data/model.rb"
require "data/modelfactory.rb"
require "controller/controller.rb"
require "view/sdl_window.rb"
require "view/sdl_control_event_handler.rb"
require "view/gui.rb"

data = Model::ModelFactory.create_from_file("game.xml")
controller = Controller::Controller.new(data)
window = View::SDLWindow.new(800,600,16)
control_event_handler = View::SDLControlEventHandler.new()
app = View::Gui.new(controller, window, control_event_handler)
controller.view = app
app.init()
app.update_state(data.state)
app.init_view()
app.play()
app.main()
