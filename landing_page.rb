require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'
require 'mongo'

set :haml, {:format => :html5 }

get '/' do
  haml :index
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

post '/notify' do
  email = params[:email]
  port = 27089 # port from mongohq
  db = Mongo::Connection.new("mongohq-url", port).db("database")
  auth = db.authenticate("username", "password")
  coll = db.collection("emails")
  doc = {"email" => email}
  coll.insert(doc)
  if request.xhr?
    "true"
  else
    "Thanks! We've got your email and will be in touch as soon as we're ready :)"
  end
end