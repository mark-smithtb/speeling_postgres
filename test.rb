require 'sqlite3'
require 'Active_Record'


ActiveRecord::Base.establish_connection(
adapter: "sqlite3",
database: File.dirname(__FILE__) + "/dictionary.db"
)

class Word < ActiveRecord::Base
  validates :word, presence: true
  has_many :meanings
end

class Meaning < ActiveRecord::Base
  validates :meaning, presence: true
  belongs_to :word
end


p Word.find_by_word("moose")
