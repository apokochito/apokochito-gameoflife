#Spec file

require 'rspec'
require_relative 'game_of_life.rb'
#require 'pry'

describe 'Game of life' do

#	binding.pry

	let!(:world) { World.new } 
	let!(:cell) { Cell.new(1,1) }
	let!(:game) { Game.new }

	context 'World' do
	subject { World.new }

		it 'should create a new world object' do
			subject.is_a?(World).should be true
		end
		it 'should respond to proper methods' do
			subject.should respond_to(:rows)
			subject.should respond_to(:cols)
			subject.should respond_to(:cell_grid)
			subject.should respond_to(:live_neighbours_around_cell)
			subject.should respond_to(:cells)
                        subject.should respond_to(:randomly_populate)
                        subject.should respond_to(:live_cells)
		end

		it 'should create proper cell grid on initialization' do
			subject.cell_grid.is_a?(Array).should be true
			subject.cell_grid.each do |row|
				row.is_a?(Array).should be true
				row.each do |col|
					col.is_a?(Cell).should be true
				end
			end
		end

		it 'Should add all cells to cells array' do
			subject.cells.count.should == 9
		end

		it 'Detect a neighbour to the North East' do
			subject.cell_grid[cell.y - 1][cell.x + 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the North West' do
			subject.cell_grid[cell.y - 1][cell.x - 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the North' do
			subject.cell_grid[cell.y - 1][cell.x].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the East' do
			subject.cell_grid[cell.y][cell.x + 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the South-East' do
			subject.cell_grid[cell.y + 1][cell.x + 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the South-West' do
			subject.cell_grid[cell.y + 1][cell.x - 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the South' do
			subject.cell_grid[cell.y + 1][cell.x].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
		it 'Detect a neighbour to the West' do
			subject.cell_grid[cell.y][cell.x - 1].alive = true
			subject.live_neighbours_around_cell(cell).count.should == 1
		end
                it 'Should randomly_populate the world' do 
                  subject.live_cells.count.should == 0
                  subject.randomly_populate
                  subject.live_cells.count.should_not == 0
                end
	end
	context 'Cell' do
	subject { Cell.new }

		it 'Should create a new cell object' do
			subject.is_a?(Cell).should be true
		end
		it 'Should respond to proper methods' do
			subject.should respond_to(:alive)
			subject.should respond_to(:x)
			subject.should respond_to(:y)
			subject.should respond_to(:alive?)
			subject.should respond_to(:die!)
		end
		it 'Should initialize propierty' do
			subject.alive.should be false
			subject.x.should == 0
			subject.y.should == 0
		end
	end

	context 'Game' do
	subject {Game.new}

		it 'Should create a new game object' do
		subject.is_a?(Game).should be true
		end
		it 'Should respond to proper methods' do
		subject.should respond_to(:world)
		subject.should respond_to(:seeds)
		end
		it 'Should initialize properly' do
			subject.world.is_a?(World).should be true
			subject.seeds.is_a?(Array).should be true
		end
		it 'Should plant seeds properly' do
			game = Game.new(world,[[1,2],[0,2]])
			world.cell_grid[1][2].should be_alive
			world.cell_grid[0][2].should be_alive
		end
	end
	
	context 'Rules' do
	#let!(:game) { Game.new }
		context 'Rule 1: Any live cell with fewer than two live neighbors dies, as if by under population.' do
			it 'Should kill a live cell with no neighbours' do
				game.world.cell_grid[1][1].alive = true
				game.world.cell_grid[1][1].should be_alive
				game.tick!
				game.world.cell_grid[1][1].should be_dead
			end
			it 'Should kill a live cell with 1 live neighbour' do
				game = Game.new(world, [[1,0],[2,0]])
				game.tick!
				world.cell_grid[1][0].should be_dead
				world.cell_grid[2][0].should be_dead
			end
			it 'Doesnt kill live cell with 2 neighbours' do
				game = Game.new(world, [[0,1],[1,1],[2,1]])
				game.tick!
				world.cell_grid[1][1].should be_alive
			end
		end
		context 'Rule 2: Any live cell with two or three live neighbours lives on to the next generation.' do
			it 'Should keep alive cell with 2 neighbours to the next generation' do
				game = Game.new(world, [[0,1],[1,1],[2,1],[2,2]])
				world.live_neighbours_around_cell(world.cell_grid[1][1]).count.should == 3
				game.tick!
				world.cell_grid[0][1].should be_dead
				world.cell_grid[1][1].should be_alive
				world.cell_grid[2][1].should be_alive
				world.cell_grid[2][2].should be_alive
			end
		end
		context 'Rule 3: Any live cell with more than three live neighbours dies, as if by overcrowding.' do
			it 'Should kill live cell with more than 3 live neighbours' do
				game = Game.new(world, [[0,1],[1,1],[2,1],[2,2],[1,2]])
				world.live_neighbours_around_cell(world.cell_grid[1][1]).count.should == 4
				game.tick!
				world.cell_grid[0][1].should be_alive
				world.cell_grid[1][1].should be_dead
				world.cell_grid[2][1].should be_alive
				world.cell_grid[2][2].should be_alive
				world.cell_grid[1][2].should be_dead
			end
		end
		context 'Rule 4:Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
			it 'Revives dead cell with 3 neighbours' do
			game = Game.new(world, [[0,1],[1,1],[2,1]])
			world.live_neighbours_around_cell(world.cell_grid[1][0]).count.should == 3
			game.tick!
			world.cell_grid[1][0].should be_alive
			world.cell_grid[1][2].should be_alive
			end
		end
	end
end
