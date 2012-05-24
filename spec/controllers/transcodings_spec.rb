require_relative '../spec_helper'

describe Transcodings do
  
  def app
    Transcodings
  end
  
  def parsed_response
    Yajl::Parser.parse last_response.body
  end
  
  let :transcoding do
    Fabricate.build :transcoding
  end
  
  describe 'GET /' do
    
    describe 'without transcodings' do
      
      it 'returns an empty array' do
        get '/'
        parsed_response.must_equal('transcodings' => [])
      end
      
    end
    
    describe 'with transcodings' do
      
      before do
        transcoding.save
      end
      
      it 'returns a non-empty array' do
        get '/'
        parsed_response.must_equal(
          'transcodings' => [
            {
              'transcoding'  =>
                {
                  'id'          => transcoding.id,
                  'source'      => transcoding.source,
                  'destination' => transcoding.destination,
                  'format'      => transcoding.format,
                  'progress'    => transcoding.progress
                }
            }
          ]
        )
      end
      
    end
     
  end
  
  describe 'POST /' do
  
    before do
      post '/', transcoding.values
    end
    
    after do
      Transcoding.destroy
    end
    
    it 'creates transcoding' do
      Transcoding.count.must_equal 1
    end
    
    it 'returns location of transcoding' do
      last_response.headers['Location'].must_equal 'http://example.org/1'
    end
  end
  
  describe '/:id' do
    
    before do
      transcoding.save
    end
    
    describe 'GET /:id' do
      
      it 'returns transcoding' do
        get "/#{transcoding.id}"
        parsed_response.must_equal(
        'transcoding'  =>
          {
            'id'          => transcoding.id,
            'source'      => transcoding.source,
            'destination' => transcoding.destination,
            'format'      => transcoding.format,
            'progress'    => transcoding.progress
          }
        )
          
      end
    end
  end
end