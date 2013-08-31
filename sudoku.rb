class Sheet

	def initialize
		#シートの初期化
		@sheet = Array.new(9).map{Array.new(9,0)}
		for height in 0..8 do
			side = 0
			while side<9 do
				flag = 1
				roop_count = 0
				numbers = rand(9)+1
				while flag == 1 do
					flag = 0
					number = (numbers + roop_count)%9+1
					for height_check in 0..8 do
						if @sheet[height_check][side] == number then
							flag = 1
							break
						end
					end
					for side_check in 0..8 do
						if @sheet[height][side_check] == number then
							flag = 1
							break
						end
					end
					block3_height = height / 3
					block3_side = side / 3
					for i in 0..2 do
						for j in 0..2 do
							if ( (block3_height*3)+i == height ) && ( (block3_side*3)+j == side ) then
								break
							end
							if @sheet[(block3_height*3)+i][(block3_side*3)+j] == number then
								flag = 1
								break
							end
						end
					end
					roop_count = roop_count + 1
					if flag == 0 then
						@sheet[height][side] = number
					end
					if roop_count>8 then
						side = -1
						roop_count = 0
						for b in 0..8 do
							@sheet[height][b] = 0
						end
						break
					end
				end
				side = side + 1
			end
		end
	end
	def print_sheet
		print("count=",@count,"\n")
		for a in 0..8 do
			for b in 0..8 do
				print(@sheet[a][b])
			end
			print("\n")
		end
	end
	attr_reader :sheet
end

n = Sheet.new
n.print_sheet
