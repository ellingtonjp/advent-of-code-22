input = ARGF.read

# part 1
puts input
       .split("\n\n")
       .map { |elves| elves .split("\n") .map(&:to_i) }
       .map { |elf| elf.sum }
       .max

# part 2
puts input
       .split("\n\n")
       .map { |elves| elves.split("\n").map(&:to_i) }
       .map { |elf| elf.sum }
       .sort
       .last(3)
       .sum
