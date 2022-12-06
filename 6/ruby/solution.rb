input = ARGF.read.strip

# part 1
puts input
      .chars
      .each_cons(4)
      .with_index(4)
      .find { |el| (el[0].uniq == el[0]) }
      .last

# part 2
puts input
      .chars
      .each_cons(14)
      .with_index(14)
      .find { |el| (el[0].uniq == el[0]) }
      .last