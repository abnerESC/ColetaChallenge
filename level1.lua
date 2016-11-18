-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- include Corona's "widget" library
local widget = require "widget"

local music = audio.loadSound( "music.mp3")
--audio.play( music , {loops = -1})

--------------------------------------------

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local marginTop = 15

local VIDRO, PAPEL, METAL, PLASTICO = "vidro", "papel", "metal", "plastico"

local isValidScore = true
local score = 0;

--OBJETIVO DA FASE
local objetivo1 = { "rolo de papel", 9, 0 }
local objetivo2 = { "cerveja", 6, 0 }



function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setDrawMode( "normal" )

	local background = display.newImageRect( "img/screenComponents/build.jpg", screenW, screenH * 0.9 )
	background.x, background.y = display.screenOriginX, display.screenOriginY
	background.anchorX = 0 
	background.anchorY = 0

	--criando a parede esquerda e direita
	--local wallLeft = display.newRect( 0,0,100,screenH )
	--wallLeft.anchorX, wallLeft.anchorY = 0,0
	--physics.addBody( wallLeft, "static", { friction = 10 } )
	--local wallRight = display.newRect( screenW, screenH/2, 1, screenH )
	--physics.addBody( wallRight, "static" )

	--criando vetores com as imagens (path das imagens) que vão aparecer na tela

	vectorObjetivo1 = {}
	for i=1,objetivo1[2] do
		vectorObjetivo1[i] = objetivo1[1]
	end

	vectorObjetivo2 = {}
	for i=1,objetivo2[2] do
		vectorObjetivo2[i] = objetivo2[1]
	end

	naoObjetivo = {"champagne","copo de café","talheres", "copo de plástico"}
	vectorNaoObjetivo = {}
	for i=1,35 do
		vectorNaoObjetivo[i] = naoObjetivo[math.random(1,4)]
	end

	customVectorOfImage = {}
	vectorAux = {}
	vectorGeral = {vectorObjetivo1, vectorObjetivo2, vectorNaoObjetivo}
	for i=1,( #vectorObjetivo1 + #vectorObjetivo2 + #vectorNaoObjetivo ) do
		print("iteração: " .. i)
		--pegando a posição aleatória do array de acordo com seu tamanho
		limite = #vectorGeral
		print(limite)
		positionOfArray = math.random( 1, limite )

		--criando vetor auxiliar para receber um dos vetores de imagens
		--de acordo com a posição escolhida aleatoriamente
		vectorAux = vectorGeral[ positionOfArray ]

		--pegando tamanho do vetor auxiliar
		--com isto será possível decrementar o vetor de imagens a cada iteração
		vectorSize = table.getn( vectorAux )

		--se for 1, significa que estão acabando as imagens para serem usadas dentro
		--deste vetor
		if ( vectorSize > 1 ) then
		--print("colocando imagem " .. vectorAux[ vectorSize ] .. " dentro de customVectorOfImage")

			--colocando imagem dentro do vetor
			--para posteriormente serem jogadas na tela
			customVectorOfImage[i] = vectorAux[ vectorSize ]

			--decrementando o vetor
			vectorAux[ vectorSize ] = nil

		--em caso de tamanho 1, será necessário decrementar o vetor geral pois este vetor
		--não será mais usado
		elseif ( vectorSize == 1 ) then
			--print("colocando imagem " .. vectorAux[ vectorSize ] .. " pela última vez dentro de customVectorOfImage")

			--colocando imagem deste vetor pela última vez dentro do vetor customizado
			customVectorOfImage[i] = vectorAux[ vectorSize ]

			--decrementando o vetor para nunca mais ser usado
			vectorAux[ vectorSize ] = nil

			--print("O vetor está zerado")

			--decrementando o vetor geral
			vectorGeral[positionOfArray] = nil

			--criando vetor auxiliar para ATUALIZAR o vetor geral após a decrementação
			vectorGeralAux = {}


			iterador = 0
			for j=1,3 do

				--caçando valore não nulos para colocar no nosso vetor geral
				if (vectorGeral[j] ~= nil) then
					iterador = iterador + 1

					vectorGeralAux[iterador] = vectorGeral[j]

					--print("Colocando vetor não vazio dentro do vetor auxiliar")
					
				end
			end

			--print("Vetor geral atualizado")

			vectorGeral = vectorGeralAux
		end
	end
	
	--criando o chão
	local floor = display.newImageRect( "img/screenComponents/floor.png", screenW, screenH * 0.1 )
	floor.name = "floor"
	floor.anchorX = 0
	floor.anchorY = 1
	floor.x, floor.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	physics.addBody( floor, "static", { friction=0.3} )
	
	local floorShape = {  -floor.width/2,-floor.height/2, floor.width/2,-floor.height/2, floor.width/2,floor.height/2, -floor.width/2,floor.height/2 }
	physics.addBody( floor, "static", { friction=0.3, shape=floorShape } )

	--criando o botão que representará a pontuação

	pontuacao = widget.newButton({
		defaultFile="img/buttons/oval.png",
		width=50, height=50,
		labelColor = {default={ 1, 1, 1 }}
		})
	pontuacao.x = floor.x + 30
	pontuacao.y = marginTop
	pontuacao:setLabel("0")

	--ESPAÇO PARA VISUALIZAR PROGRESSO
	local space = display.newRoundedRect( floor.x + screenW/2, marginTop, screenW - 10, 50, 25)
	space:toFront()

	--criando a lata de lixo
	local garbage_default = display.newImageRect( "img/screenComponents/recycle-y.png", 90, 90 )
	garbage_default.x, garbage_default.y = display.contentCenterX, floor.y - floor.height - 45
	garbage_default.name = "lata"
	garbage_default.id = METAL

	--criando formas que vão ser adicionadas a lata de lixo
	--e vão dar a sensação de que os objetos caem dentro dela
	local shapeCollision = { 30,35,30,40,-30,40,-30,35}
	
	local shapeBottonGarbage = {45,40,45,45,-45,45,-45,40}
	local shapeRightGarbage = {45,-45,45,40,40,40,40,-45}
	local shapeLeftGarbage = {-40,-45,-40,40,-45,40,-45,-45}

	physics.addBody( garbage_default, "static",  { shape = shapeCollision }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage }, { shape = shapeBottonGarbage})

	local function onLocalCollision( self, event )
	
		event.target:toFront()

		if ( event.phase == "began" and isValidScore == true ) then
			if ( event.target.name == "floor" ) then
				event.other:removeSelf()
				score = score - 1
				pontuacao:setLabel(score)
    		else
    			--print( "Lata de " ..  event.target.id .. " coletou um " .. event.other.id )
				if( event.selfElement == 1 ) then
					if ( event.target.id == event.other.id ) then
						--print( "Bom trabalho!" )
						if ( event.other.name == objetivo1[1] or event.other.name == objetivo2[1] ) then
							score = score + 2
							if (event.other.name == objetivo1[1] and objetivo1[3] <= objetivo1[2] ) then
								objetivo1[3] = objetivo1[3] + 1
								buttonObjetivo1:setLabel( objetivo1[3] .. "/" .. objetivo1[2] )
							elseif ( event.other.name == objetivo2[1] and objetivo2[3] <= objetivo2[2] ) then
								objetivo2[3] = objetivo2[3] + 1
								buttonObjetivo2:setLabel( objetivo2[3] .. "/" .. objetivo2[2] )
							end
						else
							score = score + 1
						end
					else
						score = score - 2
					end
					pontuacao:setLabel(score)
					event.other:removeSelf()
				end
			end
		elseif ( event.phase == "ended" ) then
		end
	end
	
	local function onGarbageCollision( self, event )
		print( "" ..event.selfElement )
	end

	floor.collision = onLocalCollision
	floor:addEventListener("collision")

	garbage_default.collision = onLocalCollision
	garbage_default:addEventListener("collision")

	local function onGlobalCollision( event )

	    if ( event.phase == "began" ) then
	        print( "began: " )

	    elseif ( event.phase == "ended" ) then
	        print( "ended: " )
	    end
	end

	--Runtime:addEventListener( "collision", onGlobalCollision )

	--função que permite mover a lata de lixo pela tela
	function garbage_default:touch( event )

	    if event.phase == "began" then
		
	        self.markX = self.x
	        --self.markY = self.y
		
	    elseif event.phase == "moved" then
		
	        local x = (event.x - event.xStart) + self.markX
	        --local y = (event.y - event.yStart) + self.markY
	        
	        self.x = x
	        self.y = y
	    end
	    
	    return true
	end

	function floor:touch( event )

		if event.phase == "began" then
			targetxStart = garbage_default.x
			xStart = event.xStart
	    	--print("inicio: "..event.xStart)
	    elseif event.phase == "moved" then
	    	--print("progresso: "..event.x)

	    	xDiff = event.x - xStart
	    	--print("difernça: "..xDiff)

	    	if ( xDiff < 0 ) then
	    		--print("Movendo para a direita")
    		elseif ( xDiff >= 0 ) then
	    		--print("Movendo para a esquerda")
			end
	    	garbage_default.x = targetxStart + xDiff

    	elseif event.phase == "cancelled" then

	    end
		return true
	end
	
	garbage_default:addEventListener( "touch", floor )
	--floor:addEventListener( "touch", floor )
	
	--inserindo objetos na tela
	sceneGroup:insert( background )
	sceneGroup:insert( floor)

	--inserindo objetos na tela com base no tempo
	local time = 2000
	local iterations = 0;
	local currentTimer = nil;

	local function createObjectsWithDelay()
      	iterations = iterations + 1

      	image = customVectorOfImage[iterations]

      	imagePath = "img/objects/" .. image .. ".png"

      	local object = display.newImageRect( imagePath, 45, 45 )
      	object.name = image
		object:toBack()

      	if image == "rolo de papel" then
      		object.id = PAPEL
  		elseif image == "cerveja" or image == "champagne" then
  			object.id = VIDRO
		elseif image == "copo de plástico" or image == "copo de café" then
			object.id = PLASTICO
		elseif image == "talheres" then
			object.id = METAL
  		end

      	--os objetos estão sendo inseridos em lugares aleatórios da tela
		object.x, object.y = math.random(object.width/2, display.actualContentWidth - object.width/2), -45
		--aumentando a gravidade gradativamente
		physics.setGravity(0, 2 + iterations*0,2)
		physics.addBody( object, { density=9.0, friction=1.0, bounce=0.3 } )
		object:toBack()
		sceneGroup:insert( object )
		sceneGroup:insert( space )

		if ( objetivo1[3] >= objetivo1[2] and objetivo2[3] >= objetivo2[2] ) then
			native.showAlert("Parabéns!!!! Você ganhou com ".. score .. " pontos!!!", "Você coletou " .. objetivo1[3] .. " " .. objetivo1[1] .. " e " .. objetivo2[3] .. " " .. objetivo2[1], {"Próxima fase >"}, nil)
			isValidScore = false
		elseif (iterations < #customVectorOfImage) then
			currentTimer = timer.performWithDelay(time, createObjectsWithDelay);
		else
			native.showAlert("Você perdeu com ".. score .. " pontos.", "Você coletou " .. objetivo1[3] .. " " .. objetivo1[1] .. " e " .. objetivo2[3] .. " " .. objetivo2[1], {"Tentar novamente"})
			isValidScore = false
		end
	end
	--variávei usáveis
	local buttonWidth = floor.width/4
	local buttonHeight = floor.height/1.35

	--ESCUTANDO CLIQUE DOS BOTÕES DE MUDANÇA DE COR DA LATA
	local function handleButtonEvent( event )
		x, y = garbage_default.x, garbage_default.y
		garbage_default:removeSelf()
		
	    if ( "ended" == event.phase ) then
	        if( event.target.id == VIDRO )then
				print( "mudar para " .. event.target.id )
				garbage_default = display.newImageRect( "img/screenComponents/recycle-g.png", 90, 90  )
				garbage_default.id = VIDRO
			elseif ( event.target.id == METAL )then
				print( "mudar para " .. event.target.id )
				garbage_default = display.newImageRect( "img/screenComponents/recycle-y.png", 90, 90  )
				garbage_default.id = METAL
			
			elseif ( event.target.id == PAPEL )then
				print( "mudar para " .. event.target.id )
				garbage_default = display.newImageRect( "img/screenComponents/recycle-b.png", 90, 90  )
				garbage_default.id = PAPEL
			
			elseif ( event.target.id == PLASTICO )then
				print( "mudar para " .. event.target.id )
				garbage_default = display.newImageRect( "img/screenComponents/recycle-r.png", 90, 90  )
				garbage_default.id = PLASTICO
			
			end
	    end
		
		garbage_default.x, garbage_default.y = x, y
		
		garbage_default.collision = onLocalCollision
		garbage_default:toFront()
		garbage_default:addEventListener("collision")
		garbage_default:addEventListener( "touch", floor )

		physics.addBody( garbage_default, "static", { shape = shapeCollision }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage }, { shape = shapeBottonGarbage })
	    sceneGroup:insert( garbage_default )
	end

	function initLevel()
		currentTimer = timer.performWithDelay(time, createObjectsWithDelay);
	end

	native.showAlert("Bem-vindo ao nível 1",
					"Você precisará coletar " .. objetivo1[2] .. " rolos de papel e " .. objetivo2[2] .. " " .. objetivo2[1] .. "s",
					{"Vamos coletar"}, initLevel)

	--BOTÕES DE MUDANÇA DE COR DA LATA
	local buttonChangeColor1 = widget.newButton({
		defaultFile="img/buttons/oval-y.png",
		overFile="img/buttons/button-yellow-metal-pressed.png",
		width=buttonHeight, height=buttonHeight,
		onEvent = handleButtonEvent
	})
	buttonChangeColor1.x = floor.x + buttonWidth*0.5
	buttonChangeColor1.y = floor.y - floor.height*0.75 + 10
	buttonChangeColor1.id = METAL

	local buttonChangeColor2 = widget.newButton({
		defaultFile="img/buttons/oval-r.png",
		overFile="img/buttons/button-red-plastico-pressed.png",
		width=buttonHeight, height=buttonHeight,
		onEvent = handleButtonEvent
	})
	buttonChangeColor2.x = floor.x + buttonWidth*1.5
	buttonChangeColor2.y = floor.y - floor.height*0.75 + 10
	buttonChangeColor2.id = PLASTICO

	local buttonChangeColor3 = widget.newButton({
		defaultFile="img/buttons/oval-b.png",
		overFile="img/buttons/button-blue-papel-pressed.png",
		width=buttonHeight, height=buttonHeight,
		onEvent = handleButtonEvent
	})
	buttonChangeColor3.x = floor.x + buttonWidth*2.5
	buttonChangeColor3.y = floor.y - floor.height*0.75 + 10
	buttonChangeColor3.id = PAPEL

	local buttonChangeColor4 = widget.newButton({
		defaultFile="img/buttons/oval-g.png",
		overFile="img/buttons/button-green-vidro-pressed.png",
		width=buttonHeight, height=buttonHeight,
		onEvent = handleButtonEvent
	})
	buttonChangeColor4.x = floor.x + buttonWidth*3.5
	buttonChangeColor4.y = floor.y - floor.height*0.75 + 10
	buttonChangeColor4.id = VIDRO

	sceneGroup:insert( garbage_default )
	sceneGroup:insert(space)

	--BOTÕES COM OBJETIVO DE FASE
	buttonObjetivo1 = widget.newButton({
		defaultFile="img/objects/".. objetivo1[1] ..".png",
		width=30, height=30,
		onEvent = handleButtonEvent,
		labelColor = {default={ 0, 0, 0 }},
		labelXOffset = 30
	})
	buttonObjetivo1.x = floor.x + 100
	buttonObjetivo1.y = space.y
	buttonObjetivo1:setLabel(objetivo1[3] .. "/" .. objetivo1[2])

	buttonObjetivo2 = widget.newButton({
	defaultFile="img/objects/".. objetivo2[1] ..".png",
	width=30, height=30,
	onEvent = handleButtonEvent,
	labelColor = {default={ 0, 0, 0 }},
	labelXOffset = 30
	})
	buttonObjetivo2.x = buttonObjetivo1.x + 60
	buttonObjetivo2.y = space.y
	buttonObjetivo2:setLabel(objetivo2[3] .. "/" .. objetivo2[2])
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene