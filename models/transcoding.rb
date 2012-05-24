class Transcoding < Sequel::Model
  
  plugin :validation_helpers
  
  def validate
    super
    validates_presence [:source, :destination, :format]
  end
end