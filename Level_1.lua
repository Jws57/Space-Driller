

--hides the status bar
display.setStatusBar(display.HiddenStatusBar)

--set the default anchor or registration points
display.setDefault( "anchorX", 0.5)
display.setDefault( "anchorY", 0.5)

--make numbers truly random	
math.randomseed( os.time() )

local physics = require("physics")
physics.start()
physics.setScale(80)--Sets the speed of the falling objects

 w= display.contentWidth
 h= display.contentHeight
 

--star variable 
local numberOfStars=200
local starSpeed=5
local starGroup = display.newGroup()
local allStars={} -- Table that holds all the stars
 
 --playesr variables
 local playerWidth = 99
 local playerHeight = 154
 local numberOfLives = 3
 
 --Other objects variables
 local canFireLaser = true
 local playerLasers = {} -- Table that holds the players Lasers
 local FallingRocks = {} -- Table that holds the falling Rocks
 local StarsTimer={}
 local RocksTimer={}
 local CallCotrolsTimer={}
 local DificultyTimer={}
 local LifeText
 local ScoreText
 local totalScore=0
 local RockFallingSpeed=1200
 -- enemy variables 
 local Enemies = {}-- Table that holds the enemies
 local EnemyLasers={}
 local Enemiespeed = 5
 local SmallEnemyTimer={}
 local SmallEnemyMoveTimer={}
 local SmallEnemyLaserTimer={}
 local SmallEnemyLaserSpeed=1500
 
 
 --Walls
local roof
local leftWall
local rigthWall
local Floor

--buttons
local left 
local right 
 

 
local composer = require( "composer" )
 
local scene = composer.newScene()
 
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	setupPlayer()
	setupEnemies()
	CreateWalls()
	CreateStars()
	--CreateMoveButtons()
	CreateLifeAndPointText()
	
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
			StarsTimer=timer.performWithDelay(15,enterFrame,-1)
			
			Runtime:addEventListener("tap", firePlayerLaser)
			RocksTimer=timer.performWithDelay( RockFallingSpeed,  RockFall, -1)
			Runtime:addEventListener( "collision", onCollision )
			SmallEnemyTimer=timer.performWithDelay(15000,setupEnemies,-1)
			SmallEnemyMoveTimer=timer.performWithDelay(15,moveEnemies,-1)
			SmallEnemyLaserTimer=timer.performWithDelay(SmallEnemyLaserSpeed,fireEnemyLaser,-1)
			DificultyTimer=timer.performWithDelay(60000,IncreaseDificulty,-1)
			CallCotrolsTimer=timer.performWithDelay(30000,CallCotrols,-1)

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		
			Runtime:removeEventListener("tap", firePlayerLaser)
			timer.cancel(StarsTimer)
			timer.cancel(RocksTimer)
			timer.cancel(SmallEnemyTimer)
			timer.cancel(SmallEnemyMoveTimer)
			timer.cancel(SmallEnemyLaserTimer)
			timer.cancel(CallCotrolsTimer)
			timer.cancel(DificultyTimer)
			Runtime:removeEventListener( "collision", onCollision )
			
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
		
end



function CreateWalls()
	roof= display.newRect(w/2,-100,w,1)
	physics.addBody(roof,"static",{density =2.6,friction=5, bounce=0})
	scene.view:insert(roof)
	leftWall=display.newRect(-50,h/2,100,h+100)
	physics.addBody(leftWall,"static",{density =2.6,friction=5, bounce=0})
	scene.view:insert(leftWall)
	rigthWall=display.newRect(w+50,h/2,100,h+100)
	physics.addBody(rigthWall,"static",{density =2.6,friction=5, bounce=0})
	scene.view:insert(rigthWall)
	Floor= display.newRect(w/2,h,w,1)
	physics.addBody(Floor,"static",{density =2.6,friction=5, bounce=0})
	scene.view:insert(Floor)
end
 
 
 -- creates the text that indicates how may leves left
 function CreateLifeAndPointText()
 
	LifeText = display.newText("Lives:"..numberOfLives,150,h+70,"arial",70)
	LifeText:setFillColor(0,0,3)
	scene.view:insert(LifeText)

	
	ScoreText = display.newText("Score:"..totalScore,w-150,h+70,"arial",70)
	ScoreText:setFillColor(1,1,0)
	scene.view:insert(ScoreText)
 end
 
 function changeLifeText()
	LifeText.text="Lives:"..numberOfLives
 end

 function changeScoreText()
	ScoreText.text="Score:"..totalScore
 end
 ----star group of fuctions 
