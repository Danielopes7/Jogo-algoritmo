
love.window.setTitle("Help the birds")
local anim = require 'anim8'
larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()
local imagem,animation
local imagem2,animation2
local imagem3,animation3
local posY=100
local posX=300
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
   
   delayBird=3-- tempo para aparecer os passaros na tela
  timeBirds=0 -- incrementa mais dificuldade ao jogo surgindo uma quantidade maior de pássaros
   tempocriarBirds=delayBird
   Birds={}

 --cano se movendo
 canoEixoy=-20
 time=0
 delta=1
-- pontos

pontos=pontos+1
--reset and gameover
vivo=true
--sons usados no jogo
morte=love.audio.newSource("sons/didimorreu.mp3","static")
barulhoaomorrer=love.audio.newSource("sons/barulhoaomorrer.mp3","static")
gameover=love.audio.newSource("sons/gameover.mp3","static")
menuMusic=love.audio.newSource("sons/MusicMenu.mp3")
menuMusic:play()
menuMusic:setLooping(true)
musicaInGame=love.audio.newSource("sons/MusicInGame.mp3")


--menu
telaDomenu=love.graphics.newImage("imagem/menu.png")
telaInstrucoes=love.graphics.newImage("imagem/instrucoes.png")
abreMenu=true
abreInstrucoes=false
semColisaoeBirds=false -- desativar colisao na hora do menu


end

function love.update(dt)
  movimentacao(dt) -- movimentação do personagem principal
  Bird(dt) -- pássaros surgindo na teladefundo
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
-- tecla restart
timeBirds=timeBirds+dt
if not vivo and love.keyboard.isDown('r') then
	Birds={}
	tempocriarBirds=delayBird
	posX=395
	posY=100
	pontos=0
	vivo=true
  timeBirds=0
 --tecla usadas no MENU
end
    if love.keyboard.isDown('x') and abreMenu then
      abreMenu=false
      abreInstrucoes=true
     
    end
    if love.keyboard.isDown('z') and abreInstrucoes then 
      abreInstrucoes=false
      	Birds={}
	tempocriarBirds=delayBird
	posX=395
	posY=100
	pontos=0
	vivo=true
  semColisaoeBirds=true
  menuMusic:stop()
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

-- criação dos pássaros na tela
	for i,Bird in ipairs(Birds) do
		if vivo  and semColisaoeBirds then
			animation3:draw(imagem3,Bird.x,Bird.y,0,-1,1,20,0)
      musicaInGame:play()
      musicaInGame:setLooping()
		else-- se os passáros nao tiverem na tela = GAME OVER
       love.graphics.print("GAME OVER!",280,100)
     
       love.graphics.print("aperte [r] para reviver",200,200)
      musicaInGame:stop()
    end
	end
  -- booleans chamadas do love.load para se estiver verdadeio aparecer na tela a imagem chamada no draw
    if abreMenu then
      love.graphics.draw(telaDomenu,0,0)
    end
    if abreInstrucoes then
      love.graphics.draw(telaInstrucoes,0,0)
    end
    

end
function movimentacao(dt)--movimentação do personagem principal 
 if love.keyboard.isDown('left') then
      if posX>0  then --não deixar o personagem sair da tela
        posX=posX -170 *dt --velocidade do personagem
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
function Bird(dt)-- criacao dos pássaros
tempocriarBirds=tempocriarBirds - dt
	if tempocriarBirds<0 then   
   if timeBirds<30 then 
      tempocriarBirds=delayBird
    elseif timeBirds>29 and timeBirds<60 then -- aumento de pássaros na tela
      tempocriarBirds=delayBird-1
    elseif timeBirds>59 then
      tempocriarBirds=1
    end

		numAleatorio=math.random(300,425)

		novoBird={ x=800 ,y=numAleatorio, imag=imagem3 }
		table.insert(Birds, novoBird)

  end
			for i,Bird in ipairs(Birds) do
			
         Bird.x=Bird.x-(100*dt) -- percuso do pássaro 
      
        
      
        if Bird.x<20 and Bird.x >19 and vivo or Bird.x<20 and Bird.x>19 and guia and vivo then -- contando os pontos
          pontos=pontos+1
        else 
          
        end

			end
	 animation3:update(dt)
end
function colisaocano() --colisao do cano da esquerda
  for i,Bird in ipairs(Birds) do
      if checaColisoes2(22,0,52,299+canoEixoy,Bird.x,Bird.y,41,38) and vivo and semColisaoeBirds or checaColisoes2(22,472+canoEixoy,52,400,Bird.x,Bird.y,41,38) and Bird.x>21 and vivo and  semColisaoeBirds then
          table.remove(Birds,i)
		  vivo=false
    
      gameover:play()
      morte:play()
      barulhoaomorrer:play()
      
      
      
    
      
    end
    
  end
end

function checaColisoes2(x1,y1,w1,h1,x2,y2,h2,w2)
    
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1

end

function guia()
	for i,Bird in ipairs(Birds) do
		if checaColisoes(Bird.x,41,posX,41) and posY > Bird.y and vivo and semColisaoeBirds then

		Bird.y=Bird.y+2 -- o que move os pássaros pelo personagem principal
  elseif checaColisoes(Bird.x,41,posX,41) and posY < Bird.y and vivo and semColisaoeBirds  then
    Bird.y=Bird.y-2
    end
	end
end
function checaColisoes(x1,w1,x2,w2)
  
	return x2+(w2/2) >= x1 and x2+(w2/2) <= x1+w1 and vivo
end
