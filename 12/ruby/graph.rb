class Node
  attr_reader :height, :coords, :label, :neighbors

  def initialize(height, coords, neighbors)
    @label = "#{height}i#{coords[0]}j#{coords[1]}"
    @height = height
    @coords = coords
    @neighbors = neighbors
  end
end

class Graph
  attr_reader :nodes, :nodes_by_label, :nodes_by_coordinates

  def self.can_travel(from, to)
    (to.height.ord - from.height.ord) <= 1
  end

  def initialize
    @nodes = {}
    @nodes_by_label = {}
    @coords = Set.new
  end

  def find_by_coordinates(i, j)
    nodes["i#{i}j#{j}"]
  end

  def find_by_label(label)
    nodes_by_label[label]
  end

  def add_node(height, i, j)
    raise 'node already exists' if find_by_label("#{height}i#{i}j#{j}")

    node = Node.new height, [i, j], []
    surrounding_nodes(i, j).each do |neighbor|
      node.neighbors.append(neighbor) if Graph.can_travel(node, neighbor)
      neighbor.neighbors.append(node) if Graph.can_travel(neighbor, node)
    end
    nodes["i#{i}j#{j}"] = node
    nodes_by_label[node.label] = node

    node
  end

  private

  def surrounding_nodes(i, j)
    surrounding_coordinates = [
      [i + 1, j],
      [i - 1, j],
      [i, j + 1],
      [i, j - 1]
    ]
    surrounding_coordinates.map { |coord| find_by_coordinates(coord[0], coord[1]) }.compact
  end
end
