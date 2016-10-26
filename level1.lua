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

--------------------------------------------

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local VIDRO, PAPEL, METAL, PLASTICO = "vidro", "papel", "metal", "plastico"

function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setDrawMode( "" )

	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

	--criando a parede esquerda e direita
	--local wallLeft = display.newRect( 0,0,100,screenH )
	--wallLeft.anchorX, wallLeft.anchorY = 0,0
	--physics.addBody( wallLeft, "static", { friction = 10 } )
	--local wallRight = display.newRect( screenW, screenH/2, 1, screenH )
	--physics.addBody( wallRight, "static" )

	randomVectorOfImage = {"champagne","coffee-cup","cutlery", "plastic-cup"}
	customVectorOfImage = {}

	--criando o texto que representará a pontuação
	local potuacao = display.newEmbossedText( "0", screenW/2, 0, 95, 95, native.systemFont, 40 )

	--criando um vetor com as imagens (path das imagens) que vão aparecer na tela
	for i=1,100 do

		if i<7 then
			--a fase terá 6 bananas
			customVectorOfImage[i] = "writer"
		elseif i >= 7 and i < 15 then
			--a fase terá 9 cervejas
			customVectorOfImage[i] = "beer"
		else
			--colocando de forma aleatória
			customVectorOfImage[i] = randomVectorOfImage[math.random(1,4)]
		end
	end
	
	--criando o chão
	local floor = display.newImageRect( "img/screenComponents/floor.png", screenW, screenH * 0.2 )
	floor.name = "floor"
	floor.anchorX = 0
	floor.anchorY = 1
	floor.x, floor.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY

	--variávei usáveis
	local buttonWidth = floor.width/4
	local buttonHeight = floor.height/2

	--BOTÕES DE MUDANÇA DE COR DA LATA
	local buttonChangeColor1 = widget.newButton({
		defaultFile="img/buttons/oval.png",
		overFile="img/buttons/oval-pressed.png",
		width=buttonHeight, height=buttonHeight
	})
	buttonChangeColor1.x = floor.x + buttonWidth*0.5
	buttonChangeColor1.y = floor.y - floor.height*0.75
	buttonChangeColor1.id = METAL

	local buttonChangeColor2 = widget.newButton({
		defaultFile="img/buttons/oval.png",
		overFile="img/buttons/oval-pressed.png",
		width=buttonHeight, height=buttonHeight
	})
	buttonChangeColor2.x = floor.x + buttonWidth*1.5
	buttonChangeColor2.y = floor.y - floor.height*0.75
	buttonChangeColor2.id = PLASTICO

	local buttonChangeColor3 = widget.newButton({
		defaultFile="img/buttons/oval.png",
		overFile="img/buttons/oval-pressed.png",
		width=buttonHeight, height=buttonHeight
	})
	buttonChangeColor3.x = floor.x + buttonWidth*2.5
	buttonChangeColor3.y = floor.y - floor.height*0.75
	buttonChangeColor3.id = PAPEL

	local buttonChangeColor4 = widget.newButton({
		defaultFile="img/buttons/oval.png",
		overFile="img/buttons/oval-pressed.png",
		width=buttonHeight, height=buttonHeight
	})
	buttonChangeColor4.x = floor.x + buttonWidth*3.5
	buttonChangeColor4.y = floor.y - floor.height*0.75
	buttonChangeColor4.id = VIDRO

	--ESCUTANDO CLIQUE DOS BOTÕES DE MUDANÇA DE COR DA LATA
	local function handleButtonEvent( event )
	        print( "..............." )

	    if ( "ended" == event.phase ) then
	        print( "..............." )
	    end

	    return true
	end
	
	local floorShape = {  -floor.width/2,-floor.height/2, floor.width/2,-floor.height/2, floor.width/2,floor.height/2, -floor.width/2,floor.height/2 }
	physics.addBody( floor, "static", { friction=0.3, shape=floorShape } )

	--criando a lata de lixo
	local garbage_default = display.newImageRect( "img/screenComponents/recycle_yellow.png", 90, 90 )
	garbage_default.x, garbage_default.y = display.contentCenterX, screenH - floor.height - 90
	garbage_default.name = "lata"
	garbage_default.id = METAL

	--criando formas que vão ser adicionadas a lata de lixo
	--e vão dar a sensação de que os objetos caem dentro dela
	local shapeCollision = { 30,35,30,40,-30,40,-30,35}
	
	local shapeBottonGarbage = {45,40,45,45,-45,45,-45,40}
	local shapeRightGarbage = {45,-45,45,40,40,40,40,-45}
	local shapeLeftGarbage = {-40,-45,-40,40,-45,40,-45,-45}

	physics.addBody( garbage_default, "static",  { shape = shapeCollision }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage }, { shape = shapeBottonGarbage})

	local score = 0;

	local function onLocalCollision( self, event )
	
		event.target:toFront()

		if ( event.phase == "began" ) then
			if ( event.target.name == "floor" ) then
				event.other:removeSelf()
				score = score - 1
				potuacao:setText(score)
    		else
    			print( "Lata de " ..  event.target.id .. " coletou um " .. event.other.id )
				if( event.selfElement == 1 ) then
					if ( event.target.id == event.other.id ) then
						print( "Bom trabalho!" )
						if ( event.other.name == "writer" or event.other.name == "beer" ) then
							score = score + 2
						else
							score = score + 1
						end
					else
						score = score - 2
					end
					potuacao:setText(score)
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
	        self.markY = self.y
		
	    elseif event.phase == "moved" then
		
	        local x = (event.x - event.xStart) + self.markX
	        local y = (event.y - event.yStart) + self.markY
	        
	        self.x, self.y = x, y
	    end
	    
	    return true
	end

	i = 0

	local function myTapListener( event )
		x, y = garbage_default.x, garbage_default.y
		garbage_default:removeSelf()

		i = i + 1

		if ( i == 1) then
			garbage_default = display.newImageRect( "img/screenComponents/recycle_green.png", 90, 90  )
			garbage_default.id = VIDRO
		elseif ( i == 2 ) then
			garbage_default = display.newImageRect( "img/screenComponents/recycle_red.png", 90, 90  )
			garbage_default.id = PLASTICO
		elseif ( i == 3 ) then
			garbage_default = display.newImageRect( "img/screenComponents/recycle_blue.png", 90, 90  )
			garbage_default.id = PAPEL
		elseif ( i == 4 ) then
			garbage_default = display.newImageRect( "img/screenComponents/recycle_yellow.png", 90, 90  )
			garbage_default.id = METAL
			i = 0
		end
		garbage_default.x, garbage_default.y = x, y
		
		garbage_default.collision = onLocalCollision
		garbage_default:toFront()
		garbage_default:addEventListener("collision")

		physics.addBody( garbage_default, "static", { shape = shapeCollision }, { shape = shapeRightGarbage  }, { shape = shapeLeftGarbage }, { shape = shapeBottonGarbage })
	    sceneGroup:insert( garbage_default )
	    return true
	end
	
	function floor:touch( event )

		if event.phase == "began" then
			targetxStart = garbage_default.x
			xStart = event.xStart
	    	print("inicio: "..event.xStart)
	    elseif event.phase == "moved" then
	    	print("progresso: "..event.x)

	    	xDiff = event.x - xStart
	    	print("difernça: "..xDiff)

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
	
	floor:addEventListener( "touch", floor )
	--floor:addEventListener( "tap", myTapListener )
	
	--inserindo objetos na tela
	sceneGroup:insert( background )
	sceneGroup:insert( floor)

	--inserindo objetos na tela com base no tempo
	local time = 1000
	local iterations = 0;
	local currentTimer = nil;

	local function createObjectsWithDelay()
      	iterations = iterations + 1

      	image = customVectorOfImage[iterations]

      	imagePath = "img/objects/" .. image .. ".png"

      	local object = display.newImageRect( imagePath, 45, 45 )
      	object.name = image
		object:toBack()

      	if image == "writer" then
      		object.id = PAPEL
  		elseif image == "beer" or image == "champagne" then
  			object.id = VIDRO
		elseif image == "plastic-cup" or image == "coffee-cup" then
			object.id = PLASTICO
		elseif image == "cutlery" then
			object.id = METAL
  		end

      	--os objetos estão sendo inseridos em lugares aleatórios da tela
		object.x, object.y = math.random(object.width/2, display.actualContentWidth - object.width/2), -100
		--aumentando a gravidade gradativamente
		physics.setGravity(0,5 + iterations*0.2)
		physics.addBody( object, { density=9.0, friction=1.0, bounce=0.3 } )
		sceneGroup:insert( object )

      	if (iterations < 15) then
           currentTimer = timer.performWithDelay(time, createObjectsWithDelay);
      	end
	end

	currentTimer = timer.performWithDelay(time, createObjectsWithDelay);

	sceneGroup:insert( garbage_default )
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