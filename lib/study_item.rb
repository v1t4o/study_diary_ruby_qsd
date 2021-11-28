require './lib/category'

class StudyItem
  attr_reader :name, :category, :description, :concluded, :id

  #@@next_index = 1
  #@@study_items = []

  def initialize(id:, name:, category:, description:, concluded:)
    #@id = @@next_index
    @id = id
    @name = name
    @category = category
    @description = description
    @concluded = concluded
    #@@next_index += 1
    #@@study_items << self
  end

  #def concluded?
  #  @concluded
  #end
  
  #def concluded!
  #  @concluded = true
  #end

  #def not_concluded?
  #  !@concluded
  #end

  def to_s
    "##{id} - #{name} - #{category} - #{description}#{ concluded == 1 ? ' - Finalizada' : ' - Em Andamento'}"
  end

  #def include?(term)
  #  name.downcase.include? term.downcase or category.downcase.include? term.downcase or description.downcase.include? term.downcase
  #end

  #def include_category?(term)
  #  category.downcase.include? term.downcase
  #end

  def self.create
    print 'Digite o nome do item de estudo a ser cadastrado: '
    name = gets.chomp
    print_elements(Category.all)
    print 'Escolha uma categoria para o seu item de estudo: '
    category = Category.index(gets.to_i)
    print 'Digite a descrição do item de estudo a ser cadastrado: '
    description = gets.chomp
    description = 'Sem descrição' if description == ''
    #StudyItem.new( name: name, category: category_id, description: description)
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO study_items (name, category, description, concluded) VALUES('#{name}','#{category}','#{description}',false)"
    db.close
    puts "Item '#{name}', de descrição '#{description}', da categoria '#{category}' cadastrado com sucesso!" 
  end

  def self.all
    #@@study_items
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items"
    db.close
    study_items.map {|study_item| new(id: study_item['id'], name: study_item['name'], category: study_item['category'], description: study_item['description'], concluded: study_item['concluded'])}
  end

  def self.search(term)
    #all.filter { |element| element.include?(term) }
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE name LIKE '%#{term}%' or category LIKE '%#{term}%' or description LIKE '%#{term}%'"
    db.close
    study_items.map {|study_item| new(id: study_item['id'],name: study_item['name'], category: study_item['category'], description: study_item['description'], concluded: study_item['concluded'])}
  end

  def self.not_concluded
    #all.filter(&:not_concluded?)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE concluded=false"
    db.close
    study_items.map {|study_item| new(id: study_item['id'], name: study_item['name'], category: study_item['category'], description: study_item['description'], concluded: study_item['concluded'])}
  end

  def self.search_by_category(term)
    #all.filter { |element| element.include_category?(term) }
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    study_items = db.execute "SELECT * FROM study_items WHERE category LIKE '%#{term}%'"
    db.close
    study_items.map {|study_item| new(id: study_item['id'], name: study_item['name'], category: study_item['category'], description: study_item['description'], concluded: study_item['concluded'])}
  end

  def self.to_concluded(index)
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE study_items SET concluded=true WHERE id=#{index}"
    db.close
    puts "Item marcado como concluído."
  end
  
  def self.destroy(index)
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM study_items where id=#{index}"
    db.close
    puts "Item excluído."
  end

end