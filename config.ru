require './fileku.rb'

set :environment, :production
set :run, false

set :color, '#000'
set :the_root, '/mnt/Docs/'
set :show_hidden, false

run Sinatra::Application