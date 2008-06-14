module View
  
  class Positionner
   
    def initialize(render,mediatracker)
      @render = render
      @mediatracker = mediatracker
    end

    def calculate_hpos(elt)
      render = @mediatracker.get_renderable(elt)
      case elt.horizontal.kind
      when Model::Position::ABSOLUTE
        case elt.horizontal.pos
        when Model::HorizontalPosition::LEFT
          return elt.horizontal.margin
        when Model::HorizontalPosition::CENTER
          return (@render.width/2) - (render.w/2) + elt.horizontal.margin
        when Model::HorizontalPosition::RIGHT
          return @render.width - (render.w) - elt.horizontal.margin  
        end
      when Model::Position::RELATIVE
        relative = @mediatracker.get_renderable(elt.horizontal.relative)
        rel = calculate_hpos(elt.horizontal.relative)
        case elt.horizontal.pos
        when Model::HorizontalPosition::LEFT
          return rel - render.w - elt.horizontal.margin
        when Model::HorizontalPosition::CENTER
          return rel + (relative.w/2) + elt.horizontal.margin
        when Model::HorizontalPosition::RIGHT
          return rel + relative.w + elt.horizontal.margin
              end
      when Model::Position::ALIGNED
        relative = @mediatracker.get_renderable(elt.horizontal.relative)
        rel = calculate_hpos(elt.horizontal.relative)
        case elt.horizontal.pos
        when Model::HorizontalPosition::LEFT
          return rel + elt.horizontal.margin
        when Model::HorizontalPosition::CENTER
          return rel + (relative.w/2) - (render.w/2) + elt.horizontal.margin
        when Model::HorizontalPosition::RIGHT
          return rel + relative.w - render.w - elt.horizontal.margin
        end
      end  
    end
    
    def calculate_vpos(elt)
      render = @mediatracker.get_renderable(elt)
      case elt.vertical.kind
      when Model::Position::ABSOLUTE
        case elt.vertical.pos
        when Model::VerticalPosition::TOP
          return elt.vertical.margin
        when Model::VerticalPosition::MIDDLE
          return (@render.height/2) - (render.h/2) + elt.vertical.margin
        when Model::VerticalPosition::BOTTOM
          return @render.height - (render.h) - elt.vertical.margin
        end
      when Model::Position::RELATIVE
        relative = @mediatracker.get_renderable(elt.vertical.relative)
        rel = calculate_vpos(elt.vertical.relative)
        case elt.vertical.pos
        when Model::VerticalPosition::TOP
          return rel - render.w - elt.vertical.margin
        when Model::VerticalPosition::MIDDLE
          return rel + (relative.h/2) + elt.vertical.margin
      when Model::VerticalPosition::BOTTOM
          return rel + relative.h + elt.vertical.margin
        end
      when Model::Position::ALIGNED
        relative = @mediatracker.get_renderable(elt.vertical.relative)
        rel = calculate_vpos(elt.vertical.relative)
        case elt.vertical.pos
        when Model::VerticalPosition::TOP
          return rel + elt.vertical.margin
        when Model::VerticalPosition::MIDDLE
          return rel + (relative.h/2) - (render.h/2) + elt.vertical.margin
        when Model::VerticalPosition::BOTTOM
          return rel + relative.h - render.h  - elt.vertical.margin
        end
      end
    end
    
  end 

end
