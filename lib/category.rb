require 'sqlite3'

class Category
  attr_reader :name, :id

  @@next_index = 1

  def initialize(name:)
    @id = @@next_index
    @name = name
    @@next_index += 1
  end

  #CATEGORIES = [
  #  new(name: 'Ruby'),
  #  new(name: 'Rails'),
  #  new(name: 'PHP'),
  #  new(name: 'Laravel'),
  #  new(name: 'HTML'),
  #  new(name: 'CSS'),
  #  new(name: 'Git'),
  #]

  def to_s
    "##{id} - #{name}"
  end

  def self.all
    #CATEGORIES
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    categories = db.execute "SELECT * FROM categories"
    db.close
    categories.map {|category| new(name: category['name'])}
  end

  def self.index(number)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    category = db.execute "SELECT name FROM categories where id=#{number}"
    db.close
    category[0]['name']
    #CATEGORIES[number]
  end

end