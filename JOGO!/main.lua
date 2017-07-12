love.window.setMode(800,600, {resizable=true})
love.window.setTitle("Mate as galinhas")
local anim = require 'anim8'
larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()
local imagem,animation
local imagem2,animation2
local imagem3,animation3
local posY=395
local posX=100
local direita=true
local cobreimagem=true
local pode=false
local verificar=false
local movCano=true
function love.load()
  --background
  imagem0=love.graphics.newImage("imagem/teladefundo.png")
  --chao
  chao=love.graphics.newImage("imagem/chao.png")
  --cano
  cano=love.graphics.newImage("imagem/cano.png")

   -- personagem
      imagem2=love.graphics.newImage("Imagem/flappymorto.png")
    local g = anim.newGrid(41,30,imagem2:getWidth(),imagem2:getHeight())
    animation2 = anim.newAnimation(g('1-3',1) , 0.2)

    -- passarinho
      imagem3=love.graphics.newImage("Imagem/flappy.png")
    local g = anim.newGrid(41,30,imagem3:getWidth(),imagem3:getHeight())
    animation3 = anim.newAnimation(g('1-3',1) , 0.2)
   delayInimigo=3
   tempocriarInimigo=delayInimigo
   inimigos={}

   delayfuradeira=1
  tempodefuradeira=delayfuradeira
 --cano se movendo
 canoEixoy=-20
 time=0
 delta=1

end

function love.update(dt)
  movimentacao(dt)
  inimigo(dt)
  guia()


time=time+dt
canoEixoy=canoEixoy-delta
for x=3,10000,3 do
  if time>x and x%2~=0 then
    delta=-1

  elseif time>x and x%2==0 then
    delta=1

  end
end







end

function love.draw()
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(imagem0,0,0)
    love.graphics.draw(cano,-40,canoEixoy)
    love.graphics.draw(chao,0,0)

  if direita and cobreimagem then
        animation2:draw (imagem2,posX,posY,0,-1,1,20,0)
  elseif direita and not cobreimagem then
        animation2:draw(imagem2,posX,posY,0,1,1,20,0)
  end


	for i,inimigo in ipairs(inimigos) do
		animation3:draw(imagem3,inimigo.x,inimigo.y,0,-1,1,20,0)
	end



end
function movimentacao(dt)
 if love.keyboard.isDown('left') then
      if posX>0  then
        posX=posX -150 *dt
       direita=true
       cobreimagem=true
        animation2:update(dt)
      end
  end
    if love.keyboard.isDown('right') then
        if posX<800 then
        posX=posX +150*dt
       direita=true
       cobreimagem=false
        animation2:update(dt)
        end
    end
  if love.keyboard.isDown('up')  then
    if posY>0 then
      posY=posY-150*dt

      animation2:update(dt)

    end
  end
      if love.keyboard.isDown('down') then
        if posY<590 then
          posY=posY+150*dt
          animation2:update(dt)
        end
      end




end
function inimigo(dt)
tempocriarInimigo=tempocriarInimigo - (1*dt)
	if tempocriarInimigo<0 then

		tempocriarInimigo=delayInimigo
		numAleatorio=math.random(300,425)

		novoInimigo={ x=800 ,y=numAleatorio , imag=imagem3 }
		table.insert(inimigos, novoInimigo)
  end
			for i,inimigo in ipairs(inimigos) do
				inimigo.x=inimigo.x-(100*dt)


			end
	 animation3:update(dt)
end
function guia()
	for i,inimigo in ipairs(inimigos) do
		if checaColisoes(inimigo.x,41,posX,41) and posY > inimigo.y  then

		inimigo.y=inimigo.y+1

  elseif checaColisoes(inimigo.x,41,posX,41) and posY < inimigo.y then
    inimigo.y=inimigo.y-1
    end
	end
end
function checaColisoes(x1,w1,x2,w2)
	return x2+(w2/2) >= x1 and x2+(w2/2) <= x1+w1
end
