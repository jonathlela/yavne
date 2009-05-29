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

require 'sdl'

module View

  class Clock
    
    def initialize ()
      @time = 0
      @is_paused = true
    end

    def get_time ()
      if !@is_paused then
        now = SDL::get_ticks()
        @time = @time + now - @last_tick
        @last_tick = now
      end
      return @time
    end

    def pause ()
      if !@is_paused then
        now = SDL::get_ticks()
        @time = @time + now - @last_tick
        @is_paused = true
      end
    end

    def resume ()
      if @is_paused then
        @last_tick = SDL::get_ticks()
        @is_paused = false
      end
    end

    def start ()
      resume()
    end
    
  end

end
