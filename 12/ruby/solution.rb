require 'set'
require_relative 'graph'

map = ARGF.readlines.map(&:strip).map(&:chars)

def nodes_with_height(map, height)
  coordinates = []
  map.each_with_index do |row, i|
    row.each_with_index do |h, j|
      coordinates.append [i, j] if height == h
    end
  end
  coordinates
end

def shortest_path(graph, src, dst)
  visited = Set.new
  in_q = Set.new
  q = [src.label]
  paths = {}

  until q.empty?
    curr = q.shift
    visited.add curr
    in_q.delete curr
    curr_node = graph.find_by_label(curr)

    curr_node.neighbors.each do |n|
      next if visited.include? n.label
      next if in_q.include? n.label

      paths[n.label] = curr

      if n == dst
        len = 0
        node = paths[n.label]
        while node
          node = paths[node]
          len += 1
        end

        return len
      end

      q.append n.label
      in_q.add n.label
    end
  end

  nil
end

graph = Graph.new
map.each_with_index do |row, i|
  row.each_with_index do |height, j|
    height = map[i][j]
    height = 'a' if height == 'S'
    height = 'z' if height == 'E'

    graph.add_node(height, i, j)
  end
end

# part 1
i, j = nodes_with_height(map, 'S').first
x, y = nodes_with_height(map, 'E').first
start = graph.find_by_coordinates(i, j)
endd = graph.find_by_coordinates(x, y)
puts shortest_path(graph, start, endd)

# part 2
lengths = []
coords = nodes_with_height(map, 'a')
coords.each do |coord|
  start = graph.find_by_coordinates(coord[0], coord[1])
  lengths.append shortest_path(graph, start, endd)
end
puts lengths.compact.min
