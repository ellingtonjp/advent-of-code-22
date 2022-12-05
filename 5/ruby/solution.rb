input = ARGF.readlines.map(&:strip)

# parse input
stack_lines = input.grep(/\[/)
height = stack_lines.size
n_stacks = input.grep(/^\d/).first.match(/(\d+)$/)[1].to_i
instructions = input.grep(/move/).map { |instr| instr.match(/(\d+).+(\d+).+(\d+)/)[1..3].map(&:to_i) }

def create_stacks(stack_lines, n_stacks)
  stacks = []
  n_stacks.times do |crate_n|
    col = (crate_n) * 4 + 1
    stack_lines.size.times do |row|
      stacks[crate_n] ||= []
      stacks[crate_n].append(stack_lines[row][col]) if stack_lines[row][col] && !stack_lines[row][col].strip.empty?
    end
  end
  stacks
end

def move_crates_1(stacks, instruction)
  from_els = stacks[instruction[:from]-1].shift(instruction[:n])
  stacks[instruction[:to]-1].unshift *(from_els.reverse)
end

def move_crates_2(stacks, instruction)
  from_els = stacks[instruction[:from]-1].shift(instruction[:n])
  stacks[instruction[:to]-1].unshift *(from_els)
end

# part 1
stacks = create_stacks(stack_lines, n_stacks)
instructions.each do |instr|
  instr = instr.map(&:to_i)
  instr = { n: instr[0], from: instr[1], to: instr[2] }
  move_crates_1(stacks, instr)
end
puts stacks.map { |s| s.first}.join

# part 2 
stacks = create_stacks(stack_lines, n_stacks)
instructions.each do |instr|
  instr = instr.map(&:to_i)
  instr = { n: instr[0], from: instr[1], to: instr[2] }
  move_crates_2(stacks, instr)
end
puts stacks.map { |s| s.first}.join
