require 'ruby-processing'

class Fixnum
  def sec
    self * 1000
  end
end

class Sketch < Processing::App
  load_java_library "opengl"
  
  def setup
    render_mode(OPENGL)
    frame_rate 30
    
    hint(ENABLE_NATIVE_FONTS)
    f = create_font("Lucida Grande", 66)
    text_font f, 1.0
    
    fill 255
    
    at(1000) do
      type "you", 0, 0
    end
    at(1200) do
      type "need", 0, 1
    end
    at(1400) do
      type "a", 0, 2
    end
    at(1700) do
      rotate_z @rotate ||= 0.0
      @rotate += 0.4 unless @rotate >= 1.6
      
      background 0
      type "you", 0, 0
      type "need", 0, 1
      type "a", 0, 2
    end
    at(2000) do
      type "LOL", 1, 2
    end
    at(2200) do
      type "LOLCAT", 1, 2
    end
    at(2400) do
      @x ||= 0
      background 0
      
      @x -= 2
      type "LOLCAT  ... rly!", @x, 2
    end
    at(2500) do
    end

    background 0
  end
  
  def draw
    translate 80, 100
    scale 75.0, 75.0, 75.0
    text_width 100
    
    run_markers
  end
  
  def type(letter, x, y=0)
    text letter, 0.6 * x, y
  end
  
  @@markers = []
  def at(time, &block)
    @@markers << [time, block]
    @@markers = @@markers.sort_by { |time, _| time }.reverse
  end
  
  def run_markers
    @@markers.each do |time, block|
      if millis >= time
        block.call
        break
      end
    end
  end
end

Sketch.new :width => 400, :height => 400, :title => "Font"