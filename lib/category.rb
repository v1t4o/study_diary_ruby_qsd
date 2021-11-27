class Category
  attr_reader :name, :id

  @@next_index = 1

  def initialize(name:)
    @id = @@next_index
    @name = name
    @@next_index += 1
  end

  CATEGORIES = [
    new(name: 'Ruby'),
    new(name: 'Rails'),
    new(name: 'PHP'),
    new(name: 'Laravel'),
    new(name: 'HTML'),
    new(name: 'CSS'),
    new(name: 'Git'),
  ]

  def to_s
    "##{id} - #{name}"
  end

  def self.all
    CATEGORIES
  end

  def self.index(number)
    CATEGORIES[number]
  end

end