function CreateStars()
	--positions the stars randomly within the screen bounds and also give it a random size between 2 and 8
	for i=0, numberOfStars do
        local star = display.newCircle(math.random(display.contentWidth), math.random(display.contentHeight), math.random(2,8))
        star:setFillColor(1 ,1,1)
        starGroup:insert(star)
		scene.view:insert(star)
        table.insert(allStars,star)
    end
 end    
    
     
    
function enterFrame()
    moveStars()
   checkStarsOutOfBounds()
end
 
--moves the stars
function moveStars()
        for i=1, #allStars do
              allStars[i].y = allStars[i].y+starSpeed
        end
 
end

--recycles the stars to give the illusion of a never-ending stream of stars
function  checkStarsOutOfBounds()
    for i=1, #allStars do
        if(allStars[i].y > display.contentHeight) then
            allStars[i].x  = math.random(display.contentWidth)
            allStars[i].y = 0
        end
    end
end


--player group of fuction 
function setupPlayer()
    local options = { width = playerWidth,height = playerHeight,numFrames = 8}
    local playerSheet = graphics.newImageSheet( "player.png", options )
    local sequenceData = {
     {  start=1, count=8, time=300,   loopCount=0 }
    }
    player = display.newSprite( playerSheet, sequenceData )
    player.name = "player"
    player.x=display.contentCenterX- playerWidth /2 
    player.y = display.contentHeight - playerHeight - 10
    player:play()
    scene.view:insert(player)
    
    physics.addBody( player)
    player.gravityScale = 0
end

--Movis the SpaceShip when user moves the device 
local function onAccelerate(event)
    player.x = display.contentCenterX + (display.contentCenterX * (event.xGravity*2))
end
system.setAccelerometerInterval( 60 )
Runtime:addEventListener ("accelerometer", onAccelerate)




-- moves the ship right and left
local function movePlayer(event)
        if(event.target.name == "left") then
            player.x = player.x - 5
        elseif(event.target.name == "right") then
            player.x = player.x + 5
        end
 end
 
-- makes buttons that move the ship 
function CreateMoveButtons()	
	left = display.newRect(300,1100,100,100)
    left.name = "left"
    scene.view:insert(left)
    right = display.newRect(display.contentWidth-300,1100,100,100)
    right.name = "right"
    scene.view:insert(right)
    left:addEventListener("touch", movePlayer)
    right:addEventListener("touch", movePlayer)
end


function firePlayerLaser()
	--check if the user is able to fire a Laser so it does not fire infinitely
    if(canFireLaser == true)then 
        local tempLaser = display.newImage("laser.png", player.x, player.y - playerHeight/ 2)
        tempLaser.name = "playerLaser"
        tempLaser.xScale=tempLaser.xScale/2; tempLaser.yScale=tempLaser.yScale*3;
        physics.addBody(tempLaser, "dynamic" )
        tempLaser.gravityScale = 0 -- so it is not affected by gravity 
        tempLaser.isLaser = true--  continuous collision detection
        tempLaser.isSensor = true-- so it does not produce a physical response
        tempLaser:setLinearVelocity( 0,-400)-- so it moves  vertically
        table.insert(playerLasers,tempLaser)
        local laserSound = audio.loadSound( "laser.mp3" ) -- add laser sound
        local laserChannel = audio.play( laserSound )
        audio.dispose(laserChannel)
        canFireLaser = false
 
    else
        return
    end
	-- makes it so can fire lase again 
    local function enableLaserFire()
        canFireLaser = true
    end
    timer.performWithDelay(750-200,enableLaserFire,1)-- sets up the shooting speed
end


local function explode(target)

	local explosionTable = {
    sheetContentWidth = 12288,
    sheetContentHeight = 192,
    width = 12288/64,
    height = 192,
    numFrames = 64
    }
   
	local explosionSheet = graphics.newImageSheet( "explosion_sheet.png", explosionTable )

	local explosionSequenceTable = {
    {
    name = "explosion",
    start = 1,
    count = 64,
    time = 800,
    loopCount = 1,
    loopDirection = "forward"
    }
}

    local fireball = display.newSprite( explosionSheet, explosionSequenceTable )
    local Object = target
    fireball.x = Object.x
    fireball.y = Object.y
    --fireball.xScale = 2
    --fireball.yScale = 2
    Object:removeSelf()
    fireball:setSequence('explosion')
   fireball:play()
   
   local ExplosionSound = audio.loadSound( "Explosion.mp3" ) -- add Explosion sound
        local ExplosionChannel = audio.play( ExplosionSound )
        audio.dispose(ExplosionChannel)
		
  transition.to( fireball, {alpha=0, delay=10} )
