require 'set'

instructions = ARGF.readlines.map(&:strip)

class CPU
  def initialize
    @signal_strength = 0
    @cycle = 0
    @register = 1
  end


  def execute(instructions, action)
    instructions.each do |instr|
      instr, n = instr.split
      
      if instr == 'noop'
        @cycle += 1
        action.call(@cycle, @register)
        next
      end

      if instr == "addx"
        @cycle += 1
        action.call(@cycle, @register)

        @cycle += 1
        action.call(@cycle, @register)

        @register += n.to_i
      end
    end
  end
end
  

# part 1
cpu = CPU.new
signal_strength = 0
action = ->(cycle, register) { signal_strength += cycle*register if (cycle-20)%40 == 0 }
cpu.execute(instructions, action)
puts signal_strength

# part 2
cpu = CPU.new
crt_width, crt_height = 40, 6
crt = Array.new(crt_width * crt_height) { '.' }
action = ->(cycle, register) { crt[cycle-1] = '#' if [register-1, register, register+1].include? (cycle-1)%crt_width }
cpu.execute(instructions, action)
crt.each_slice(40) do |row|
  puts row.join
end
