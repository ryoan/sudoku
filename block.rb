require "sdl"

class N

def printd(d)
  " +-------+-------+-------+\n".display
  (0...9).each {|i|
  (0...9).each {|j| ((j%3==0)? " | " : " ").display;  ((d[i][j]==0)? "*": d[i][j]).display}
#  (0...9).each {|j| }
    " |\n".display;
    " +-------+-------+-------+\n".display if (i%3==2) }end
#     }end

def suudoku1(d)
  s=0;
  begin
    s0=s;
    d.each_index {|i| d[i].each_index {|j| if ((a=d[i][j]).size==1) ## aを候補から消す
      (0...9).each {|k| d[k][j]-=a if (i!=k)}
      (0...9).each {|k| d[i][k]-=a if (j!=k)}
      (i/3*3...i/3*3+3).each {|k| (j/3*3...j/3*3+3).each {|l| d[k][l]-=a if (i!=k && j!=l)}}
    end}}
  end until (s0==(s=d.inject(0) {|s,i| s+=i.inject(0) {|s,j| s+=j.size}}))
  mi=mj=m=10
#  d.each_index {|i| d[i].each_index {|j| a=d[i][j].size; mi,mj,m=i,j,a if (a!=1 && a<m) }}


#=begin
  d.each_index {|i|
	d[i].each_index {|j|
		a=d[i][j].size;
		#print("d[",i,"][",j,"]=",d[i][j],"\n")
		(
			#print("i=",i," j=",j," a=",a,"\n")
			mi,mj,m=i,j,a
			#print("mi=",mi," mj=",mj," m=",m,"\n")
			#print("d[",mi,"][",mj,"]=",d[mi][mj],"\n")
		)if (a!=1 && a<m) 
	}
  }

#=end

  if (m==0)   ## 解なし
    return []
  elsif (m<10) ## d[mi][mj] の取り得る値を入れて解を求める
    dd=d[mi][mj].collect {|k|
      dd=d.collect {|i| i.collect {|j| j.dup}}  ##copy
      dd[mi][mj]=[k]; dd}
    dd=dd.inject([]) {|dd,d| dd+=suudoku1(d)}
    return dd
  else  ## 解けた
	(0..8).each{|i| (0..8).each {|j| d[i][j]=d[i][j][0] } }
    return [d]
  end
end

def suudoku(d)
  printd(d);
  d.each_index {|i| d[i].each_index {|j|
    if (d[i][j]==0) then  d[i][j]=[1,2,3,4,5,6,7,8,9]; else d[i][j]=[d[i][j]];end}}
  dd=suudoku1(d)
  printf("Number of solutions: %d\n",dd.size);
  dd.each {|d| printd(d); "\n".display}
end

end

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
				roop_count = 0
				prenumber = rand(9)+1
				@count = @count + 1
				while flag == 1 do
					flag = 0
					number = (prenumber + roop_count)%9+1
					(0..8).each {|i| flag = 1 if @sheet[i][side] == number }
					(0..8).each {|i| flag = 1 if @sheet[height][i] == number }
					(height/3*3...height/3*3+3).each {|k| (side/3*3...side/3*3+3).each {|l| flag = 1 if( (k!=height && l!=side) && @sheet[k][l] == number ) }}
					roop_count = roop_count + 1
					if flag == 0 then
						@sheet[height][side] = number
						side = side + 1
					end
					if roop_count>8 then
						side = 0
						roop_count = 0
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
		@hide = Array.new(9).map{Array.new(9,0)}
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
#					block3[a/3][b/3] += 1.0 unless @temp_q[a][b] == 0
					block3[a/3][b/3] += 1.0 unless search[a][b] == 1
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
				@hide = Array.new(9).map{Array.new(9,0)}
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
	#					block3[a/3][b/3] += 1.0 unless @temp_q[a][b] == 0
						block3[a/3][b/3] += 1.0 unless search[a][b] == 1
						block_max = block3[a/3][b/3] if block_max < block3[a/3][b/3]
					end
				end

				for a in 0..8 do
					for b in 0..8 do
	#					search[a][b] = 1 if block3[a/3][b/3] == 1
						search_num += 1 if search[a][b] == 1
					end
				end



			end

#			print("search_num:",search_num,"\n")
			ma =N.new()
			@temp = Marshal.load(Marshal.dump(search))
			ma.printd(@temp)
=begin
			a = rand(3)
			b = rand(3)
			search_roop = 0

			while block3[a][b] == 0 do
				print("block3[",a,"][",b,"]=",block3[a][b],"\n")
				a = rand(3)
				b = rand(3)
				search_roop += 1
				if search_roop >= 50 then
					break
				end
			end
			break if search_roop >= 100
			print("block3[",a,"][",b,"]=",block3[a][b],"\n")
=end
			a = rand(3)
			b = rand(3)
			p= ( (rand(100)+1)*0.01 )/100
#			q =( (block3[a][b]-1) / (block_max - 1))
			q =( (block3[a][b]) / (block_max))
			#print("block_max=",block_max,"\n")
			#print("block3[",a,"][",b,"]=",block3[a][b],"\n")
			#print("p=",p,"\n")
			#print("q=",q,"\n")
			while (p >= q)  do
				a = rand(3)
				b = rand(3)
				p= ( (rand(100)+1)*0.01 )/100
#				q =( (block3[a][b]-1) / (block_max - 1))
				q =( (block3[a][b]) / (block_max))
				#print("block3[",a,"][",b,"]=",block3[a][b],"\n")
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
			ma =N.new()
			@temp = Marshal.load(Marshal.dump(@temp_q))
			ma_q = ma.suudoku(@temp)
			if ma_q.size == 1 then
#				@hide[height][side] = 1
				del_num = del_num + 1
				@temp_q[height][side] = 0
				search = Array.new(9).map{Array.new(9,0)}
=begin
				for a in 0..8 do
					for b in 0..8 do
						@temp_q[a][b] = 0 if @hide[a][b] == 1
					end
				end
=end
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

d=[[1,2,0,0,0,0,7,8,9],
   [0,0,0,7,0,9,1,0,4],
   [7,0,9,1,2,0,0,0,6],

   [2,0,0,0,6,7,0,9,1],
   [0,0,0,0,0,1,2,0,0],
   [0,9,1,2,0,0,5,0,0],

   [0,0,0,6,0,0,0,1,2],
   [0,7,0,0,0,2,0,0,0],
   [9,0,2,0,0,0,0,7,8]]
#n=N.new()
#n.suudoku(d)

n = Sheet.new
#n.print_sheet
n.make_question(ARGV[0].to_i)
#n.print_sheet
#n.print_question

