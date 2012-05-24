ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV'].intern

DB = Sequel.sqlite "db/#{ENV['RACK_ENV']}.db"
DB.instance_eval do
  
  unless table_exists? :transcodings
    create_table :transcodings do
      primary_key :id
      String      :source
      String      :destination
      String      :format
      Float       :progress, default: 0.0
    end
  end
end

Sequel::Model.strict_param_setting = false
Sequel::Model.plugin :json_serializer

require_relative 'models/transcoding'
require_relative 'controllers/transcodings'
require_relative 'lib/transcoder'
require_relative 'lib/transcode'
