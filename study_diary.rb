require './lib/category'
require './lib/study_item'

class StudyDiary < StudyItem
  
  attr_accessor :items
  def initialize(items: [])
    @items = items
  end

  def menu
    load_file
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
        list_items_for_study
      when 5
        search_item_for_study
      when 6
        save_file
        puts "\n\nObrigado por usar o Diário de Estudos"
      else
        puts "\n\nOpção não encontrada. Tente novamente.\n\n"
      end
    end
  end

  private 

  def load_file
    items_charged = []
    IO.readlines('diary.txt').each_with_index.map do |line|
      items_charged << (line.split(',').to_a)
    end
    #puts items_charged[0][0].gsub(/[\[\]\\]/, '').to_i

    for x in 0 .. items_charged.length - 1
      items << StudyItem.new(id: items_charged[x][0].gsub(/[\[\]\\]/, '').to_i, name: items_charged[x][1].gsub(/[\[\]\\]/, '').to_s, category: Category.new(name: items_charged[x][2].gsub(/[\[\]\\]/, '').to_s), description: items_charged[x][3].gsub(/[\[\]\\]/, '').to_s, status: items_charged[x][4].gsub(/[\[\]\\]/, '').to_s) 
    end
    puts items

  end

  def save_file
    File.open("diary.txt", "w") do |f|
      items.each do |item|
        f.write("[#{item.id},#{item.name},#{item.category.name},#{item.description},#{item.status}],\n")   
      end
    end
  end
end

StudyDiary.new.menu()