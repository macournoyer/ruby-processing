require 'ruby-processing'

class Circle
  attr_accessor :x, :y, :r
  
  def initialize(x, y, r, color)
    @x, @y, @r, @color = x, y, r, color
  end
  
  def draw(sketch)
    sketch.push_matrix
    sketch.fill *@color
    sketch.translate @x, @y
    # sketch.light_specular(1, 1, 1)
    # sketch.directional_light(0.8, 0.8, 0.8, 0, 0, -1)
    sketch.sphere @r
    sketch.pop_matrix
  end
end

class Sketch < Processing::App
  include Math
  
  def setup
    render_mode(P3D)
    no_stroke
    color_mode(RGB, 1)
    frameRate 30
    
    @center = Circle.new(200, 200, 100, [0.5, 0.1, 0])
    @particles = [
      Circle.new(100, 100, 10, [0.1, 0.8, 0.8]),
      Circle.new(300, 100, 10, [0.1, 0.8, 0.8]),
      Circle.new(100, 300, 10, [0.9, 0.9, 0.8]),
      Circle.new(300, 300, 10, [0.1, 0.9, 0.1])
    ]
    @growing = true
    @step = 0
  end
  
  def draw
    background 0
    
    if @growing
      @center.r += 10
      @growing = @center.r < 100
    else
      @center.r -= 1
      @growing = @center.r < 90
    end
    
    push_matrix
    translate 200, 200
    rotate_z @step
    translate -200, -200
    @step += @center.r / 10 + 50
    
    @particles.each { |p| p.draw(self) }
    @center.draw(self)
    pop_matrix
  end
end

Sketch.new :width => 400, :height => 400, :title => "Circle"