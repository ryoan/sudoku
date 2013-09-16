require "sdl"
require "answer_question.rb"


class Sheet
	def initialize
		#シートの初期化
		@sheet = Array.new(9).map{Array.new(9,0)}
		@question = nil
		@count = 0
		@result = 0
		height = 0
		while height < 9 do
			side = 0
			while side< 9 do
				flag = 1
				num_count = 0
				prenumber = rand(9)+1
				@count = @count + 1
				while flag == 1 do
					flag = 0
					number = (prenumber + num_count)%9+1
					(0..8).each {|i| flag = 1 if @sheet[i][side] == number }
					(0..8).each {|i| flag = 1 if @sheet[height][i] == number }
					(height/3*3...height/3*3+3).each {|k| (side/3*3...side/3*3+3).each {|l| flag = 1 if( (k!=height && l!=side) && @sheet[k][l] == number ) }}
					num_count = num_count + 1
					if flag == 0 then
						@sheet[height][side] = number
						side = side + 1
					end
					if num_count>8 then
						side = 0
						num_count = 0
						(0..8).each {|b| @sheet[height][b] = 0 }
						break
					end
					if @count >= 400 then
						@sheet = Array.new(9).map{Array.new(9,0)}
						@result += @count
						@count = 0
						height = 0
						side = 0
					end
				end
			end
			height = height + 1
		end
		@result += @count
		@count = @result
	end
	def print_obj(print_object)
		for a in 0..8 do
			print("---+---+---\n") if (a % 3 == 0 && a / 3 >= 1)
			for b in 0..8 do
				print "|"if (b % 3 == 0 && b / 3 >= 1)
				print(print_object[a][b])
			end
			print("\n")
		end
	end
	def print_sheet
		print("count=",@count,"\n")
		print_obj(@sheet)
	end
	def print_question
		if @question == nil then
			@question = Marshal.load(Marshal.dump(@sheet))
		end
		print_obj(@question)
	end
	def make_question(delete_num = 10)
		flag = 1
		del_num = 0
		step = 0
		@temp_q = Array.new(9).map{Array.new(9,0)}
		@temp_q = Marshal.load(Marshal.dump(@sheet))
		search = Array.new(9).map{Array.new(9,0)}
#		search[0][0] = 0
		roop_count = 0
		while del_num < delete_num do
			step = step + 1
			flag = 0
			block3= Array.new(3).map{Array.new(3,0)}
			block3[0][0] = 0
			block_max = 0
			search_num = 0
			for a in 0..8 do
				for b in 0..8 do
					search[a][b]= 1 if @temp_q[a][b] == 0
					block3[a/3][b/3] += 1 unless search[a][b] == 1
					block_max = block3[a/3][b/3] if block_max < block3[a/3][b/3]
				end
			end

			for a in 0..8 do
				for b in 0..8 do
#					search[a][b] = 1 if block3[a/3][b/3] == 1
					search_num += 1 if search[a][b] == 1
				end
			end



			flag = 0
			for a in 0..8 do
				for b in 0..8 do
					if search[a][b] == 0 then
						flag = 1
						break
					end
				end
			end
			if flag == 0 then
				roop_count += 1
				initialize if (roop_count % 3) == 0
				@temp_q = Marshal.load(Marshal.dump(@sheet))
				search = Array.new(9).map{Array.new(9,0)}
				search_roop = 0
				del_num = 0
				print("reset\n")
				step = step + 1
				flag = 0
				block3= Array.new(3).map{Array.new(3,0)}
				block3[0][0] = 0
				block_max = 0
				search_num = 0
				for a in 0..8 do
					for b in 0..8 do
						search[a][b]= 1 if @temp_q[a][b] == 0
						block3[a/3][b/3] += 1 unless search[a][b] == 1
						block_max = block3[a/3][b/3] if block_max <= block3[a/3][b/3]
					end
				end

				(0...9).each {|a| (0...9).each {|b| 
						search_num += 1 if search[a][b] == 1
				}}



			end

#			print("search_num:",search_num,"\n")
			ma =Answer.new()
			#@temp = Marshal.load(Marshal.dump(search))
			#ma.printd(@temp)
			a = rand(3)
			b = rand(3)
			print("block_max=",block_max,"\n")
			#print("block3[",a,"][",b,"]=",block3[a][b],"\n")
			p= ( (rand(100)+1)*0.01 )/100
#			q =( (block3[a][b]-1) / (block_max - 1))
			q =( (block3[a][b]) / (block_max))
			#print("p=",p,"\n")
			#print("q=",q,"\n")
			while (p >= q)  do
				a = rand(3)
				b = rand(3)
				#print("block3[",a,"][",b,"]=",block3[a][b],"\n")
				p= ( (rand(100)+1)*0.01 )/100
				q =( (block3[a][b]) / (block_max))
				#print("p=",p,"\n")
				#print("q=",q,"\n")
			end
			height = (a*3) + rand(3)
			side = (b*3) + rand(3)
			#print("temp_q[",height,"][",side,"]\n")
			search_roop = 0
			while search[height][side] !=0 do
				height = (a*3) + rand(3) if ran = rand(2) == 0
				side = (b*3) + rand(3) unless ran == 0
				#print("temp_q[",height,"][",side,"]\n")
				search_roop += 1
				if search_roop >= 50 then
					break
				end
			end
			break if search_roop >= 100

			print("search_num:",search_num,"\n")
			print("step=",step,"\n")
			print("delete=",del_num,"\n")
			print("roop_count=",roop_count,"\n")
			temp_val = @temp_q[height][side]
			@temp_q[height][side] = 0
			ma =Answer.new()
			@temp = Marshal.load(Marshal.dump(@temp_q))
			ma_q = ma.suudoku(@temp)
			if ma_q.size == 1 then
				del_num = del_num + 1
				@temp_q[height][side] = 0
				search = Array.new(9).map{Array.new(9,0)}
			else
				@temp_q[height][side] = temp_val
				search[height][side] = 1
			end
		end
		@question = @temp_q
	end
	attr_reader :sheet
	attr_reader :question
end

s=Sheet.new()
s.make_question(ARGV[0].to_i)
n=Answer.new()
n.suudoku(s.sheet)

#n = Sheet.new
#n.print_sheet
#n.make_question(ARGV[0].to_i)
#n.print_sheet
#n.print_question

