class Transcode
  @queue = :transcode
  
  def self.perform(id, source, format, destination, asset_id)
    transcoding = Transcoding[id]
    
    transcoder = Transcoder.from_url source, format
    transcoder.transcode do |progress, output|
      transcoding.update progress: progress
      RestClient.post destination, { file: output, asset_id: asset_id } if progress == 1.0
    end
  end
end



