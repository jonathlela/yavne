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

require 'rexml/document'
require 'pathname'

require "data/state/state.rb"
require "data/element/single_element/image.rb"
require "data/element/single_element/text.rb"
require "data/element/single_element/music.rb"
require "data/element/single_element/sound.rb"
require "data/element/compound_element/textbox.rb"

module Model

  class StateLoader

    # Check if file exists on the file system

    def check_file (path, directory)
      path = Pathname.new(path)
      directory = Pathname.new(directory)
      if !path.absolute? then
        path = directory + path
      end
      if !(FileTest.exists? path.realpath) then
        raise "#{path.realpath} does not exist!"
      end
      return path.to_s
    end

    # Load external resources
    
    def get_resources (resources, directory)
      res = Hash.new()
      resources.each_element_with_attribute("path") { |element|
        element_path = element.attributes["path"]
        path = check_file(element_path, directory)
        id = element.attributes["id"]
        case element.name
        when "image"
          image = Image.new(path)
          res[id] = image
        when "font"
          res[id] = element.attributes["path"]
        when "music"
        music = Music.new(path)
          res[id] = music
        when "sound"
          sound = Sound.new(path)
          res[id] = sound
        end
      }
      return res 
    end
    
    # Link scenes between them and return the first scene

    def resolve (scenes)
      init = nil
      scenes.each_element { |scene|
        case scene.name
        when "init"
          init = @states[scene.attributes["scene"]]
        else
          next_state = scene.elements["next"].attributes["scene"]
          @states[scene.attributes["id"]].next = lambda { |x| @states[next_state]}
        end
      }
      return init
    end
    
    def position (object,element) 
      if element.elements["position"] != nil then
        horizontal = element.elements["position"].elements["horizontal"] 
        vertical = element.elements["position"].elements["vertical"] 
        if horizontal != nil then
          if horizontal.attributes.get_attribute("align") != nil then
            case horizontal.attributes["align"]
            when "left"
              object.left()
            when "center"
              object.center()
            when "right"
              object.right()
            end
          elsif horizontal.attributes.get_attribute("aligned_left_with") != nil then
            object.align_left(@resources[horizontal.attributes["aligned_left_with"]])
          elsif horizontal.attributes.get_attribute("aligned_center_with") != nil then
            object.align_center(@resources[horizontal.attributes["aligned_center_with"]])
          elsif horizontal.attributes.get_attribute("aligned_right_with") != nil then
            object.align_right(@resources[horizontal.attributes["aligned_right_with"]])
          elsif horizontal.attributes.get_attribute("left_of") != nil then
            object.left_of(@resources[horizontal.attributes["left_of"]])
          elsif horizontal.attributes.get_attribute("center_of") != nil then
            object.center_of(@resources[horizontal.attributes["center_of"]])
          elsif horizontal.attributes.get_attribute("right_of") != nil then
            object.right_of(@resources[horizontal.attributes["right_of"]])
          end
        end
        if vertical != nil then
          if vertical.attributes.get_attribute("align") != nil then
            case vertical.attributes["align"]
            when "top"
              object.top()
            when "middle"
              object.middle()
            when "bottom"
              object.bottom()
            end
          elsif vertical.attributes.get_attribute("aligned_top_with") != nil then
            object.align_top(@resources[vertical.attributes["aligned_top_with"]])
          elsif vertical.attributes.get_attribute("aligned_middle_with") != nil then
            object.align_middle(@resources[vertical.attributes["aligned_middle_with"]])
          elsif vertical.attributes.get_attribute("aligned_bottom_with") != nil then
            object.align_bottom(@resources[vertical.attributes["aligned_bottom_with"]])
          elsif vertical.attributes.get_attribute("top_of") != nil then
            object.top_of(@resources[vertical.attributes["top_of"]])
          elsif vertical.attributes.get_attribute("middle_of") != nil then
            object.middle_of(@resources[vertical.attributes["middle_of"]])
          elsif vertical.attributes.get_attribute("bottom_of") != nil then
            object.bottom_of(@resources[vertical.attributes["bottom_of"]])
          end
        end
      end
      return object
    end
    
    # Translate color to an understable

    def get_color (color, alpha="255")
      case color
      when /^#(\w\w)(\w\w)(\w\w)$/
        color = [$1.hex,$2.hex,$3.hex]
      else
        raise "#{color} is not a valid color!"
      end
      case alpha
      when "opaque"
        alpha = 255
      when "transparent"
        alpha = 0
      when /^#(\w\w)$/
        alpha = $1.hex
      else
        alpha = alpha.to_i
      end
      return color.push(alpha)
    end
    
    #

    def get_scenes (scenes)
      res = Hash.new()
      scenes.each_element("scene") { |scene|
        state = createState()
        scene.each_element { |element|
          case element.name
          when "background"
            id = element.attributes["id"]
            background = @resources[element.attributes["image"]]
            if element.attributes.get_attribute("timeout") != nil then
              background.time = element.attributes["timeout"].to_i
          end 
            @resources[id] = background
          when "sprite"
            id = element.attributes["id"]
            sprite = @resources[element.attributes["image"]]
            if element.attributes.get_attribute("timeout") != nil then
              sprite.time = element.attributes["timeout"].to_i
            end 
            @resources[id] = sprite
          when "texts"
            id = element.attributes["id"]
            box =  @resources[element.attributes["textbox"]]
            textbox = Textbox.new(box)
            element.each_element_with_attribute("data") { |text|
              if text.attributes["alpha"] != nil then
                color = get_color(text.attributes["color"],text.attributes["alpha"])
              else
                color = get_color(text.attributes["color"])
              end
              font = @resources[text.attributes["font"]]
              if text.attributes.get_attribute("timeout") != nil then
                text = Text.new(text.attributes["data"],color,font,text.attributes["size"].to_i,text.attributes["timeout"].to_i)
              else
                text = Text.new(text.attributes["data"],color,font,text.attributes["size"].to_i)
              end
              textbox.add_text(text)
            }
            if element.attributes.get_attribute("timeout") != nil then
              textbox.time = element.attributes["timeout"].to_i
            end
            @resources[id] = textbox
          when "music"
            music = @resources[element.attributes["play"]]
            if element.attributes.get_attribute("timeout") != nil then
              music.time = element.attributes["timeout"].to_i
            end
            state.music = music
          when "sound"
            sfx = @resources[element.attributes["play"]]
            if element.attributes.get_attribute("timeout") != nil then
              sfx.time = element.attributes["timeout"].to_i
            end
            state.sfx = sfx
          end
        }
        scene.each_element { |element|
          case element.name
          when "background"
            background = @resources[element.attributes["id"]]
            state.background = position(background,element)
          when "sprite"
            sprite = @resources[element.attributes["id"]]
            state.sprites.push(position(sprite,element))
          when "texts"
            textbox = @resources[element.attributes["id"]]
            state.textbox = position(textbox,element)
          end
        }
        res[scene.attributes["id"]] = state
      }
      return res
    end
    
    # Create a new state with a brand new id

    def create_state ()
      @increment_id +=1
      state = State.new(@increment_id)
      return state
    end
    
    def load_file (file)
      doc = REXML::Document.new(file)
      directory = File.expand_path(File.dirname(file.path))
      @increment_id = 0
      @resources = get_resources(doc.root.elements["resources"],directory)
      @states = get_scenes(doc.root.elements["play"])
      state = resolve(doc.root.elements["play"])
      return state
    end
    
  end
  
end
