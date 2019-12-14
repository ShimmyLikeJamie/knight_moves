require 'pry'

class Tile
  attr_accessor :all_paths
  attr_reader :coords
  def initialize x=0, y=0
    @coords = [x, y]
    @all_paths = []
  end
end
class Board
  attr_reader :height, :width, :tiles

  def initialize width=8, height=8
    puts "Creating board..." 
    @tiles = create_tiles(width, height)
    @width = width
    @height = height
    puts "Board created."
  end

  def knight_moves knight_coords, goal_coords
    puts "Knight co-ordinates: #{knight_coords} Goal co-ordinates: #{goal_coords}"
    knight_tile = self.place_knight(knight_coords)
    print "Finding shortest path... "
    result = find_path(knight_tile, goal_coords)
    puts "done"
    print "Your path is: #{result}"
  end

  def place_knight knight_coords
    i = 0
    print "Finding tile that knight resides on..."
    until @tiles[i].coords == knight_coords
      i += 1
    end
    puts " done"
    knight_tile = @tiles[i]
    knight_tile
  end
end

def find_path knight_tile, goal_coords, path = [], goal_found = false
  path << knight_tile.coords
  if knight_tile.coords == goal_coords
    return path
  else
    counter = 0
    searcher = Proc.new do |tile, counter|
      tile.all_paths.each do |y|
        if counter > 0
          path << y.coords
          if searcher.call(y, counter - 1)
            return path
          else
            path.pop
          end
        else
          if match?(y, goal_coords)
            return path << y.coords
          end
        end
      end
      goal_found = false
    end
    until goal_found = searcher.call(knight_tile, counter)
      counter += 1
    end
    goal_found
  end
end

def match? tile, goal_coords
  if tile.coords == goal_coords
    return true
  else
    return false
  end
end

def create_tiles width=8, height=8
  tiles = []
  x = 0
  y = 0
  print "Creating tiles..."
  while x < height
    while y < width
      tile = Tile.new(x,y)
      tiles << tile
      y += 1
    end
    x += 1
    y = 0
  end
  puts " done"
  connect_tile_paths(tiles)
end
def connect_tile_paths tiles
  print "Creating paths..."
  tiles.each do |position_tile|
    tiles.each do |tile|
      if possible_move?(position_tile, tile)
        position_tile.all_paths << tile
      end
    end
  end
  puts " done"
  tiles
end
def possible_move? position_tile, tile
  tile.coords[0] == position_tile.coords[0] - 2 && tile.coords[1] == position_tile.coords[1] + 1 ||
  tile.coords[0] == position_tile.coords[0] - 1 && tile.coords[1] == position_tile.coords[1] + 2 ||
  tile.coords[0] == position_tile.coords[0] + 1 && tile.coords[1] == position_tile.coords[1] + 2 ||
  tile.coords[0] == position_tile.coords[0] + 2 && tile.coords[1] == position_tile.coords[1] + 1 ||
  tile.coords[0] == position_tile.coords[0] - 2 && tile.coords[1] == position_tile.coords[1] - 1 ||
  tile.coords[0] == position_tile.coords[0] - 1 && tile.coords[1] == position_tile.coords[1] - 2 ||
  tile.coords[0] == position_tile.coords[0] + 1 && tile.coords[1] == position_tile.coords[1] - 2 ||
  tile.coords[0] == position_tile.coords[0] + 2 && tile.coords[1] == position_tile.coords[1] - 1
end

board = Board.new()
puts "#{board.knight_moves([3,3],[6,6])}"