require 'gosu'


Vector = Struct.new(:x, :y) do
  
  def to_draw_coordinates
    # invert y scala: (1,1) becomes (0,300); (2,1) becomes (100, 300); (2,2) becomes (100, 200); (1,2) becomes (0, 200)
    draw_y = 300 - ((y) * 100)
    draw_x = (x - 1) * 100
    
    [draw_x, draw_y]
  end
  
end


class Wall
  
  def initialize(vector, tile)
    @vector = vector
    @tile = tile
  end
  
  
  def update    
  end
  
  
  def draw
    x, y = @vector.to_draw_coordinates
    
    @tile.draw x, y, 0
  end
  
end


class Square
  
  def initialize(q_values, vector, tile)    
    @q_values = q_values
    @vector = vector
    @tile = tile    
  end
  
  
  def update    
    @value = @q_values[@vector]
  end
  
  
  def draw
    x, y = @vector.to_draw_coordinates
    
    @tile.draw x, y, 0
  end
  
end


class Goal
  
  def initialize(reward, vector, tile)    
    @reward = reward
    @vector = vector
    @tile = tile    
  end
  
  
  def update
  end
  
  
  def draw
    x, y = @vector.to_draw_coordinates
    
    @tile.draw x, y, 0
  end
  
end



class GameWindow < Gosu::Window
  
  def initialize
    super 500, 300
    self.caption = "Gosu Tutorial Game"
    
    @tiles = Gosu::Image.load_tiles 'tiles.png', 100, 100, tileable: true
    
    @q_values = Hash.new(0)
    
    @squares = [
      Square.new(@q_values, Vector.new(1,1), @tiles[0]),
      Square.new(@q_values, Vector.new(1,2), @tiles[0]),
      Square.new(@q_values, Vector.new(1,3), @tiles[0]),

      Square.new(@q_values, Vector.new(2,1), @tiles[0]),
      Wall.new(Vector.new(2,2), @tiles[1]),
      Square.new(@q_values, Vector.new(2,3), @tiles[0]),

      Square.new(@q_values, Vector.new(3,1), @tiles[0]),
      Wall.new(Vector.new(3,2), @tiles[1]),
      Square.new(@q_values, Vector.new(3,3), @tiles[0]),

      Square.new(@q_values, Vector.new(4,1), @tiles[0]),
      Square.new(@q_values, Vector.new(4,2), @tiles[0]),
      Square.new(@q_values, Vector.new(4,3), @tiles[0]),
      
      Square.new(@q_values, Vector.new(5,1), @tiles[0]),
      Goal.new(-100, Vector.new(5,2), @tiles[3]),
      Goal.new(100, Vector.new(5,3), @tiles[2])
    ]
    
  end

  def update
    @squares.each { |square| square.update }
  end

  def draw
    @squares.each { |square| square.draw }
  end
  
  def button_down(id)
    if [Gosu::KbQ, Gosu::KbEscape].include? id
      close
    end
  end
end

window = GameWindow.new
window.show