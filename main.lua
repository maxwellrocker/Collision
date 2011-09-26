--start physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("debug")

local game = display.newGroup();
game.x = 0


--grass
local grassProperty = {friction=0.5, bounce=0.3}

local grass  = display.newImage("grass.png")
game:insert(grass)
grass.x = display.screenOriginX+480
grass.y = display.viewableContentHeight
physics.addBody(grass, "static", grassProperty)

--left and right board
local boardProperty = {friction=0.5, bounce=0.3}

local boardLeft  = display.newRect(0, 0, 20, 440)
game:insert(boardLeft)
boardLeft.x = display.screenOriginX-boardLeft.width*0.5
boardLeft.y = display.screenOriginY+boardLeft.height*0.5
boardLeft:setFillColor(0,0,0,0)
physics.addBody(boardLeft, "static", boardProperty)

local boardRight = display.newRect(0, 0, 20, 440)
game:insert(boardRight)
boardRight.x = display.screenOriginX+grass.width+boardRight.width*0.5
boardRight.y = display.screenOriginY+boardRight.height*0.5
boardRight:setFillColor(0,0,0,0)
physics.addBody(boardRight, "static", boardProperty)

--wall
castleBody = { density=4.0, friction=1, bounce=0.2 }
castleBodyHeavy = { density=12.0, friction=0.3, bounce=0.4 }

wall1 = display.newImage( "wall.png" )
game:insert( wall1 ); wall1.x = 632; wall1.y = 350
physics.addBody( wall1, castleBody )

wall2 = display.newImage( "wall.png" )
game:insert( wall2 ); wall2.x = 744; wall2.y = 350
physics.addBody( wall2, castleBody )

wall3 = display.newImage( "wall.png" )
game:insert( wall3 ); wall3.x = 856; wall3.y = 350
physics.addBody( wall3, castleBody )

roof = display.newImage( "roof.png" )
game:insert( roof ); roof.x = 684; roof.y = 292
physics.addBody( roof, castleBody )

roof2 = display.newImage( "roof.png" )
game:insert( roof2 ); roof2.x = 804; roof2.y = 292
physics.addBody( roof2, castleBody )

beam = display.newImage( "beam.png" )
game:insert( beam ); beam.x = 694; beam.y = 250
physics.addBody( beam, castleBodyHeavy )

beam2 = display.newImage( "beam.png" )
game:insert( beam2 ); beam2.x = 794; beam2.y = 250
physics.addBody( beam2, castleBodyHeavy )

roof3 = display.newImage( "roof.png" )
game:insert( roof3 ); roof3.x = 744; roof3.y = 210
physics.addBody( roof3, castleBody )

beam3 = display.newImage( "beam.png" )
game:insert( beam3 ); beam3.x = 744; beam3.y = 168
physics.addBody( beam3, castleBodyHeavy )


--power
local power = display.newText("50", 0, 0, native.systemFont, 20)
power.x = display.contentWidth*0.5
power.y = display.screenOriginY+30
power:setTextColor(255,255,255)
--scrollbar
local scrollbar = display.newImage("board.png")
scrollbar.x = display.contentWidth*0.5
scrollbar.y = display.screenOriginY+60
--button
local button = display.newRect(0,0,20,20)
button.x = scrollbar.x
button.y = scrollbar.y
button:setFillColor(0,0,255)
--fireBtn
local fireBtn = display.newImage("button.png")
fireBtn.x = display.contentWidth*0.5
fireBtn.y = display.screenOriginY+120
--
local reset = display.newText("RESET", 0, 0, native.systemFont, 16)
reset.x = 70
reset.y = fireBtn.y
reset:setTextColor(255,0,0)


--ball
local ballProperty = {density=15.0, friction=0.5, bounce=0.2, radius = 35}

local ball = display.newImage("soccer_ball.png")
game:insert(ball)
ball.x = display.screenOriginX+40
ball.y = display.screenOriginY+display.viewableContentHeight-80
physics.addBody(ball, "dynamic", ballProperty)

--ball:applyForce(20000,-20000,ball.x,ball.y)


--function
local POS_MIN = scrollbar.x-scrollbar.width*0.5
local POS_MAX = scrollbar.x+scrollbar.width*0.5
local pow = 50

function button:touch(event)
    local phase = event.phase
	if phase == "began" then
	elseif phase == "moved" then
		if event.x > POS_MAX then button.x = POS_MAX
		elseif event.x < POS_MIN then button.x = POS_MIN
		else button.x = event.x
		end
		
		pow = math.floor( (event.x-POS_MIN)*100 / (POS_MAX-POS_MIN) )
		if pow > 100 then pow=100
		elseif pow < 0 then pow=0
		end
		power.text = pow
	elseif phase == "ended" then
	end
end
button:addEventListener("touch", button)

local base = 300
function fireBtn:tap(event)
	ball:applyForce(base*pow,-base*pow,ball.x,ball.y)
	print("fire")
end
fireBtn:addEventListener("tap", fireBtn)

function reset:tap(event)
	ball:setLinearVelocity(0,0)
	ball.angularVelocity = 0
	
	game.x = 0
	ball.x = display.screenOriginX+40
	ball.y = display.screenOriginY+display.viewableContentHeight-80
end
reset:addEventListener("tap", reset)


--camera
local offset = 160
local function moveCamera()
	local limit = display.screenOriginX+grass.width-display.viewableContentWidth+offset-boardLeft.width
	if (ball.x > offset and ball.x < limit) then
		game.x = -ball.x + offset
	elseif ball.x >= limit then
		game.x = -limit + offset
	end
end
Runtime:addEventListener( "enterFrame", moveCamera )