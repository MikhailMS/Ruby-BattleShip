require 'rubygems'
require 'bundler/setup'

require 'text-table'
require 'colorize'
load 'Ship.rb'
=begin  Declaration of three arrays and control variable:
'battle_field' contains ships
'battle_ships' contains size of each ship
'coordinates' contains initial coordinates where it's possible to place a ship
'@i' states to distinguish @destroyer1 and @destroyer2 when passing the coordinates to them
=end
battle_field = Array.new(10) {Array.new((10), 0)}
battle_ships = [5,4,3,3,2]
coordinates = Array.new(2)
@i = 0

#Declaration of ships
@aircraft = Ship.new('aircraft',5)
@cruiser = Ship.new('cruiser',4)
@destroyer1 = Ship.new('destroyer 1',3)
@destroyer2 = Ship.new('destroyer 2',3)
@submarine = Ship.new('submarine',2)

=begin
Below there are three functions:
'check_pos' returns coordinates 'x' and 'y' where computer can place a ship (@param 'dir,battle,cellNum' represent direction of a ship(vertical or horizontal), grid with ships on it and a size of a ship respectively)
'shipLocationHorizontal' places ships horizontally  (@param 'battle, x_and_y, cellNum' represent grid with ships on, coordinates where ship can be placed and a size of ship respectively)
'shipLocationVertical' places ships vertically  (@param 'battle, x_and_y, cellNum' represent grid with ships on, coordinates where ship can be placed and a size of ship respectively)
=end
def check_pos(dir,battle,cellNum)
  case dir
    when 0  #Horizontal placement
      counter = 0 #Controls the full ship's placement
      pass_cor = true #Controls escape from WHILE loop
      x = rand(1..8)  #Random pick of x coordinate
      y = rand(1..9-cellNum)  #Random pick of y coordinate
      while pass_cor
        #Check if the cell is free to use, if it's not - pick another random cell
        if (battle[x][y] == 1 || battle[x-1][y] == 1 || battle[x-1][y+1] == 1 || battle[x][y+1] == 1|| battle[x+1][y+1] == 1 || battle[x+1][y] == 1 ||battle[x+1][y-1] == 1 ||battle[x][y-1] == 1 || battle[x-1][y-1] == 1)
          x = rand(1..8)
          y = rand(1..9-cellNum)
        else
          #Check if it's possible to place ship fully in right of left direction, if not - new random coordinates to be picked
          i = 1
          for i in 1..cellNum
            if (!(battle[x-1][y+i] == 1 || battle[x][y+i] == 1 || battle[x+1][y+i] == 1))
              counter += 1
            else
              x = rand(1..8)
              y = rand(1..9-cellNum)
              i = cellNum
              counter = 0
            end
          end
        end
        if (counter == cellNum)
          pass_cor = false
        end
      end
      return x,y
    when 1  #Vertical placement
      counter = 0
      pass_cor = true
      x = rand(1..9-cellNum)
      y = rand(1..8)
      while pass_cor
        #Check if the cell is free to use, if it's not - pick another random cell
        if (battle[x][y] == 1 || battle[x-1][y] == 1 || battle[x-1][y+1] == 1 || battle[x][y+1] == 1|| battle[x+1][y+1] == 1 || battle[x+1][y] == 1 ||battle[x+1][y-1] == 1 ||battle[x][y-1] == 1 || battle[x-1][y-1] == 1)
          x = rand(1..9-cellNum)
          y = rand(1..8)
        else
          #Check if it's possible to place ship fully, if not - new random coordinates to be picked
          i = 1
          for i in 1..cellNum
            if (battle[x+i][y-1] == 1 || battle[x+i][y] == 1 || battle[x+i][y+1] == 1)
              x = rand(1..9-cellNum)
              y = rand(1..8)
              i = cellNum
              counter = 0
            else
              counter += 1
            end
          end
        end
        if counter == cellNum
          pass_cor = false
        end
      end
      return x,y
  end
end
def shipLocationHorizontal(battle,x_and_y,cellNum)
  for i in 0...cellNum
    battle[x_and_y[0]][x_and_y[1]] = 1
    x_and_y[1] += 1
  end
  return battle
end
def shipLocationVertical(battle,x_and_y,cellNum)
  for i in 0...cellNum
    battle[x_and_y[0]][x_and_y[1]] = 1
    x_and_y[0] += 1
  end
  return battle
end

def take_ship(cellNum)  #Return ship depending on size of it(@param 'cellNum' represents size of the ship) to the programm
  case cellNum
    when 5
      return @aircraft
    when 4
      return @cruiser
    when 3
      if @i == 1
        return @destroyer1
      elsif @i == 2
        return @destroyer2
      end
    when 2
      return @submarine
  end
