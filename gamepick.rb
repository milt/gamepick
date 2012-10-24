# gamepick.rb

require 'rubygame'
require 'yaml'
include Rubygame

config = YAML.load_file 'config/config.yml'

rompath = config["paths"]["rom"]
mamepath = config["paths"]["mame"]
fontpath = config["paths"]["font"]
maxres = config["display"]["maxres"]


dev_res = Screen.get_resolution()
target = [1024,768]

if (dev_res[0] > maxres[0]) || (dev_res[1] > maxres[1])
  res = maxres
else
  res = dev_res
end

romdir = Dir.new(rompath)

games = []
romdir.each {|filename| games << filename}
games = (games - [".",".."]).sort

games = games.map {|n| n.gsub(".zip","")}

#xoff = 290
yoff = 180
texpos = [0,res[1]/2 - yoff]

Rubygame.init
TTF.setup

def title(string,font,screen,coords)
  text = font.render(">" + string,false,[0,255,0])
  text.blit(screen,coords)
end

font = TTF.new(fontpath,200)

screen = Screen.new(res)
screen.title = 'Hello World'
screen.fill [0,0,0]
title(games.first,font,screen,texpos)


#skip = font.line_skip()

screen.update

queue = Rubygame::EventQueue.new

game_over = false

until game_over do
  queue.each do |event|
    case event
      when ActiveEvent
        screen.update
      when QuitEvent
        game_over = true
      when KeyDownEvent
        case event.key
          when K_DOWN
            screen.fill [0,0,0]
            games = games.rotate
            title(games.first,font,screen,texpos)
            screen.update
          when K_UP
            screen.fill [0,0,0]
            games = games.rotate(-1)
            title(games.first,font,screen,texpos)
            screen.update
          when K_ESCAPE
            game_over = true
          when K_RETURN
            system mamepath + " " + games.first
            screen.fill [0,0,0]
            title(games.first,font,screen,texpos)
            screen.update
          else
           screen.update
        end
    end
  end
end

Rubygame.quit
