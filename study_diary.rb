require 'io/console'
require './lib/study_item'

INSERT = 1
DELETE = 2
MARK_AS_CONCLUDED = 3
VIEW_ALL = 4
SEARCH = 5
EXIT = 6

#def load_file
#  items_charged = []
#  IO.readlines('diary.txt').each_with_index.map do |line|
#    items_charged << (line.split(',').to_a)
#  end
#  for x in 0 .. items_charged.length - 1
#    @@study_items << StudyItem.new(id: items_charged[x][0].gsub(/[\[\]\\]/, '').to_i, name: items_charged[x][1].gsub(/[\[\]\\]/, '').to_s, category: Category.new(name: items_charged[x][2].gsub(/[\[\]\\]/, '').to_s), description: items_charged[x][3].gsub(/[\[\]\\]/, '').to_s, concluded: items_charged[x][4].gsub(/[\[\]\\]/, '').to_b) 
#  end
#end

#def save_file
#  File.open("diary.txt", "w") do |f|
#    items.each do |item|
#      f.write("[#{item.id},#{item.name},#{item.category.name},#{item.description},#{item.status}],\n")   
#    end
#  end
#end

def menu
  menu_options = <<~MENU
  Seja bem-vindo ao seu Diário de Estudos!\n
  ----------------------------------
                Menu
  ----------------------------------
  [1] Cadastrar um item para estudar
  [2] Deletar um item de estudo
  [3] Marcar item como concluído
  [4] Ver todos os itens cadastrados
  [5] Buscar um item de estudo
  [6] Sair
  ----------------------------------\n
  MENU
  puts menu_options
  puts 'Escolha uma opção: '
  gets.to_i
end

def print_elements(collection)
  puts collection
  puts 'Nenhum item encontrado' if collection.empty?
end

def clear
  system 'clear'
end

def wait_keypress_and_clear
  puts "\nPressione qualquer tecla para continuar"
  STDIN.getch
  clear
end

def search_study_items
  print 'Digite uma palavra ou parte dela para procurar: '
  term = gets.chomp
  StudyItem.search(term)
end

def search_study_items_by_category
  print 'Digite o nome da categoria que deseja filtrar: '
  term = gets.chomp
  StudyItem.search_by_category(term)
end

def mark_study_item_as_concluded
  not_concluded = StudyItem.not_concluded
  print_elements(not_concluded)
  return if not_concluded.empty?

  print 'Digite o código do item que deseja concluir: '
  #not_concluded[gets.to_i - 1].concluded!
  StudyItem.to_concluded(gets.to_i)
end

def delete_study_item
  print_elements(StudyItem.all)
  print 'Digite o código do item a ser deletado: '
  #items.delete_at(gets.to_i - 1)
  StudyItem.destroy(gets.to_i)
end

clear
#load_file

loop do
  option_selected = menu
  case option_selected
  when INSERT
    StudyItem.create
  when DELETE
    delete_study_item
  when MARK_AS_CONCLUDED
    mark_study_item_as_concluded
  when VIEW_ALL
    print 'Deseja filtrar items por categoria? (S/N): '
    result = gets.chomp
    result == 's' ? print_elements(search_study_items_by_category) : print_elements(StudyItem.all)
  when SEARCH
    print_elements(search_study_items)
  when EXIT
    #save_file
    puts "\n\nObrigado por usar o Diário de Estudos"
    break
  else
    puts "\n\nOpção não encontrada. Tente novamente.\n\n"
  end
  wait_keypress_and_clear
end