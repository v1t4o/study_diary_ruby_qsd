require './lib/category'

class StudyItem
  attr_reader :name, :category, :description, :id

  @@next_index = 1
  @@study_items = []

  def initialize(name:, category:, description:)
    @id = @@next_index
    @name = name
    @category = category
    @description = description
    @concluded = false
    @@next_index += 1
    @@study_items << self
  end

  def concluded?
    @concluded
  end
  
  def concluded!
    @concluded = true
  end

  def not_concluded?
    !@concluded
  end

  def to_s
    "##{id} - #{name} - #{category} - #{description}#{ concluded?? ' - Finalizada' : ' - Em Andamento'}"
  end

  def include?(term)
    name.downcase.include? term.downcase or category.name.downcase.include? term.downcase or description.downcase.include? term.downcase
  end

  def include_category?(term)
    category.name.downcase.include? term.downcase
  end

  def self.create
    print 'Digite o nome do item de estudo a ser cadastrado: '
    name = gets.chomp
    print_elements(Category.all)
    print 'Escolha uma categoria para o seu item de estudo: '
    category = Category.index(gets.to_i - 1)
    print 'Digite a descrição do item de estudo a ser cadastrado: '
    description = gets.chomp
    puts "Item '#{name}', '#{description}' da categoria '#{category}' cadastrado com sucesso!"
    description = 'Sem descrição' if description == ''
    StudyItem.new( name: name, category: category, description: description)
  end

  def self.all
    @@study_items
  end

  def self.search(term)
    all.filter { |element| element.include?(term) }
  end

  def self.not_concluded
    all.filter(&:not_concluded?)
  end

  def self.search_by_category(term)
    all.filter { |element| element.include_category?(term) }
  end
  
end