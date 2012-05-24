class Transcodings < Sinatra::Base
  
  enable :method_overrides
  
  get '/' do
    Transcoding.to_json root: true
  end
  
  post '/' do
    @transcoding = Transcoding.new.set_only params, :source, :destination, :format
    @transcoding.save
    
    Resque.enqueue Transcode, @transcoding.id, params[:source], params[:destination]
    
    headers \
      'Location' => url("/#{@transcoding.id}")
    
    @transcoding.to_json root: true
  end
  
  before %r{^/(?<id>\d+)} do
    @transcoding = Transcoding[ params[:id] ] || not_found
  end
  
  get '/:id' do
    @transcoding.to_json root: true
  end
  
  before do
    content_type :json
    headers \
      'Access-Control-Allow-Origin'  => '*',
      'Access-Control-Allow-Methods' => %w{GET POST PUT DELETE}.join(','),
      'Access-Control-Allow-Headers' => %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")
  end
end