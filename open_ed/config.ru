require 'environment'

# Turn off sinatra logging so things won't be double logged
disable :logging

use Rack::ShowExceptions
run Sinatra::Application
