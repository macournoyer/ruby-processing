# -- omygawshkenas

require 'ruby-processing'

class Contextual < Processing::App
  load_ruby_library "context-free"  
  attr_accessor :tree
  
  def setup_the_trees
    
    @tree = context_free do
      rule :seed do
        square
        leaf :y => 0 if size < 4.5 && rand < 0.018
        flower :y => 0 if size < 2.0 && rand < 0.02
        seed :y => -1, :size => 0.986, :rotation => 6, :brightness => 0.989
      end
      
      rule :seed, 0.1 do
        square
        seed :flip => true
      end
      
      rule :seed, 0.04 do
        square
        split do
          seed :flip => true
          rewind
          seed :size => 0.8, :rotation => rand(100), :flip => true
          rewind
          seed :size => 0.8, :rotation => rand(100)
        end
      end
      
      rule :leaf do
        the_size = rand(25)
        the_x = [1, 0, 0, 0][rand(4)]
        circle :size => the_size, :hue => 0.15, :saturation => 1.25, :brightness => 1.9, :x => the_x
      end
      
      rule :flower do
        split :brightness => rand(1.3)+4.7, :set_width => rand(15)+10, :set_height => rand(2)+2 do
          oval :rotation => 0
          oval :rotation => 45
          oval :rotation => 90
          oval :rotation => 135
        end
      end
    end
  end
  
  
  def setup
    setup_the_trees
    no_stroke
    smooth
    the_color = [0.5, 0.7, 0.8]
    @tree.setup :start_x => width/2, :start_y => height+20, :size => height/60, :color => the_color
    draw_it
  end
  
  def draw_the_background
    color_mode RGB, 1
    color = [0.0, 0.0, 0.00]
    background *color
    count = height/2
    push_matrix
    size = height / count
    (2*count).times do |i|
      color[2] = color[2] + (0.07/count)
      fill *color
      rect 0, i, width, 1
    end
  end
  
  def draw_it
    draw_the_background
    @tree.render :seed
  end
  
  def mouse_clicked
    draw_it
  end
  
end

Contextual.new(:width => 700, :height => 700, :title => "Contextual Tree")