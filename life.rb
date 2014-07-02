require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width=640, height=480)
    @width=width
    @height=height
    super @width, @height, false
    self.caption = "Life Game by Conway"
    @world = World.new(@width, @height)

    #Colours of magic
    @background = Gosu::Color.new(0xffdedede)
    @alive = Gosu::Color.new(0xffff0000)
    @dead = Gosu::Color.new(0xff808080)
  end

  def update
  end

  def draw
    draw_quad(0,0,@background,
              @width,0,@background,
              @width,@height,@background,
              0,@height,@background)

    @world.cells.each do |rows|
      rows.each do |cell|
        if cell.alive then
          draw_cell(cell.x, cell.y, @alive)
        else
          draw_cell(cell.x, cell.y, @dead )
        end
      end
    end
  end

  def draw_cell(x,y,color)
    x*=10
    y*=10
    draw_quad(x+1,y+1,color,
              x+9,y+1,color,
              x+9,y+9,color,
              x+1,y+9,color)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
    if id == Gosu::KbSpace then
      start_game
    end
    if id == Gosu::MsLeft then
      x = mouse_x/10.to_i
      y = mouse_y/10.to_i
      puts x,y
      @world.cells[x][y].reverse
    end
  end

  def needs_cursor?
    true
  end
end

class World

  attr_accessor :cells

  def initialize(width, height)
    @rows = height/10
    @cols = width/10
    @cells = Array.new(@cols) do |col|
      Array.new(@rows) do |row|
        Cell.new(col,row)
      end
    end
  end
end

class Cell

  attr_accessor :x,:y,:alive

  def initialize(x,y)
    @x = x
    @y = y
    @alive=false
  end
  
  def reverse
    self.alive = !alive
  end
end

window = GameWindow.new
window.show
