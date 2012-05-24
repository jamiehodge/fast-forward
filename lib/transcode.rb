require 'net/http'

class Transcode
  @queue = :transcode
  
  def self.perform(id, source, destination)
    transcoding = Transcoding[id]
    
    transcoder = Transcoder.from_url source
    transcoder.transcode do |progress, output|
      transcoding.update progress: progress
      if progress == 1.0
        uri = URI destination
        res = Net::HTTP.post_form uri, file: output
      end
    end
  end
end



