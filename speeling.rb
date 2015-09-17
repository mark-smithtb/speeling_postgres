require 'net/https'
require 'webrick'
require 'json'
require 'erb'

class Dictionary < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    template = File.read("page.html.erb")
    dictionary_file = JSON.parse(File.read("dictionary_file.json"))

    response.status = 200
    response.body = ERB.new(template).result(binding)
  end
end

class Saveword < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    word       = request.query["word"]
    definition = request.query["definition"]

    hash = {
      :word => word,
      :definition => definition
    }

    array_of_hashes = JSON.parse(File.read("dictionary_file.json"))
    array_of_hashes << hash

    File.open("dictionary_file.json", "w") do |file|
      file.puts array_of_hashes.to_json
    end

    response.status = 302
    response.header['location'] = '/'
    response.body = 'Your word was added.'
  end
end

class Search < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    search = request.query['search_word']
    template = File.read("search.html.erb")
    array_of_hashes = JSON.parse(File.read("dictionary_file.json"))

    response.status = 200
    response.body = ERB.new(template).result(binding)
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount '/', Dictionary
server.mount '/save', Saveword
server.mount '/search', Search
trap('INT') do
  server.shutdown
end

server.start