end


-- Function variable to show the falling objects
 function RockFall()
 
			
	Rock = display.newImage( "asteroid.png" )
	Rock.name = "Rock"
	scene.view:insert(Rock)
			-- Randomly set the start position of each Rock
	Rock.x = 1 + math.random( 600); Rock.y = -20
			-- Add the drop object
	physics.addBody(  Rock )
	Rock.isBullet = true--  continuous collision detection
	Rock.isSensor = true-- so it does not produce a physical response
	table.insert(FallingRocks,Rock)
	--Rock:addEventListener("collision", explode)
	
end

function onCollision(event)
      		
      if ( event.phase == "began" ) then
			
	
		-------------------------------------------
		--player vs rock--
		if(event.object1.name == "player" and event.object2.name == "Rock") then
			explode(event.object2)
			killPlayer()
            table.remove(FallingRocks,table.indexOf(FallingRocks,event.object2))
            event.object2:removeSelf()
            event.object2 = nil
            if(playerIsInvincible == false) then
              killPlayer()
            end
            return
        end
         
		 --player vs rock--
        if(event.object1.name == "Rock" and event.object2.name == "player") then
			explode(event.object1)
			killPlayer()
          table.remove(FallingRocks,table.indexOf(FallingRocks,event.object1))
            event.object1:removeSelf()
            event.object1 = nil
            if(playerIsInvincible == false) then
                killPlayer()
            end
            return
        end
		
		--laser vs rock--
		if(event.object1.name == "playerLaser" and event.object2.name == "Rock") then
		
			totalScore=totalScore+1;
			changeScoreText()
			explode(event.object2)
            table.remove(FallingRocks,table.indexOf(FallingRocks,event.object2))
            event.object2:removeSelf()
            event.object2 = nil
            
            return
        end
		
		--laser vs rock--
		if(event.object1.name == "Rock" and event.object2.name == "playerLaser") then
		
			totalScore=totalScore+1;
			changeScoreText()
			explode(event.object1)
            table.remove(FallingRocks,table.indexOf(FallingRocks,event.object1))
            event.object1:removeSelf()
            event.object1 = nil
            
            return
        end
         
		 --Player vs enemy laser 
        if(event.object1.name == "EnemyLaser" and event.object2.name == "player") then
			explode(event.object1)
          table.remove(EnemyLasers,table.indexOf(EnemyLasers,event.object1))
            event.object1:removeSelf()
            event.object1 = nil
            
            return
        end
		--Player vs enemy laser --
		if(event.object1.name == "player" and event.object2.name == "EnemyLaser") then
			explode(event.object2)
			killPlayer()
            table.remove(EnemyLasers,table.indexOf(EnemyLasers,event.object2))
            event.object2:removeSelf()
            event.object2 = nil
            if(playerIsInvincible == false) then
              killPlayer()
            end
            return
        end
		
		--laser vs enemy--
		if(event.object1.name == "playerLaser" and event.object2.name == "Enemy") then
			explode(event.object2)
            table.remove(Enemies,table.indexOf(Enemies,event.object2))
            event.object2:removeSelf()
            event.object2 = nil
			
            numberOfLives=numberOfLives+1
			changeLifeText()
			
			totalScore=totalScore+5;
			changeScoreText()
			
            return
        end
		--laser vs enemy--
		if(event.object1.name == "Enemy" and event.object2.name == "playerLaser") then
			explode(event.object1)
          table.remove(Enemies,table.indexOf(Enemies,event.object1))
            event.object1:removeSelf()
            event.object1 = nil
			
            numberOfLives=numberOfLives+1
			changeLifeText()
			
			totalScore=totalScore+5;
			changeScoreText()
            return
        end
		----------------------------------------
		
		
        
    end
end 



function setupEnemies()
            local tempEnemy = display.newImage("Enemy1.png",w/2, 0)
          tempEnemy.xScale=tempEnemy.xScale*4; tempEnemy.yScale=tempEnemy.yScale*4;
			tempEnemy.name = "Enemy"
			scene.view:insert(tempEnemy)
            physics.addBody(tempEnemy)
            tempEnemy.gravityScale = 0
            tempEnemy.isSensor = true
            
            table.insert(Enemies,tempEnemy)
end


