input = ARGF.readlines.map(&:strip)

# part 1
puts input
       .map(&:chars)
       .map { |bag| (bag[0...bag.length/2] & bag[bag.length/2...bag.length]).first }
       .map { |letter| ('a'..'z').include?(letter) ? letter.ord - 'a'.ord + 1 : letter.ord - 'A'.ord + 26 + 1 }
       .sum

# part 2
puts input
       .map(&:chars)
       .each_slice(3)
       .map { |tuple| (tuple[0] & tuple[1] & tuple[2]).first }
       .map { |letter| ('a'..'z').include?(letter) ? letter.ord - 'a'.ord + 1 : letter.ord - 'A'.ord + 26 + 1 }
       .sum
