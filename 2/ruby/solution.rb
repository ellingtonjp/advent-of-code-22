input = ARGF.readlines.map(&:strip)

# part 1
puts input
      .each_with_object({ 
          'A X' => 3 + 1, 
          'A Y' => 6 + 2, 
          'A Z' => 0 + 3, 
          'B X' => 0 + 1, 
          'B Y' => 3 + 2, 
          'B Z' => 6 + 3, 
          'C X' => 6 + 1, 
          'C Y' => 0 + 2, 
          'C Z' => 3 + 3 
        })
       .map { |game, scores| scores[game] } 
       .reduce(0) { |n, score| n + score }
        

# part 2 
puts input
      .each_with_object([
        { 
          'X' => 0,
          'Y' => 3,
          'Z' => 6
        }, 
        {
          'A' => 1,
          'B' => 2,
          'C' => 3,
        },
        {
          'A X' => 'C', 
          'A Y' => 'A', 
          'A Z' => 'B', 
          'B X' => 'A', 
          'B Y' => 'B', 
          'B Z' => 'C', 
          'C X' => 'B', 
          'C Y' => 'C', 
          'C Z' => 'A'

        }
      ])
      .map { |game, scores| scores[0][game.split[1]] + scores[1][scores[2][game]] }
      .reduce(0) { |n, score| n + score }

