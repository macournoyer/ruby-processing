require 'ruby-processing'

class Text
  attr_accessor :text, :x, :y, :width
  
  def initialize(sketch, text, x, y)
    @text   = text
    @x, @y  = x, y
    @width  = sketch.text_width(text)
    @sketch = sketch
    
    fx = 0.0
    @chars = text.split("").map do |c|
      char = Char.new(c, fx, 0.0)
      fx += sketch.text_width(c)
      char
    end
  end
  
  def center
    @width / 2.0
  end
  
  def draw
    @chars.each { |c| c.draw(@sketch) }
    self
  end
  
  def shake
    @chars.each_with_index do |c, i|
      c.x = rand(100) / 1000.0 + @sketch.text_width(@text[0...i])
      c.y = rand(100) / 1000.0
    end
    self
  end
  
  def circle(rad)
    @step ||= 0
    @chars.reverse.each_with_index do |c, i|
      c.x = @x + center + Math.sin(@step + i) * rad
      c.y = @y - Math.cos(@step + i) * rad
    end
    @step += 0.05
    self
  end
end

class Char
  attr_accessor :char, :x, :y
  def initialize(char, x, y)
    @char = char
    @x = x
    @y = y
  end
  
  def draw(sketch)
    sketch.text @char, @x, @y
  end
  
  def inspect
    "<#{@char}:#{@x},#{@y}>"
  end
end

class Sketch < Processing::App
  load_java_library "opengl"

  def setup
    render_mode(OPENGL)

    frame_rate 30

    hint(ENABLE_NATIVE_FONTS)
    f = create_font("Georgia", 66)
    text_font f, 1.0

    fill 255
    text_width 100
    
    @text = Text.new(self, "round&", 0.0, 0.0)
  end

  def draw
    background 0
    translate 20, 200
    scale 75.0, 75.0, 75.0
    rotate_x -0.6
    rotate_y 0.6
    
    @text.
    # shake.
      circle(1.2).
      draw
  end
end

Sketch.new :width => 300, :height => 300, :title => "Anim Type"