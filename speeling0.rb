require 'net/https'
require 'sinatra'
require 'json'
require 'erb'

get '/' do
  erb :page
end

get '/search' do
  erb :search
end

post '/save' do
  word = params['word']
  definition = params['definition']
 redirect '/'
end
