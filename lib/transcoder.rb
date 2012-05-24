require 'open-uri'
require 'tempfile'

class Transcoder
  
  def initialize(input, extension='m4v')
    @input = FFMPEG::Movie.new(input)
    @extension = extension
  end
  
  def self.from_url(input, extension)
    new open(input).path, extension
  end
  
  def transcode
    t = Tempfile.open(['transcoder', ".#{@extension}"]) do |output|
      @input.transcode(output.path) do |progress| 
        yield progress, output if block_given?
      end
    end
    t
  end
  
  def screenshot
    @input.screenshot(@output, options, transcoder_options)
  end
  
  def options
    {}
  end
  
  def transcoder_options
    { preserve_aspect_ratio: :width }
  end
end