#Declaration of the Ship class.
class Ship
#Initialization of the ship(@param 'name,size' represent name of the ship and its size respectively).
  def initialize(name,size)
    @title = name #@title states for the name of the ship.
    @size = size  #@size states for the size of the ship.
    @coordinates = Array.new(size*2,0)  #@coordinates states for the coordinates of the ship.
  end
  def get_name #Get name of the ship.
    @title
  end
  def get_size  #Get size of the ship.
    @size
  end
  def get_cor #Get coordinates of the ship in the form 'coordinates[even||0]=x,coordinates[odd]=y'.
    @coordinates
  end

  def set_name(name) #Set name of the ship.
    @title = name
  end
  def set_size(size)  #Set size of the ship.
    @size = size
  end
  def set_cor_x(coord,i)  #Set x coordinate of the ship(@param 'coord,i' represent x coordinate and index of it in an array @coordinates respectively).
    @coordinates[i*2] = coord
  end
  def set_cor_y(coord,i)  #Set y coordinate of the ship(same as above, but for y coordinate).
    @coordinates[i*2+1] = coord
  end

  def fully_sunk(ship,battle) #Check if the ship sunk fully(@param 'ship,battle' represent particular ship and field with all ships on respectively)
    counter = 0 #Controls the amount of sunk cells
    for i in 0...@size
      if battle[@coordinates[i*2]][@coordinates[i*2+1]] == 3  #If cell is hit, the counter icreases by 1
        counter += 1
      else
        counter = 0
        i = @size
      end
    end
    if counter == @size #if counter equals to the size of the ship, then ship is sunk
      puts "You defeat enemy's #{get_name} x 1".colorize(:yellow)
      ship = nil
    end
  end
end