function moveEnemies()
    local changeDirection = false
    for i=1, #Enemies do
          Enemies[i].x = Enemies[i].x + Enemiespeed
        if(Enemies[i].x > w-20 or Enemies[i].x < 20) then
            changeDirection = true;
        end
     end
    if(changeDirection == true)then
        Enemiespeed = Enemiespeed*-1
        for j = 1, #Enemies do
            Enemies[j].y = Enemies[j].y+ 46
        end
        changeDirection = false;
    end 
end


function killPlayer()
    numberOfLives = numberOfLives- 1;
	
	changeLifeText()
      if(numberOfLives <= 0) then
        
		
		
			setscorestring("MaxScore",totalScore)
			
			explode(player)
			composer.gotoScene("GameOver")
    else
        playerIsInvincible = true
		spawnNewPlayer()
    end
end

function spawnNewPlayer()
    local numberOfTimesToFadePlayer = 5
    local numberOfTimesPlayerHasFaded = 0
    
        player.alpha = 0;
        transition.to( player, {time=400, alpha=1,  })
        numberOfTimesPlayerHasFaded = numberOfTimesPlayerHasFaded + 1
        if(numberOfTimesPlayerHasFaded == numberOfTimesToFadePlayer) then
            playerIsInvincible = false
        end

end

function setScores(name,value)   
    sql="DELETE FROM scores WHERE name='"..name.."';";
    db:exec( sql )
    
    sql="INSERT INTO scores (name,value) VALUES ('"..name.."',"..value..");";
    db:exec( sql )    
end

function setscorestring(name,value)
    setScores(name,"'"..value.."'");
end


function fireEnemyLaser()
    if(#Enemies >0) then
        local randomIndex = math.random(#Enemies)
        local randomEnemy = Enemies[randomIndex]
        local tempEnemyLaser = display.newImage("images/laserRed.png", randomEnemy.x , randomEnemy.y + 80)
        tempEnemyLaser.xScale=tempEnemyLaser.xScale/2; tempEnemyLaser.yScale=tempEnemyLaser.yScale*3;
		
		tempEnemyLaser.name = "EnemyLaser"
        scene.view:insert(tempEnemyLaser)
        physics.addBody(tempEnemyLaser, "dynamic" )
        tempEnemyLaser.gravityScale = 0
        tempEnemyLaser.isBullet = true
        tempEnemyLaser.isSensor = true
        tempEnemyLaser:setLinearVelocity( 0,400)
        table.insert(EnemyLasers, tempEnemyLaser)
    end
end

-- increases dificulty of the game 
function IncreaseDificulty()
	if(RockFallingSpeed>700) then
	RockFallingSpeed=RockFallingSpeed-20
	RocksTimer=timer.performWithDelay( RockFallingSpeed,  RockFall, -1)
	end
	if(SmallEnemyLaserSpeed>700) then
	
	SmallEnemyLaserTimer=timer.performWithDelay(SmallEnemyLaserSpeed,fireEnemyLaser,-1)
	end
 end


function checkPlayerLasersOutOfBounds()
  if(#playerLasers > 0)then
        for i=#playerLasers,1,-1 do
		if(playerLasers[i] == nil) then
				if(playerLasers[i].y < 0) then
					playerLasers[i]:removeSelf()
					playerLasers[i] = nil
					table.remove(playerLasers,i)
				end
			end
        end
    end
end

function checkRockOfBounds()
  if(#FallingRocks > 0)then
        for i=#FallingRocks,1,-1 do
		if(FallingRocks[i] == nil) then
				if(FallingRocks[i].y < 0) then
					FallingRocks[i]:removeSelf()
					FallingRocks[i] = nil
					table.remove(FallingRocks,i)
				end
			end
        end
    end
end


function checkEnemiesOutOfBounds()
  if(#Enemies > 0)then
        for i=#Enemies,1,-1 do
		if(Enemies[i] == nil) then
				if(Enemies[i].y < 0) then
					Enemies[i]:removeSelf()
					Enemies[i] = nil
					table.remove(Enemies,i)
				end
			end
        end
    end
end

function checkEnemyLasersOutOfBounds()
    if (#EnemyLasers > 0) then
        for i=#EnemyLasers,1,-1 do
            if(EnemyLasers[i].y > display.contentHeight) then
                EnemyLasers[i]:removeSelf()
                EnemyLasers[i] = nil
                table.remove(EnemyLasers,i)
            end
        end
    end
end

function CallCotrols()
	
	checkEnemiesOutOfBounds()
	checkRockOfBounds()
    checkPlayerLasersOutOfBounds()
	checkEnemyLasersOutOfBounds() 
end





scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene