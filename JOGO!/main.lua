local anim = require 'anim8'
larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()
local imagem,animation
local imagem2,animation2


local posX=100
local direcao=true
local roda=true
local manejo=false

function love.load()
    imagem = love.graphics.newImage( "Imagem/personagem.png" )
    local g = anim.newGrid (74,101, imagem:getWidth(),imagem:getHeight())
    animation =anim.newAnimation (g('1-3',1) , 0.1)

    imagem2=love.graphics.newImage("Imagem/personagem1.png")
    local g = anim.newGrid(90,96,imagem2:getWidth(),imagem2:getHeight())
    animation2 = anim.newAnimation(g('1-3',1) , 0.1)

end



function love.update(dt)
    if love.keyboard.isDown('left') then
      if posX>0  then
        posX=posX -150 *dt
        direcao=false 
        roda=true
        animation:update(dt)
      end
    end
    if love.keyboard.isDown('right') then
        if posX<800 then
        posX=posX +150*dt
        direcao = true
        roda=true
        animation:update(dt)
        end
    elseif love.keyboard.isDown('right' and 's') then
       
        posX=posX+150*dt
        
        manejo =true
        animation2:update(dt)
    end
  
end

function love.draw()
    love.graphics.setBackgroundColor(255,05,255)
     
    if direcao and roda then
        animation:draw (imagem,posX,50,0,-1,1,45,0)
    elseif not direcao and roda then
        animation:draw (imagem, posX, 50,0,1,1,45,0)
    end
   
   if manejo and roda then 
      animation2:draw (imagem2,posX,50,0,-1,1,45,0)
  end
  
    
   
end