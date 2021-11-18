class Category
  attr_accessor :name
  def initialize(name: 'Geral')
    @name = name
  end
end

class StudyItem
  attr_accessor :id, :name, :category, :description, :status
  def initialize(id:, name:, category: Category.new, description: 'Sem descrição', status: 'Em Andamento')
    @id = id
    @name = name
    @category = category
    @description = description
    @status = status
  end
end

class StudyDiary
  attr_accessor :items
  def initialize(items: [])
    @items = items
  end

  def menu
    option_selected = 0
    while option_selected != 6
      menu_options = <<~MENU
        __________________________________\n
        ______________Menu________________\n
        [1] Cadastrar um item para estudar
        [2] Deletar um item de estudo
        [3] Marcar item como concluído
        [4] Ver todos os itens cadastrados
        [5] Buscar um item de estudo
        [6] Sair
        Escolha uma opção:\n
      MENU
      puts menu_options
      option_selected = gets().chomp().to_i
      case option_selected
      when 1
        create_item_for_study
      when 2
        delete_item_for_study
      when 3
        mark_item_for_study_concluded
      when 4
        puts "\n\nFiltrar itens por categoria? (S, N)\n\n"
        result = gets().chomp().to_s
        if result.downcase == 's'
          puts "\n\nDigite o nome da categoria que deseja filtrar?\n\n"
          search_category = gets().chomp().to_s
          list_items_for_study(search_category)
        else
          list_items_for_study
        end
      when 5
        search_item_for_study
      when 6
        puts "\n\nObrigado por usar o Diário de Estudos"
      else
        puts "\n\nOpção não encontrada. Tente novamente.\n\n"
      end
    end
  end

  def create_item_for_study
    puts "\n\nDigite o nome do item de estudo a ser cadastrado:\n\n"
    nome = gets().chomp().to_s
    puts "\n\nDigite a categoria do item de estudo a ser cadastrado:\n\n"
    categoria = Category.new(name: gets().chomp().to_s)
    puts "\n\nDigite a descrição do item de estudo a ser cadastrado:\n\n"
    descricao = gets().chomp().to_s
    puts "\n\n"
    id_item = items.length + 1
    if categoria.name != '' && descricao != ''
      items << StudyItem.new(id: id_item, name: nome, category: categoria, description: descricao)
    elsif categoria.name != '' && descricao == ''
      items << StudyItem.new(id: id_item, name: nome, category: categoria)
    else
      items << StudyItem.new(id: id_item, name: nome, description: descricao)
    end
  end

  def delete_item_for_study
    puts "\n\nDigite o código do item a ser deletado:\n\n"
    item_for_delete = gets().chomp().to_i
    if item_for_delete <= items.length
      items.delete_at(item_for_delete - 1)
    else
      puts "\n\nCódigo não localizado. Tente novamente.\n\n"
    end
  end

  def mark_item_for_study_concluded
    puts "\n\nDigite o código do item a ser concluído:\n\n"
    item_for_concluded = gets().chomp().to_i
    if item_for_concluded <= items.length
      items[item_for_concluded - 1].status = 'Concluído'
    else
      puts "\n\nCódigo não localizado. Tente novamente.\n\n"
    end
  end

  def list_items_for_study(search_category = '')
    puts "\n\nItems Cadastrados\n\n"
    if search_category == ''
      items.each do |item|
        puts "[#{item.id}] - Nome: #{item.name} / Categoria: #{item.category.name} / Descrição: #{item.description} / Status: #{item.status}"
      end
    else
      items_searched = items.select {|i| i.category.name.downcase.include? search_category.downcase}
      if items_searched.length != 0
        items_searched.each do |item|
          puts "[#{item.id}] - Nome: #{item.name} / Categoria: #{item.category.name} / Descrição: #{item.description} / Status: #{item.status}"
        end
        puts "\n\n"
      else
        puts "\n\nNenhum item encontrado com a categoria digitada\n\n"
      end
    end
    puts "\n\n"
  end

  def search_item_for_study
    puts "\n\nDigite abaixo o nome do item, ou parte dele, que deseja buscar:\n\n"

    term_of_search = gets().chomp().to_s

    puts "\n\nItems encontrados\n\n"
    items_searched = []

    items.each do |item|
      name_searched = item.name.downcase.include? term_of_search.downcase
      category_searched = item.category.name.downcase.include? term_of_search.downcase
      description_searched = item.description.downcase.include? term_of_search.downcase
      if name_searched == true || category_searched == true || description_searched == true
        items_searched << item
      end
    end

    if items_searched.length != 0
      items_searched.each do |item|
        puts "[#{item.id}] - Nome: #{item.name} / Categoria: #{item.category.name} / Descrição: #{item.description} / Status: #{item.status}"
      end
      puts "\n\n"
    else
      puts "\n\nNenhum item encontrado com o termo de busca\n\n"
    end

  end
end

StudyDiary.new.menu()