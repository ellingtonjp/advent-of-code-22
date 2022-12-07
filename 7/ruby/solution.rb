input = ARGF.readlines.map(&:strip)

FSFile = Struct.new('File', :name, :size)

class Directory
  attr_accessor :name, :parent, :files, :directories

  def initialize(name: '', parent: nil, files: [], directories: [])
    @name = name
    @parent = parent
    @files = files
    @parent = parent
    @directories = directories
  end

  def size
    files.map(&:size).sum + directories.map(&:size).sum
  end

  def to_s(level: 0)
    str = ''
    whitespace = ' ' * level
    str += "#{whitespace}- #{name} (dir)\n"
    directories.each do |dir|
      str += dir.to_s(level: level + 2)
    end
    files.each do |file|
      str += "#{whitespace}  - #{file.name} (file, size=#{file.size})\n"
    end
    str
  end
end

def build_filesystem(input)
  root = Directory.new name: '/', files: [], directories: []
  curr_dir = root
  input[1..].each do |line|
    case line
    when /dir (.*)/
      dir = Directory.new name: Regexp.last_match(1), files: [], directories: [], parent: curr_dir
      curr_dir.directories.append dir
    when /^(\d+) (.*)$/
      file = FSFile.new Regexp.last_match(2), Regexp.last_match(1).to_i
      curr_dir.files.append file
    when /^\$ cd (.*)$/
      curr_dir = if Regexp.last_match(1) == '..'
                   curr_dir.parent
                 else
                   curr_dir.directories.find { |dir| dir.name == Regexp.last_match(1) }
                 end
    end
  end

  root
end

# part 1
root = build_filesystem(input)
def find_small_dirs(dir, small_dirs)
  small_dirs.append(dir) if dir.size < 100_000
  return if dir.directories.empty?

  dir.directories.each do |subdir|
    find_small_dirs(subdir, small_dirs)
  end
end

small_dirs = []
find_small_dirs(root, small_dirs)
puts "part 1: #{small_dirs.map(&:size).sum}"

# part 2
fs_size = 70_000_000
update_size = 30_000_000
used_space = root.size
unused_space = fs_size - used_space
needed_space = update_size - unused_space

def find_big_enough_to_delete(dir, big_enough_dirs, needed_space)
  big_enough_dirs.append(dir) if dir.size >= needed_space

  return if dir.directories.empty?

  dir.directories.each do |subdir|
    find_big_enough_to_delete(subdir, big_enough_dirs, needed_space)
  end
end

big_enough_dirs = []
find_big_enough_to_delete(root, big_enough_dirs, needed_space)
puts "part 2: #{big_enough_dirs.map(&:size).min}"
