require './lib/category'

class StudyItem
  attr_reader :name, :category, :description, :concluded, :id

  def initialize(id: nil, name:, category:, description:, concluded: false, created_at: nil)
    @id = id
    @name = name
    @category = category
    @description = description
    @concluded = concluded
    @created_at = created_at
  end

  
  def to_s
    "##{id} - #{name} - #{category} - #{description}#{ concluded == 1 ? ' - Finalizada' : ' - Em Andamento'}"
  end

  def self.create
    print 'Digite o nome do item de estudo a ser cadastrado: '
    name = gets.chomp
    print_elements(Category.all)
    print 'Escolha uma categoria para o seu item de estudo: '
    category = Category.name_category(gets.to_i)
    print 'Digite a descrição do item de estudo a ser cadastrado: '
    description = gets.chomp
    description = 'Sem descrição' if description == ''
    db = SQLite3::Database.open "db/database.db"
    db.execute(<<~SQL, name, category, description, 0)
      INSERT INTO study_items (name, category, description, concluded) 
      VALUES(?, ?, ?, ?)
    SQL
    puts "Item '#{name}', de descrição '#{description}', da categoria '#{category}' cadastrado com sucesso!" 
  ensure
      db.close if db
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute("SELECT * FROM study_items")
    study_items
      .map { |hash| hash.transform_keys!(&:to_sym) }
      .map { |study_item| new(**study_item)}
  ensure
    db.close if db
  end

  def self.search(term)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE name LIKE '%#{term}%' or category LIKE '%#{term}%' or description LIKE '%#{term}%'"
    study_items
      .map {|hash| hash.transform_keys!(&:to_sym)}
      .map {|study_item| new(**study_item)}
  ensure
    db.close if db
  end

  def self.not_concluded
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE concluded=false"
    study_items
      .map {|hash| hash.transform_keys!(&:to_sym)}
      .map {|study_item| new(**study_item)}
  ensure
    db.close if db
  end

  def self.search_by_category(term)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE category LIKE '%#{term}%'"
    study_items
      .map {|hash| hash.transform_keys!(&:to_sym)}
      .map {|study_item| new(**study_item)}
  ensure
    db.close if db
  end

  def self.to_concluded(index)
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE study_items SET concluded=true WHERE id=#{index}"
    puts "Item marcado como concluído."
  ensure
    db.close if db
  end
  
  def self.destroy(index)
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM study_items where id=#{index}"
    puts "Item excluído."
  ensure
    db.close if db
  end

end