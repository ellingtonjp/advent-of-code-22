require 'rspec'
require_relative './graph'

RSpec.describe Graph do
  describe '.can_travel' do
    it 'can travel same height' do
      n1 = Node.new 'a', [], []
      n2 = Node.new 'a', [], []
      expect(described_class.can_travel(n1, n2)).to eq(true)
    end

    it 'can travel one level up' do
      n1 = Node.new 'a', [], []
      n2 = Node.new 'b', [], []
      expect(described_class.can_travel(n1, n2)).to eq(true)
    end

    it 'can not travel two levels up' do
      n1 = Node.new 'a', [], []
      n2 = Node.new 'c', [], []
      expect(described_class.can_travel(n1, n2)).to eq(false)
    end

    it 'can travel any levels down' do
      n1 = Node.new 'x', [], []
      n2 = Node.new 'e', [], []
      expect(described_class.can_travel(n1, n2)).to eq(true)
    end
  end

  describe '.initialize' do
    it 'returns a new graph' do
      expect(described_class.new).to be_kind_of(described_class)
    end

    it 'returns an empty graph' do
      expect(described_class.new.nodes).to be_empty
    end
  end

  describe '#find_node' do
    let(:g) { described_class.new }

    it 'correctly finds nodes' do
      node1 = g.add_node('c', 0, 1)
      node2 = g.add_node('d', 1, 0)
      node3 = g.add_node('d', 1, 1)
      expect(g.find_by_coordinates(0, 1)).to eq(node1)
      expect(g.find_by_coordinates(1, 0)).to eq(node2)
      expect(g.find_by_coordinates(1, 1)).to eq(node3)
    end

    it 'returns nil if cannot find node' do
      expect(g.find_by_coordinates(0, 0)).to be_nil
    end
  end

  describe '#add_node' do
    let(:g) { described_class.new }

    it 'it adds new node' do
      expect { g.add_node 'b', 1, 2 }.to change(g.nodes, :length).by(1)
    end

    it 'it adds correct neighbors' do
      n1 = g.add_node 'b', 0, 0
      expect(n1.neighbors).to be_empty

      n2 = g.add_node 'b', 1, 1
      expect(n2.neighbors).to be_empty

      n3 = g.add_node 'b', 1, 0
      expect(n3.neighbors).to include(n1)
      expect(n3.neighbors).to include(n2)
    end

    it "does not add neighbors that can't be climbed to" do
      n1 = g.add_node 'a', 0, 0
      expect(n1.neighbors).to be_empty

      n2 = g.add_node 'c', 0, 1
      expect(n2.neighbors).to eq([n1])
      expect(n1.neighbors).to be_empty
    end

    it 'raises error if node already exists' do
      g.add_node 'a', 0, 0
      expect { g.add_node 'a', 0, 0 }.to raise_error('node already exists')
    end
  end

  describe '#find_by_label' do
    let(:g) { described_class.new }

    it 'finds the correct node' do
      g.add_node 'a', 0, 0
      n2 = g.add_node 'a', 0, 1

      expect(g.find_by_label('ai0j1')).to eq(n2)
    end
  end
end

RSpec.describe Node do
  it 'has the correct label' do
    n = Node.new 'p', [1, 2], []
    expect(n.label).to eq('pi1j2')
  end
end
