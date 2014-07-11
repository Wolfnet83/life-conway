require 'gosu'
require 'timeout'

class GameWindow < Gosu::Window
  def initialize(width = 640, height = 480)
    @width = width
    @height = height
    super @width, @height, false
    self.caption = "Life Game by Conway"
    @world = World.new(@width, @height)

    #Colours of magic
    @background = Gosu::Color.new(0xffdedede)
    @alive = Gosu::Color.new(0xff000000)
    @dead = Gosu::Color.new(0xff808080)
  end

  def update
  end

  def draw
    # Draw the background
    draw_quad(0,0,@background,
              @width,0,@background,
              @width,@height,@background,
              0,@height,@background)

    #Draw the full world table
    @world.cells.each do |rows|
      rows.each do |cell|
        if cell.alive? then
          draw_cell(cell.x, cell.y, @alive)
        else
          draw_cell(cell.x, cell.y, @dead )
        end
      end
    end
  end

  def draw_cell(x,y,color)
    x *= 10
    y *= 10
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
      @world.next_state
    end
    if id == Gosu::MsLeft then
      x = mouse_x/10.to_i
      y = mouse_y/10.to_i
      @world.cells[y][x].reverse!
    end
    if id == Gosu::MsRight then
      x = mouse_x/10.to_i
      y = mouse_y/10.to_i
      puts @world.count_neighbours(y, x)
    end
  end

  def needs_cursor?
    true
  end
end

class World
  attr_accessor :cells, :next_cells
  def initialize(width, height)
    @rows = height/10
    @cols = width/10
    @generation=0
    # Array of current cells
    @cells = Array.new(@rows) do |row|
      Array.new(@cols) do |col|
        Cell.new(row,col)
      end
    end
    #Array of next generation cells
    @next_cells = Array.new(@rows) do |row|
      Array.new(@cols) do |col|
        Cell.new(row,col)
      end
    end
  end

  def next_state
    @next_cells = Array.new(@rows) do |row|
      Array.new(@cols) do |col|
        Cell.new(row,col)
      end
    end
    #Count next generation view
    @cells.each do |rows|
      rows.each do |cell|
        @next_cells[cell.y][cell.x].alive = cell.alive?
        neighbours = count_neighbours(cell.y, cell.x)
        if  neighbours == 3 then
          @next_cells[cell.y][cell.x].revive!
        end
        if (neighbours != 2 && neighbours != 3) && cell.alive? then 
          @next_cells[cell.y][cell.x].die!
        end
      end
    end
    #Change generation
    @cells.each do |rows|
      rows.each do |cell|
        cell.alive = @next_cells[cell.y][cell.x].alive?
      end
    end
    @generation+=1
    puts "Generation", @generation
  end

  def print_cells
    puts "("*80
    @cells.each do |rows|
      rows.each do |cell|
        print cell.y,',',cell.x,',',cell.alive,'  '
      end
      puts
    end
    puts "*"*80
    @next_cells.each do |rows|
      rows.each do |cell|
        print cell.y,',',cell.x,',',cell.alive,'  '
      end
      puts
    end
  end
  
  def count_neighbours(y, x)
    neighbours = 0
    if x < @cols-1 then
      neighbours +=1 if @cells[y-1][x-1].alive? 
      neighbours +=1 if @cells[y-1][x].alive? 
      neighbours +=1 if @cells[y-1][x+1].alive? 
      neighbours +=1 if @cells[y][x-1].alive? 
      neighbours +=1 if @cells[y][x+1].alive? 
      if y < @rows-1 then
        neighbours +=1 if @cells[y+1][x-1].alive? 
        neighbours +=1 if @cells[y+1][x].alive? 
        neighbours +=1 if @cells[y+1][x+1].alive?
      else
        neighbours +=1 if @cells[0][x-1].alive? 
        neighbours +=1 if @cells[0][x].alive? 
        neighbours +=1 if @cells[0][x+1].alive?
      end
    else
      neighbours +=1 if @cells[y-1][x-1].alive? 
      neighbours +=1 if @cells[y-1][x].alive? 
      neighbours +=1 if @cells[y-1][0].alive? 
      neighbours +=1 if @cells[y][x-1].alive? 
      neighbours +=1 if @cells[y][0].alive? 
      if y < @rows-1 then
        neighbours +=1 if @cells[y+1][x-1].alive? 
        neighbours +=1 if @cells[y+1][x].alive? 
        neighbours +=1 if @cells[y+1][0].alive?
      else
        neighbours +=1 if @cells[0][x-1].alive? 
        neighbours +=1 if @cells[0][x].alive? 
        neighbours +=1 if @cells[0][0].alive?
      end
    end
    neighbours
  end
end

class Cell
  attr_accessor :x,:y,:alive
  def initialize(y,x)
    @x = x
    @y = y
    #@alive=false
    @alive=[true,false].sample
  end
  
  def reverse!
    self.alive = !alive
  end

  def revive!
    self.alive = true
  end

  def die!
    self.alive = false
  end

  def alive?
    alive
  end

end

window = GameWindow.new
window.show
