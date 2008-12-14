# http://code.compartmental.net/tools/minim/manual-beatdetect/
require 'ruby-processing'

class Sketch < Processing::App
  load_java_library "minim"
  include_package "ddf.minim"
  include_package "ddf.minim.analysis"

  def setup
    @minim = Minim.new(self)
    @input = @minim.load_file("/Users/marc/Music/iTunes/iTunes Music/Gnarls Barkley/St. Elsewhere/05 Smiley faces.mp3")
    @input.play
    @fft = FFT.new(@input.left.size, 44100)
    @beat = BeatDetect.new
    @radius = 0
  end
  
  def stop
    @input.close
    @minim.stop
    super
  end
  
  def draw
    background 0
    stroke 255
    @beat.detect @input.left
    @radius = 80 if @beat.is_onset
    @radius *= 0.95
    oval width/2, height/2, @radius, @radius
    @fft.forward @input.left
    scale = height / 4
    (@input.buffer_size - 1).times do |i|
      line(i, scale + @input.left.get(i)*scale, i+1, scale + @input.left.get(i+1) * scale)
    end
    scale = width / 50
    50.times do |i|
      @fft.scale_band i, (1 + 0.35 * i)
      @fft.scale_band i, 0.3
      line i*scale, height, i*scale, height - @fft.get_band(i)*4
    end
  end
end

Sketch.new :width => 400, :height => 400, :title => "beat"