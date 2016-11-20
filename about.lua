-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- include Corona's "widget" library
local widget = require "widget"

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local menuSound = audio.loadSound( "audio/menu.mp3")
--audio.play(menuSound, { loops = -1 })


function scene:create( event )
	local sceneGroup = self.view

	physics.start()
	physics.pause()
	physics.setDrawMode( "normal" )

	local background = display.newImageRect( "img/menuComponents/superbackground.png", screenW, screenH * 2 )
	background.x, background.y = display.screenOriginX, display.screenOriginY
	background.anchorX = 0
	
	sceneGroup:insert( background )

	iteradorsuperbackground = 0

	local function superbackgroundAnimation()

		iteradorsuperbackground = iteradorsuperbackground + 5

	 	background.y = background.y + 5
		--print("iteradorsuperbackground="..iteradorsuperbackground..", img.y="..background.y)
		if (iteradorsuperbackground < screenH) then
			timer.performWithDelay(1, superbackgroundAnimation);
		end
	end

	superbackgroundAnimation()

	proporcaoDistancia = ( screenH - 100 )/6
	margemDireita = 50
	margemDireitaEntreObjetos = 100

	local papel = widget.newButton({
		defaultFile="img/buttons/oval-b.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	papel.x = margemDireita
	papel.y = 70
	papel:setLabel("Papel")

	roloDePapel = display.newImageRect( "img/objects/rolos de papel.png", 30, 30 )
	roloDePapel.x, roloDePapel.y = papel.x + margemDireitaEntreObjetos, papel.y

	blocoDeNotas = display.newImageRect( "img/objects/blocos de notas.png", 30, 30 )
	blocoDeNotas.x, blocoDeNotas.y = roloDePapel.x + margemDireitaEntreObjetos, papel.y

	local plastico = widget.newButton({
		defaultFile="img/buttons/oval-r.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	plastico.x = margemDireita
	plastico.y = papel.y + proporcaoDistancia
	plastico:setLabel("Plástico")

	copoDeCafe = display.newImageRect( "img/objects/copos de café.png", 30, 30 )
	copoDeCafe.x, copoDeCafe.y = plastico.x + margemDireitaEntreObjetos, plastico.y

	coposDePlastico = display.newImageRect( "img/objects/copos de plástico.png", 30, 30 )
	coposDePlastico.x, coposDePlastico.y = copoDeCafe.x + margemDireitaEntreObjetos, plastico.y

	local vidro = widget.newButton({
		defaultFile="img/buttons/oval-g.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	vidro.x = margemDireita
	vidro.y = plastico.y + proporcaoDistancia
	vidro:setLabel("Vidro")

	cerveja = display.newImageRect( "img/objects/cervejas.png", 30, 30 )
	cerveja.x, cerveja.y = vidro.x + margemDireitaEntreObjetos, vidro.y

	champagne = display.newImageRect( "img/objects/champagnes.png", 30, 30 )
	champagne.x, champagne.y = cerveja.x + margemDireitaEntreObjetos, vidro.y

	local metal = widget.newButton({
		defaultFile="img/buttons/oval-y.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	metal.x = margemDireita
	metal.y = vidro.y + proporcaoDistancia
	metal:setLabel("Metal")

	talher = display.newImageRect( "img/objects/talheres.png", 30, 30 )
	talher.x, talher.y = metal.x + margemDireitaEntreObjetos, metal.y

	local organico = widget.newButton({
		defaultFile="img/buttons/oval-br.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	organico.x = margemDireita
	organico.y = metal.y + proporcaoDistancia
	organico:setLabel("Oragânico")

	pizza = display.newImageRect( "img/objects/pizzas.png", 30, 30 )
	pizza.x, pizza.y = organico.x + margemDireitaEntreObjetos, organico.y

	cascaDeBanana = display.newImageRect( "img/objects/cascas de banana.png", 30, 30 )
	cascaDeBanana.x, cascaDeBanana.y = pizza.x + margemDireitaEntreObjetos, organico.y

	local madeira = widget.newButton({
		defaultFile="img/buttons/oval-bl.png",
		width=50, height=50,
		onEvent = onPlayBtnRelease,
		labelColor = {default={ 1, 1, 1 }},
		labelYOffset = -35
	})
	madeira.x = margemDireita
	madeira.y = organico.y + proporcaoDistancia
	madeira:setLabel("Madeira")

	lapis = display.newImageRect( "img/objects/lápis.png", 30, 30 )
	lapis.x, lapis.y = madeira.x + margemDireitaEntreObjetos, madeira.y
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

	end	
end

function scene:hide( event )
	print("menu:hide()")
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then 

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	print("menu:destroy()")
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene