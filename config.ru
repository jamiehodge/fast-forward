require './env'
require 'resque/server'

map '/' do
  run Transcodings
end

map '/resque' do
  run Resque::Server
end