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

module Model

  # An Element is the basic type of the different elemnts in a game

  class Element
    
    NO_TIME = "notime"
    
    @@ids = 0

    attr_reader :type, :id

    def initialize ()
      @@ids += 1
      @id = @@ids
    end
    
    # Tell if an Element is single or made with several elements

    def compound? () 
      return @compound
    end

  end

  # A SingleElement is the simpler element type

  class SingleElement < Element
    
    attr_accessor :time 

    def initialize (time=NO_TIME)
      super()
      @compound = false
      @time = time
    end

  end

  # A CompoundElement is a lement composes by serveral elements 

  class CompoundElement < Element

    attr_reader :elements

    def initialize (elements)
      super()
      @compound = true
      @elements = Hash.new()
      elements.each { |elt|
        add(elt)
      }
    end

    def add (element)
      @elements[element.id] = element
    end

  end


end
