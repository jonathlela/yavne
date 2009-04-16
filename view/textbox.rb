require "view/renderable.rb"
require "view/image.rb"
require "view/text.rb"

module View

  class Textbox < CompoundRenderable
    
    attr_reader :box, :texts

    def initialize(box, paragraphs, interline=0)
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
      @textLines = Array.new
      @texts = Array.new()
      paragraphs.each { |paragraph|
        textLines = convertParagraphToTextLinesFittingBoxWidth(paragraph);
        textLines.each { |textLine|
          @texts.push Text.new(textLine, paragraph.color, paragraph.font, paragraph.size)
        }
        @textLines += textLines
      }
      @cursor = 0
      update_viewable_texts()
      
      @elements = [@box] + @texts
      @render_elements = [@box] + @viewable_texts
    end

    def dichotomic(arr, &test)
      if arr.size() == 1 then
        return 0
      else
        loop = lambda { |i, min, max|
          if test.call(i) then
            if i == max - 1 then
              return i
            else
              new_i = (max-i)/2 + i
              loop.call(new_i, i, max)
            end
          else
            if i == 0 then
              return i
            else
              new_i = (i-min)/2 + min
              loop.call(new_i, min, i)
            end
          end
        }
        loop.call((arr.size()-1), 0, arr.size())
      end
    end
    
    def convertParagraphToTextLinesFittingBoxWidth(paragraph)
      textLines = Array.new 
      renderedLineIsShorterThanTextBox = lambda { |words| lambda { |i|
          text=words[0..i].join(" ")
          w,h = Text::text_size(text,paragraph.font,paragraph.size)
          return w <= @box.w - @leftmargin - @rightmargin
        }
      }
      words = paragraph.text.split
      findLongestTextsComplyingToCondition = lambda { |condition, words, paragraph, textLines|
        if !words.empty? then
          cand = dichotomic(words, &condition.call(words))
          text = words[0..cand].join(" ")
          textLines.push(text)
          if cand < words.size() - 1 then
            findLongestTextsComplyingToCondition.call(condition,words[(cand+1)..(words.size()-1)],paragraph, textLines)
          end
        end
      }
      findLongestTextsComplyingToCondition.call(renderedLineIsShorterThanTextBox,words,paragraph,textLines)
      return textLines
    end

    def update_viewable_texts()
      test = lambda { |arr| lambda { |i|
          lines_height = 0
          arr[0..i].each{ |line|
            lines_height += line.h
          }
          height = lines_height + ((i-1)* @interline) + @topmargin + @bottommargin
          return height < @box.h
        }
      }
      if @texts[@cursor] != nil then
        arr = @texts[@cursor..(@texts.size()-1)]
        cand = dichotomic(arr,&test[arr])
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
