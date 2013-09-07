require "sdl"
require "lib/fpstimer"
require "lib/input"  # input.rb を読み込む
require "block.rb"


SCREEN_W = 600
SCREEN_H = 600
HOLIZON  = 300
BLOCK_SIZE = 50

def load_image(fname)
  image = SDL::Surface.load(fname)
  image.set_color_key(SDL::SRCCOLORKEY, [255, 255, 255])
  #image2=image.transform_surface([255,255,255],0,3,3,SDL::Surface::TRANSFORM_SAFE)

  image
end

# キー定義
class Input
  define_key SDL::Key::ESCAPE, :exit
  define_key SDL::Key::LEFT, :left
  define_key SDL::Key::RIGHT, :right
  define_key SDL::Key::UP, :up
  define_key SDL::Key::DOWN, :down
  define_key SDL::Key::K0, :zero
  define_key SDL::Key::K1, :one
  define_key SDL::Key::K2, :two
  define_key SDL::Key::K3, :three
  define_key SDL::Key::K4, :four
  define_key SDL::Key::K5, :five
  define_key SDL::Key::K6, :six
  define_key SDL::Key::K7, :seven
  define_key SDL::Key::K8, :eight
  define_key SDL::Key::K9, :nine
  define_key SDL::Key::BACKSPACE, :backspace
  define_key SDL::Key::RETURN, :enter
end

n = Sheet.new
n.make_question(ARGV[0].to_i)

SDL.init(SDL::INIT_EVERYTHING)
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)
SDL::Surface.autoLockON

SDL::TTF.init
font = SDL::TTF.open('sample.ttf',50)
font.style = SDL::TTF::STYLE_NORMAL


x = 0
y = 0
key_press = true
sheet=Array.new(9).map{Array.new(9,0)}

input = Input.new        # 入力用の変数を初期化
timer = FPSTimerLight.new
timer.reset
loop do  
  input.poll             # キーボードやジョイスティックを調べる
  break if input.exit

  x -= 1 if input.left && key_press == false 
  x += 1 if input.right && key_press == false 
  x = 8 if x < 0
  y += 1 if input.down && key_press == false 
  y -= 1 if input.up && key_press == false 
  y = 8 if y < 0
  x = 0 if x >= 9
  y = 0 if y >= 9

if input.left || input.right || input.down || input.up then
	key_press = true
else key_press = false
end

if input.one then 
	sheet[x][y]=1
elsif input.two then
	sheet[x][y]=2
elsif input.three then
	sheet[x][y]=3
elsif input.four then
	sheet[x][y]=4
elsif input.five then
	sheet[x][y]=5
elsif input.six then
	sheet[x][y]=6
elsif input.seven then
	sheet[x][y]=7
elsif input.eight then
	sheet[x][y]=8
elsif input.nine then
	sheet[x][y]=9
elsif input.zero then
	sheet[x][y]=0
elsif input.backspace then
	sheet[x][y]=0
end

kaitou = 1
  (0..8).each {|i| 
	(0..8).each {|j|
		kaitou = 0 if sheet[i][j] != n.sheet[i][j]
	}
  }
break if input.enter && kaitou == 1

  screen.fill_rect(0, 0, SCREEN_W, SCREEN_H, [255,255,255])
  (0...10).each {|i| 
	screen.fill_rect(BLOCK_SIZE+i*BLOCK_SIZE,BLOCK_SIZE+4,4,9*BLOCK_SIZE,[0,0,0]) if (i%3)==0
	screen.fill_rect(BLOCK_SIZE+i*BLOCK_SIZE,BLOCK_SIZE+4,2,9*BLOCK_SIZE,[0,0,0]) unless (i%3)==0
  }
  (0...10).each {|i|
	screen.fill_rect(BLOCK_SIZE,BLOCK_SIZE+i*BLOCK_SIZE,9*BLOCK_SIZE+4,4,[0,0,0]) if (i%3)==0
	screen.fill_rect(BLOCK_SIZE,BLOCK_SIZE+i*BLOCK_SIZE,9*BLOCK_SIZE+4,2,[0,0,0]) unless (i%3)==0
  }

  screen.fill_rect(BLOCK_SIZE+x*BLOCK_SIZE,BLOCK_SIZE+y*BLOCK_SIZE,4,BLOCK_SIZE,[255,0,0])
  screen.fill_rect((2*BLOCK_SIZE)+x*BLOCK_SIZE,BLOCK_SIZE+y*BLOCK_SIZE,4,BLOCK_SIZE,[255,0,0])
  screen.fill_rect(BLOCK_SIZE+x*BLOCK_SIZE,BLOCK_SIZE+y*BLOCK_SIZE,BLOCK_SIZE,4,[255,0,0])
  screen.fill_rect(BLOCK_SIZE+x*BLOCK_SIZE,(2*BLOCK_SIZE)+y*BLOCK_SIZE,BLOCK_SIZE+4,4,[255,0,0])
  font.drawSolidUTF8(screen,"CLEAR:Enter Key Exit ",BLOCK_SIZE,SCREEN_H-BLOCK_SIZE,0,0,0) if kaitou == 1

#p font.line_skip
#  font.drawSolidUTF8(screen,'1',BLOCK_SIZE+15,BLOCK_SIZE,0,0,0)

  (0..8).each {|i|
	(0..8).each {|j|
		sheet[i][j] = n.question[i][j] if n.question[i][j] != 0
		font.drawSolidUTF8(screen,sheet[i][j].to_s,(BLOCK_SIZE*i)+BLOCK_SIZE+15,BLOCK_SIZE+BLOCK_SIZE*j,0,0,0) if sheet[i][j] != 0
		font.drawSolidUTF8(screen,n.question[i][j].to_s,(BLOCK_SIZE*i)+BLOCK_SIZE+15,BLOCK_SIZE+BLOCK_SIZE*j,255,0,0) if n.question[i][j] !=0
	}
  }
  fill_number=Array.new(9,0)
  (1..9).each {|number| (0..8).each{|i| (0..8).each{|j| fill_number[number-1] += 1 if sheet[i][j]==number} } }
  (0..8).each {|i| font.drawSolidUTF8(screen,fill_number[i].to_s,BLOCK_SIZE+BLOCK_SIZE*i,SCREEN_H-2*BLOCK_SIZE,255,0,0) if fill_number[i] != 9 }
  


#  screen.put(chara, x, y)
  timer.wait_frame do
    screen.update_rect(0, 0, 0, 0)
	sleep(0.1)
  end
end
