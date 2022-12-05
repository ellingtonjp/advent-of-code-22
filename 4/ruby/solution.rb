require 'set'

input = ARGF.readlines.map(&:strip)

# part 1
puts input
  .map { |line| line.split(',') }
  .map { |r| [r[0].split('-').map(&:to_i), r[1].split('-').map(&:to_i)] }
  .map { |r| [(r[0][0]..r[0][1]).to_set, (r[1][0]..r[1][1]).to_set] }
  .filter { |s| s[0] <= s[1] || s[1] <= s[0] }
  .count

# part 2
puts input
  .map { |line| line.split(',') }
  .map { |r| [r[0].split('-').map(&:to_i), r[1].split('-').map(&:to_i)] }
  .map { |r| [(r[0][0]..r[0][1]).to_set, (r[1][0]..r[1][1]).to_set] }
  .filter { |s| s[0].intersect?(s[1]) }
  .count
