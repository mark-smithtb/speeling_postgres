require 'sinatra'
require 'pg'
require 'active_record'


ActiveRecord::Base.establish_connection(
adapter: "postgresql",
host: "localhost",
username: "thad",
database: "dictionary"
)

class Word < ActiveRecord::Base
  validates :word, presence: true
  has_many :meanings
end

class Meaning < ActiveRecord::Base
  validates :meaning, presence: true
  belongs_to :word
end

get '/' do
  erb :page
end

get '/search' do
  @search = params['search_word']
  erb :search
end

post '/save' do
  word_input = params['word']
  meaning_input = params['definition']
  if Word.find_by_word(word_input) == nil
  word = Word.create(word: word_input)
else
  word = Word.find_by_word(word_input)
end
  meaning = Meaning.create(word_id: word.id , meaning: meaning_input)

  if word.valid? && meaning.valid?
    redirect '/'
  else
    redirect '/error'
  end
end

get '/error' do
  erb :error
end
