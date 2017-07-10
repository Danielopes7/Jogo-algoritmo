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
local direcao=true
local cobreimagem=true
local pode=false
local verificar=false

function love.load()
  --background
  imagem0=love.graphics.newImage("imagem/teladefundo.png")
   -- personagem 
   imagem = love.graphics.newImage( "Imagem/personagem.png" )
    local g = anim.newGrid (74,101, imagem:getWidth(),imagem:getHeight())
    animation =anim.newAnimation (g('1-3',1) , 0.1)
	--personagem com furadeira
    imagem2=love.graphics.newImage("Imagem/personagem1.png")
    local g = anim.newGrid(90,96,imagem2:getWidth(),imagem2:getHeight())
    animation2 = anim.newAnimation(g('1-3',1) , 0.1)
    -- passarinho
      imagem3=love.graphics.newImage("Imagem/flappy.png")
    local g = anim.newGrid(41,30,imagem3:getWidth(),imagem3:getHeight())
    animation3 = anim.newAnimation(g('1-3',1) , 0.2)
   delayInimigo=2
   tempocriarInimigo=delayInimigo
   inimigos={}
   
   delayfuradeira=1
  tempodefuradeira=delayfuradeira
  -- passarinho animacao
  personagem ={
  posX=posX,
  posY=posY,
  largura=74,
  altura=101,
  velY=0
  }
  
  
  alturaPulo=300
  gravidade=400
  
end

function love.update(dt)
  movimentacao(dt)
  inimigo(dt)
  colisoes()
  if personagem.velY~=0 then
	personagem.posX=personagem.posX-posY*dt
	personagem.velY=personagem.velY-gravidade*dt
      if personagem.posY>posY/2 then
          personagem.velY=0
		  personagem.posY=posY/2
      end
  end
		

end

function love.draw()
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(imagem0,0,0)
     
    if direcao and cobreimagem  then
        animation:draw (imagem,posX,posY,0,-1,1,37,0)
    elseif cobreimagem and not direcao  then
        animation:draw (imagem, posX, posY,0,1,1,37,0)
    end
    
    if not cobreimagem and verificar   then
         animation2:draw (imagem2, posX,posY,0,-1,1,45,0)
    
  elseif not cobreimagem and not verificar then
        animation2:draw (imagem2, posX,posY,0,1,1,45,0)
      end
        
	for i,inimigo in ipairs(inimigos) do
		animation3:draw(imagem3,inimigo.x,inimigo.y,0,-1,1,20,0)
	end
  
    
   
end
function movimentacao(dt)
 if love.keyboard.isDown('left') then
      if posX>0  then
        posX=posX -150 *dt
        direcao=false
        cobreimagem=true
        animation:update(dt)
      end
    end
    if love.keyboard.isDown('right') then
        if posX<800 then
        posX=posX +150*dt
        direcao = true
        cobreimagem=true
      
        animation:update(dt)
        end
	end
    tempodefuradeira=tempodefuradeira-(1*dt)
    if tempodefuradeira<0 then
      pode=true
      
    end
    if love.keyboard.isDown(';') and love.keyboard.isDown('right') and pode  then
		posX=posX+dt
		cobreimagem=false
		verificar=true
		animation2:update(dt)
    pode=false
    tempofuradeira=delayfuradeira
    
    
    

    
  end
  if love.keyboard.isDown(';') and love.keyboard.isDown('left') then
		posX=posX-dt
		cobreimagem=false
		verificar=false
		animation2:update(dt)
  end
	
end
function inimigo(dt)
tempocriarInimigo=tempocriarInimigo - (1*dt)
	if tempocriarInimigo<0 then
		
		tempocriarInimigo=delayInimigo
		numAleatorio=math.random(60,70)
		novoInimigo={ x=800 ,y=430 , imag=imagem3 }
		table.insert(inimigos, novoInimigo)
  end
			for i,inimigo in ipairs(inimigos) do
				inimigo.x=inimigo.x-(100*dt)
       
					if inimigo.y>850 then
						table.remove(inimigos,i)
					end
			end
	 animation3:update(dt)
end
function colisoes()
	for i,inimigo in ipairs(inimigos) do
		if checaColisoes(inimigo.x,inimigo.y,41,30,posX,435,45,96) and love.keyboard.isDown(';') and love.keyboard.isDown('left') or checaColisoes(inimigo.x,inimigo.y,41,30,posX,435,45,96) and love.keyboard.isDown(';') and love.keyboard.isDown('right') then
		table.remove(inimigos,i)
		
		end
	end
end
function checaColisoes(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1<x2+w2  and x1<x2+w1 and y1<y2+h2  and y1<y2+h1
end
function love.keypressed(key)
	if key=="d" then
		if personagem.velY==0 then
			personagem.velY=alturaPulo
		end
	end
end