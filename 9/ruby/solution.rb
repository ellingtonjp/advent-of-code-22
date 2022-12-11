require 'set'

instructions = ARGF.readlines.map(&:strip)
Position = Struct.new('Position', :x, :y)

def follow(head, tail)
  if tail.y > head.y + 1 && tail.x < head.x - 1    # north west
    tail.y = head.y + 1
    tail.x = head.x - 1
  elsif tail.y > head.y + 1 && tail.x > head.x + 1 # north east
    tail.y = head.y + 1
    tail.x = head.x + 1
  elsif tail.y < head.y - 1 && tail.x > head.x + 1 # south east
    tail.y = head.y - 1
    tail.x = head.x + 1
  elsif tail.y < head.y - 1 && tail.x < head.x - 1 # south west
    tail.y = head.y - 1
    tail.x = head.x - 1
  elsif tail.y > head.y + 1 # north
    tail.y = head.y + 1
    tail.x = head.x
  elsif tail.y < head.y - 1 # south
    tail.y = head.y - 1
    tail.x = head.x
  elsif tail.x > head.x + 1 # east
    tail.x = head.x + 1
    tail.y = head.y
  elsif tail.x < head.x - 1 # west
    tail.x = head.x - 1
    tail.y = head.y
  end
end

def execute_instructions(instructions, num_knots:)
  knots = Array.new(num_knots) { Position.new 0, 0 }
  position_set = Set.new
  instructions.each do |instr|
    direction, number = instr.split
    number.to_i.times do
      case direction
      when 'R' then knots[0].x += 1
      when 'L' then knots[0].x -= 1
      when 'U' then knots[0].y += 1
      when 'D' then knots[0].y -= 1
      end

      knots.each_cons(2) { |head, tail| follow(head, tail) }
      position_set.add([knots.last.x, knots.last.y])
    end
  end
  
  position_set.size
end

puts "part 1: #{execute_instructions(instructions, num_knots: 2)}"
puts "part 2: #{execute_instructions(instructions, num_knots: 10)}"