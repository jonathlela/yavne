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

require "data/element.rb"
require "data/image.rb"
require "data/text.rb"
require "data/positionnable.rb"

module Model

  class Textbox < CompoundElement

    attr_reader :box, :texts

    include Positionnable

    def initialize(box)
      super([box])
      @box = box
      @texts = Array.new()
      @type = "textbox"
    end

    def add_text(text)
      @texts.push(text)
      add(text)
    end
    
  end


end
