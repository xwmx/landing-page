require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'
require 'mongo'
require 'compass'


configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end


get '/' do
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

post '/notify' do
  email = params[:email]
  unless email.nil? || email.strip.empty?
    port = 27089 # port from mongohq
    db = Mongo::Connection.new("mongohq-url", port).db("database")
    auth = db.authenticate("username", "password")
    coll = db.collection("emails")
    doc = {"email" => email}
    coll.insert(doc)
  end
  if request.xhr?
    "true"
  else
    "Thanks! We've got your email and will be in touch as soon as we're ready :)"
  end
end