require "view/renderable.rb"
require "view/image.rb"
require "view/text.rb"

module View

  class Textbox < CompoundRenderable
    
    attr_reader :box, :texts

    def initialize(box,texts,interline=0)
      super()
      @box = box
      @w = @box.w
      @h = @box.h
      @x = @box.x
      @y = @box.y
      @interline = interline
      @leftmargin = 0
      @rightmargin = 0
      @topmargin = 0
      @bottommargin = 0
      @texts = Array.new()
      texts.each { |line|
        update_lines(line)
      }
      @cursor = 0
      update_viewable_texts()
      @elements = [@box] + @texts
      @render_elements = [@box] + @viewable_texts
    end

    def dichotomic(arr,test)
      if arr.size() == 1 then
        return 0
      else
        def loop(test,i,min,max)
          if test[i] then
            if i == max - 1 then
              return i
            else
              new_i = (max-i)/2 + i
              loop(test,new_i,i,max)
            end
          else
            if i == 0 then
              return i
            else
              new_i = (i-min)/2 + min
              loop(test,new_i,min,i)
            end
          end
        end
      end
      loop(test,(arr.size()-1),0,arr.size())
    end
    
    def update_lines(line)
      test = lambda { |arr| lambda { |i|
          text=arr[0..i].join(" ")
          render = Text.new(text,line.color,line.font,line.size)
        return render.w <= @box.w - @leftmargin - @rightmargin
        }}
      arr = line.text.split()
      def loop1(test,arr,line)
        if !arr.empty? then
          cand = dichotomic(arr,test[arr])
          text = Text.new(arr[0..cand].join(" "),line.color,line.font,line.size)
          @texts.push(text)
          if cand < arr.size() - 1 then
            loop1(test,arr[(cand+1)..(arr.size()-1)],line)
          end
        end
      end
      loop1(test,arr,line)
    end

    def update_viewable_texts()
      test = lambda { |arr| lambda { |i|
          lines_height = 0
          arr[0..i].each{ |line|
            lines_height += line.h
          }
          height = lines_height + ((i-1)* @interline) + @topmargin + @bottommargin
          return height < @box.h
        }}
      if @texts[@cursor] != nil then
        arr = @texts[@cursor..(@texts.size()-1)]
        cand = dichotomic(arr,test[arr])
        @cursor = cand + 1
        @viewable_texts = arr[0..cand]
        @rendered = cand >= (arr.size()-1)
      end
    end

    def next()
      update_viewable_texts()
      set_pos(@x,@y)
      @render_elements = [@box] + @viewable_texts
    end

    def reset()
      @cursor = 0
      update_viewable_texts()
      @render_elements = [@box] + @viewable_texts
    end
    
    def set_pos(x,y)
      @box.set_pos(x,y)
      current_x = @box.x + @leftmargin
      current_y = @box.y + @topmargin
      @viewable_texts.each_index { |i|        
        @viewable_texts[i].set_pos(current_x,current_y)
        current_y += @viewable_texts[i].h + @interline
      }
      @x = @box.x
      @y = @box.y
    end

  end

end
