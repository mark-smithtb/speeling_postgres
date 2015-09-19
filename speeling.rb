require 'sinatra'
require 'json'

get '/' do
  @dictionary_file = JSON.parse(File.read("dictionary_file.json"))
  erb :page
end

get '/search' do
  @search = params['search_word']
  @array_of_hashes = JSON.parse(File.read("dictionary_file.json"))
  erb :search
end

post '/save' do
  word = params['word']
  definition = params['definition']
  hash = {word: word, definition: definition}

  array_of_hashes = JSON.parse(File.read("dictionary_file.json"))
  array_of_hashes << hash

  File.open("dictionary_file.json", "w") do |file|
    file.puts array_of_hashes.to_json
  end
 redirect '/'
end
