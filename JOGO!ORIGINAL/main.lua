
love.window.setTitle("Help the birds")
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
local pontos=-1
local letrasFilename="fonte/letra.ttf"

function love.load()
  --score
  score=love.graphics.newImage("imagem/SCORE.png")
  --background
  imagem0=love.graphics.newImage("imagem/teladefundo.png")
  --chao
  chao=love.graphics.newImage("imagem/chao.png")
  --cano
  cano=love.graphics.newImage("imagem/cano.png")

   -- ALMA do personagem
      imagem2=love.graphics.newImage("Imagem/flappymorto.png")
    local g = anim.newGrid(41,30,imagem2:getWidth(),imagem2:getHeight())
    animation2 = anim.newAnimation(g('1-3',1) , 0.2)

    -- birds
      imagem3=love.graphics.newImage("Imagem/flappy.png")
    local g = anim.newGrid(41,30,imagem3:getWidth(),imagem3:getHeight())
    animation3 = anim.newAnimation(g('1-3',1) , 0.2)
   delayInimigo=3
   tempocriarInimigo=delayInimigo
   inimigos={}

 --cano se movendo
 canoEixoy=-20
 time=0
 delta=1
-- pontos
vivo=true
pontos=pontos+1



end

function love.update(dt)
  movimentacao(dt) -- movimentação do personagem principal
  inimigo(dt) -- inimigos surgindo na teladefundo
  guia()	-- personagem principal movendo os birds
  colisaocano() -- colisao do cano da esquerda com os birds

-- movimento na vertical do cano da esquerda 
time=time+dt
canoEixoy=canoEixoy-delta
for x=3,1000000,3 do
  if time>x and x%2~=0 then
    delta=-1

  elseif time>x and x%2==0 then
    delta=1

  end
end

if not vivo and love.keyboard.isDown('r') then
	inimigos={}
	tempocriarInimigo=delayInimigo
	posX=395
	posY=100
	pontos=0
	vivo=true
end






end

function love.draw()
  
      love.graphics.rectangle("fill",22,472+canoEixoy,52,400)-- retangulo que serve de referencia para fazer colisao do cano de baixo
     love.graphics.rectangle("fill",22,0,52,299+canoEixoy)-- retangulo que serve de referencia para fazer colisao do cano de cima

  love.graphics.setBackgroundColor(255,255,255)
    love.graphics.draw(imagem0,0,0) -- desenho da tela de fundo
    love.graphics.draw(cano,-40,canoEixoy)	--desenho do cano
    love.graphics.draw(chao,0,0)	--desenho do chao
  
    love.graphics.draw(score,20,520)  --desenho da pontuacao
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(love.graphics.newFont(letrasFilename,36))-- fonte da pontuacao
    love.graphics.print(pontos,170,545)
     love.graphics.setColor(255,255,255,255)
    
  if direita and cobreimagem then--  animacao do personagem principal 
        animation2:draw (imagem2,posX,posY,0,-1,1,20,0)
  elseif direita and not cobreimagem then
        animation2:draw(imagem2,posX,posY,0,1,1,20,0)
  end


	for i,inimigo in ipairs(inimigos) do
		if vivo then
			animation3:draw(imagem3,inimigo.x,inimigo.y,0,-1,1,20,0)
		else love.graphics.print("aperte r para reviver",200,200)
    end
	end
    


end
function movimentacao(dt)
 if love.keyboard.isDown('left') then
      if posX>0  then
        posX=posX -170 *dt
       direita=true
       cobreimagem=true
        animation2:update(dt)
      end
  end
    if love.keyboard.isDown('right') then
        if posX<800 then
        posX=posX +170*dt
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
      
        if inimigo.x<20 and inimigo.x>19 or inimigo.x<20 and inimigo.x>19 and guia then
          pontos=pontos+1
        end

			end
	 animation3:update(dt)
end
function colisaocano()
  for i,inimigo in ipairs(inimigos) do
      if checaColisoes2(22,0,52,299+canoEixoy,inimigo.x,inimigo.y,41,38) or checaColisoes2(22,472+canoEixoy,52,400,inimigo.x,inimigo.y,41,38) and inimigo.x>21  then
          table.remove(inimigos,i)
		  vivo=false
      end
  end
end

function checaColisoes2(x1,y1,w1,h1,x2,y2,h2,w2)
    
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1

end

function guia()
	for i,inimigo in ipairs(inimigos) do
		if checaColisoes(inimigo.x,41,posX,41) and posY > inimigo.y  then

		inimigo.y=inimigo.y+1.2

  elseif checaColisoes(inimigo.x,41,posX,41) and posY < inimigo.y then
    inimigo.y=inimigo.y-1.2
    end
	end
end
function checaColisoes(x1,w1,x2,w2)
  
	return x2+(w2/2) >= x1 and x2+(w2/2) <= x1+w1 and vivo
end
