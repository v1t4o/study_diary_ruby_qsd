require 'sqlite3'

class Category
  attr_reader :name, :id

  def initialize(id: nil, name:, created_at: nil)
    @id = id
    @name = name
    @created_at = created_at
  end

  def to_s
    "##{id} - #{name}"
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    categories = db.execute("SELECT * FROM categories")
    categories
      .map {|hash| hash.transform_keys!(&:to_sym)}
      .map {|category| new(**category)}
  ensure
    db.close if db
  end

  def self.name_category(index)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    category = db.execute "SELECT name FROM categories where id=#{index}"
    category.first['name']
  ensure
    db.close if db    
  end

end