end
=begin
Method below sets coordinates for particular ship:
@param 'ship' represents ship of a Ship class
@param 'dir' represents direction of a ship
@param 'coor' represents chosen coordinates for a ship
@param 'cellNum' represents the size of a ship
=end
def set_ship(ship,dir,coor,cellNum)
  x = coor[0]
  y = coor[1]
  if dir == 0
    for i in 0...cellNum
      ship.set_cor_x(x,i)
      ship.set_cor_y(y,i)
      y += 1
    end
  elsif dir == 1
    for i in 0...cellNum
      ship.set_cor_x(x,i)
      ship.set_cor_y(y,i)
      x += 1
    end
  end
  return ship
end

#Random ships allocation and passing coordinates of a ship to its class
battle_ships.each do |cell|
  if rand(2) == 0
    coordinates = check_pos(0,battle_field,cell)
    case cell
      when 5
        @aircraft = set_ship(take_ship(cell),0,coordinates,cell)
      when 4
        @cruiser = set_ship(take_ship(cell),0,coordinates,cell)
      when 3
        @i += 1
        if @i == 1
          @destroyer1 = set_ship(take_ship(cell),0,coordinates,cell)
        elsif @i == 2
          @destroyer2 = set_ship(take_ship(cell),0,coordinates,cell)
        end
      when 2
        @submarine = set_ship(take_ship(cell),0,coordinates,cell)
    end
    battle_field = shipLocationHorizontal(battle_field,coordinates,cell)
  else
    coordinates = check_pos(1,battle_field,cell)
    case cell
      when 5
        @aircraft = set_ship(take_ship(cell),1,coordinates,cell)
      when 4
        @cruiser = set_ship(take_ship(cell),1,coordinates,cell)
      when 3
        @i += 1
        if @i == 1
          @destroyer1 = set_ship(take_ship(cell),1,coordinates,cell)
        elsif @i == 2
          @destroyer2 = set_ship(take_ship(cell),1,coordinates,cell)
        end
      when 2
        @submarine = set_ship(take_ship(cell),1,coordinates,cell)
    end
    battle_field = shipLocationVertical(battle_field,coordinates,cell)
  end
end

# User interface. While loop untill all ships are defeated. Calculates player's points(playerPoints) and after each turn displayes player's field - battle_field_player
winState = true   #Control escape from WHILE loop
counterCell = 0   #Control that all enemie's ships are sunk
playerPoints = 0  #Counter of player's points
battle_field_player = Array.new(10) {Array.new((10), '0'.colorize(:white))} #Player's field

print "Welcome to Battle Ship game!\n".colorize(:blue)
print "Simple instructions to follow - there are 5 ships, 1 of size 5, 1 of size 4, 2 of size 3 and 1 of size 2. Possible coordinates are in the range 1 to 10\n".colorize(:red)
print "You will win, only when you defeat all enemy's ships. Good luck!\n".colorize(:red)

puts 'y|'+'1| '+'|2|'+' |3|'+' |4|'+' |5|'+' |6|'+' |7|'+' |8|'+' |9|'+' |10|'
puts battle_field_player.to_table
while winState
  puts "Enter x coordinate: "
  xPlayer = gets.chomp.to_i-1
  puts "Enter y coordinate: "
  yPlayer = gets.chomp.to_i-1
  if (xPlayer<0||xPlayer>10||yPlayer<0||yPlayer>10)
    puts "You typed incorrect coordinates.Correct coordinates should be in range [1,10]"
  else
    if (battle_field[xPlayer][yPlayer] == 1)
      puts "You hit ship! You have another shot"
      counterCell += 1
      playerPoints += 1
      battle_field[xPlayer][yPlayer] = 3
      battle_field_player[xPlayer][yPlayer] = '3'.colorize(:red)
    elsif (battle_field[xPlayer][yPlayer] == 2 || battle_field[xPlayer][yPlayer] == 3)
      puts "Oops, you already hit this cell, so try again"
    else
      puts "You didnt hit ship, try again"
      battle_field[xPlayer][yPlayer] = 2
      battle_field_player[xPlayer][yPlayer] = '2'.colorize(:blue)
      playerPoints += 1
    end

  end
  puts 'y|'+'1| '+'|2|'+' |3|'+' |4|'+' |5|'+' |6|'+' |7|'+' |8|'+' |9|'+' |10|'
  puts battle_field_player.to_table
  @aircraft.fully_sunk(@aircraft,battle_field)
  @cruiser.fully_sunk(@cruiser,battle_field)
  @destroyer1.fully_sunk(@destroyer1,battle_field)
  @destroyer2.fully_sunk(@destroyer2,battle_field)
  @submarine.fully_sunk(@submarine,battle_field)
  if counterCell == 17
    puts "You defeat your enemy!!"
    puts "You scored #{playerPoints} points!"
    winState = false
  end
end
