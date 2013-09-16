class Answer

def printd(d)
  " +-------+-------+-------+\n".display
  (0...9).each {|i|
  (0...9).each {|j| ((j%3==0)? " | " : " ").display;  ((d[i][j]==0)? "*": d[i][j]).display}
    " |\n".display;
    " +-------+-------+-------+\n".display if (i%3==2) }
end


def suudoku1(d)
  s=0;
  begin
    s0=s;
    d.each_index {|i| d[i].each_index {|j| if ((a=d[i][j]).size==1) ## aを候補から消す
      (0...9).each {|k| d[k][j]-=a if (i!=k)}
	#print("Delete:",a, " of d[][",j,"]\n")
      (0...9).each {|k| d[i][k]-=a if (j!=k)}
	#print("Delete:",a, " of d[",i,"][]\n")
      (i/3*3...i/3*3+3).each {|k| (j/3*3...j/3*3+3).each {|l| d[k][l]-=a if (i!=k && j!=l)}}
	#print("Delete:",a, " of block3[",i,"][",j,"]\n")
    end}}

#=begin
    d.each_index {|i| d[i].each_index {|j|
	unless (d[i][j].size == 1) then
	d[i][j].each {|m|
		flag2 = 0
		(i/3*3...i/3*3+3).each {|k| (j/3*3...j/3*3+3).each {|l|
			flag2 = 1 if(d[k][l].include?(m) == true && k!=i)
		}
		}
		if (flag2 == 0) then
			(0...9).each {|n| d[i][n].delete(m) unless (n/3 == j/3)
			}
			#print(i,j,"Delete ",m," of d[",i,"][]\n");
		end
		flag2 = 0
		(i/3*3...i/3*3+3).each {|k| (j/3*3...j/3*3+3).each {|l|
			flag2 = 1 if(d[k][l].include?(m) == true && l!=j)
		}
		}
		if (flag2 == 0) then
			(0...9).each {|n| d[n][j].delete(m) unless (n/3 == i/3)
			}
			#print(i,j,"Delete ",m," of d[][",j,"]\n");
		end

	}
	end
    }}
#=end

    d.each_index {|i| d[i].each_index {|j|
	unless (d[i][j].size == 1) then
	d[i][j].each {|m|
		flag2 = 0
		(i/3*3...i/3*3+3).each {|k| (j/3*3...j/3*3+3).each {|l|
			break if(k==i && l==j)
			flag2 = 1 if(d[k][l].include?(m) == true)
		}
		}
		if (flag2 == 0) then 
			d[i][j] = [m]; 
			#print("d[",i,"][",j,"]:",d[i][j],"\n");
		end
	}
	end
    }}
	

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
  print("解答を作成しています...\n")
  d.each_index {|i| d[i].each_index {|j|
    if (d[i][j]==0) then  d[i][j]=[1,2,3,4,5,6,7,8,9]; else d[i][j]=[d[i][j]];end}}
  dd=suudoku1(d)
  printf("Number of solutions: %d\n",dd.size);
  dd.each {|d| if(dd.size == 1) then printd(d); "\n".display; end}
end

end

d=[[0,0,3,4,0,6,0,0,0],
   [0,8,0,0,0,0,2,0,6],
   [0,0,0,0,0,0,0,0,4],

   [5,0,0,0,0,0,0,0,7],
   [0,0,4,2,0,0,9,0,0],
   [9,0,0,0,7,0,0,0,0],

   [0,0,0,3,0,0,0,0,0],
   [0,0,0,0,0,9,0,0,0],
   [0,6,2,0,0,0,8,0,0]]

n=Answer.new();
n.suudoku(d);

