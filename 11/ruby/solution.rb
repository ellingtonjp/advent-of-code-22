class Monkey
  attr_reader :items, :operation, :test, :relief, :num_inspected
  
  def initialize(items, operation, test, relief)
    @items = items
    @operation = operation
    @test = test
    @relief = relief
    @num_inspected = 0
  end
  
  def inspect_next_item
    return nil if items.empty?
    @num_inspected += 1
    item = operation.call(items[0])
    item = relief.call(item)
    items[0] = item
  end
  
  def throw_next_item(monkeys)
    item = items.shift
    throw_to = test.call(item)
    monkeys[throw_to].items.append(item)
  end
end

def input_to_monkeys(input)
  divisor = input.scan(/divisible by (\d+)/).flatten.map(&:to_i).reduce(&:*)
  input.split("\n\n").map do |monkey|
    line = monkey.lines.map(&:strip).to_enum
    
    # skip header
    line.next
    
    # item values
    items = line.next.split(': ')[1].split(', ').map(&:to_i)
    
    # operation -- eval because it's fun! relies on input using the word 'old'
    op = line.next.split('=')[1].strip
    operation = ->(old) { eval(op) }
    
    # test
    test_line = line.next
    divisible_by = test_line.match(/(\d+)/)[1].to_i
    true_monkey = line.next.match(/(\d+)/)[1].to_i
    false_monkey = line.next.match(/(\d+)/)[1].to_i
    test = ->(item) { item % divisible_by == 0 ? true_monkey : false_monkey }
    
    # part 1
    # relief = ->(item) { item / 3 }

    # part 2
    relief = ->(item) { item % divisor }
    
    Monkey.new items, operation, test, relief
  end
end

# find the monkey business
monkeys = input_to_monkeys(ARGF.read.strip)
rounds = 10000
rounds.times do
  monkeys.each do |monkey|
    while monkey.inspect_next_item
      monkey.throw_next_item(monkeys)
    end
  end
end
puts monkeys.map(&:num_inspected).max(2).reduce(&:*)