trees = ARGF.readlines.map(&:strip).map(&:chars)

n_rows = trees.length
n_cols = trees[0].length

sum = 0
(0...n_rows).each do |row|
  (0...n_cols).each do |col|
    tree = trees[row][col]

    top_visible = (0...row).all? { |r| trees[r][col] < tree }
    bottom_visible = (row+1...n_rows).all? { |r| trees[r][col] < tree } 
    left_visible = (0...col).all? { |c| trees[row][c] < tree } 
    right_visible = (col+1...n_cols).all? { |c| trees[row][c] < tree }
    
    sum += 1 if top_visible || bottom_visible || left_visible || right_visible
  end
end

puts "part 1: #{sum}"

scenic_score = 0
(0...n_rows).each do |row|
  (0...n_cols).each do |col|
    tree = trees[row][col]

    # go up
    n_above = 0
    r = row - 1
    while r >= 0 
      n_above += 1
      break if trees[r][col] >= tree
      r -= 1
    end
    
    # go down
    n_below = 0
    r = row + 1
    while r < n_rows 
      n_below += 1
      break if trees[r][col] >= tree
      r += 1
    end

    # go left
    n_left = 0
    c = col - 1
    while c >= 0 
      n_left += 1
      break if trees[row][c] >= tree
      c -= 1
    end

    # go right
    n_right = 0
    c = col + 1
    while c < n_cols 
      n_right += 1
      break if trees[row][c] >= tree 
      c += 1
    end
    
    scenic_score = [scenic_score, n_above * n_below * n_left * n_right].max
  end
end

puts "part 2: #{scenic_score}"