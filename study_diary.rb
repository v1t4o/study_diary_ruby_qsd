class Category
  attr_accessor :name
  def initialize(name: 'Geral')
    @name = name
  end
end

class StudyItem
  attr_accessor :name, :category, :description
  def initialize(name:, category: Category.new, description: 'Sem descrição')
    @name = name
    @category = category
    @description = description
  end
end

class StudyDiary
  attr_accessor :items
  def initialize(items: [])
    @items = items
  end

  def menu
    option_selected = 0
    while option_selected != 4
      menu_options = <<~MENU
        __________________________________\n
        ______________Menu________________\n
        [1] Cadastrar um item para estudar
        [2] Ver todos os itens cadastrados
        [3] Buscar um item de estudo
        [4] Sair
        Escolha uma opção:\n
      MENU
      puts menu_options
      option_selected = gets().chomp().to_i
      case option_selected
      when 1
        create_item_for_study
      when 2
        list_items_for_study
      when 3
        search_item_for_study
      when 4
        puts "\n\nObrigado por usar o Diário de Estudos"
      else
        puts "\n\nOpção não encontrada. Tente novamente.\n\n"
      end
    end
  end

  def create_item_for_study
    puts "\n\nDigite o nome do item de estudo a ser cadastrado:\n\n"
    items << StudyItem.new(name: gets().chomp().to_s)
    puts "\n\n"
  end

  def list_items_for_study
    puts "\n\nItems Cadastrados\n\n"

    items.each do |item|
      puts "- #{item.name}"
    end

    puts "\n\n"
  end

  def search_item_for_study
    puts "\n\nDigite abaixo o nome do item, ou parte dele, que deseja buscar:\n\n"

    item = gets().chomp().to_s

    puts "\n\nItems encontrados\n\n"

    items_searched = items.select {|i| i.name.downcase.include? item.downcase}
    if items_searched.length != 0
      items_searched.each do |item|
        puts "- #{item.name}"
      end
      puts "\n\n"
    else
      puts "\n\nNenhum item encontrado com o termo de busca\n\n"
    end

  end
end

StudyDiary.new.menu()