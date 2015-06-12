
require("SystemConst")

local size = cc.Director:getInstance():getWinSize()
local frameCache = cc.SpriteFrameCache:getInstance()
local textureCache = cc.Director:getInstance():getTextureCache()

local numberOfLoadedSprites
local numberOfSprites
local labelPercent
local vec

local LoadingScene = class("LoaingScene", function()
	return cc.Scene:create()
end)

function LoadingScene.create()
	local scene = LoadingScene.new()
	scene:addChild(scene:createLayer())
	return scene
end

function LoadingScene:ctor()
	
end

function LoadingScene:createLayer()
	local layer = cc.Layer:create()

	frameCache:addSpriteFrames(Res.walk_texture_plist)

    local sprite = cc.Sprite:createWithSpriteFrameName("z0009.png")
	cclog("sprite = %s", sprite)
    layer:addChild(sprite, 1)
	sprite:setPosition(cc.p(size.width/2, size.height/2+100))
	
	local bg_sprite = cc.Sprite:create(Res.white_texture_res)
	layer:addChild(bg_sprite)
	local sprite_x, sprite_y = sprite:getPosition()	
    local bg_sprite_size = bg_sprite:getContentSize()
--    bg_sprite:setScale(size.width/bg_sprite_size.width+1, 
--        size.width/bg_sprite_size.height+2)
--    bg_sprite:setScale(1, 1)
--    cclog("scale  -------- %d, %d", size.width/bg_sprite_size.width+1, 
--        size.width/bg_sprite_size.height+1)
--    bg_sprite:setAnchorPoint(cc.p(0.5, 0.5))
--    bg_sprite:setPosition(cc.p(size.width/2, size.height/2))
    bg_sprite:setPosition(cc.p(sprite_x, sprite_y-60))
	
	local loadingAnimation = cc.Animation:create()
	for i=1,9 do 
		local frameName = string.format("z000%d.png", i)
		cclog("frameName = %s", frameName)
		local spriteFrame = frameCache:getSpriteFrame(frameName)
		loadingAnimation:addSpriteFrame(spriteFrame)
	end 

	loadingAnimation:setDelayPerUnit(0.1)
	loadingAnimation:setRestoreOriginalFrame(true)

	local loadingAction = cc.Animate:create(loadingAnimation)
	sprite:runAction(cc.RepeatForever:create(loadingAction))
	
	-- 百分比
    local function loadingCallBack(texture)
		numberOfLoadedSprites = numberOfLoadedSprites + 1
        -- 加载精灵帧缓存
        local row = vec[numberOfLoadedSprites]
        cclog("loadingCallBack=%d, %s", numberOfLoadedSprites, vec)
        local filename = Res.root .. row["filename"] .. ".plist"
        frameCache:addSpriteFrames(filename)

        -- 改变进度 
		local str = string.format("%d%%", (numberOfLoadedSprites / numberOfSprites)*100)
		labelPercent:setString(str)
		
		if numberOfSprites == numberOfLoadedSprites then 
		    local HomeScene = require("HomeScene")
		    local scene = HomeScene.create()
		    cc.Director:getInstance():replaceScene(scene)
		end 
	end
	
	labelPercent = cc.Label:createWithTTF("0%%", Res.market_ttf, 85)
	layer:addChild(labelPercent)
	labelPercent:setPosition(cc.p(sprite_x, sprite_y-120))
	labelPercent:setTextColor(cc.c4b(0, 0, 0, 125))
	
	local sharedFileUtils = cc.FileUtils:getInstance()
	local fullPathForFilename = sharedFileUtils:fullPathForFilename(Res.image_meta_data_plist)
	
	vec = sharedFileUtils:getValueVectorFromFile(fullPathForFilename)
	numberOfLoadedSprites = 0
	numberOfSprites = table.getn(vec)
	cclog("number = %d, %d", numberOfLoadedSprites, numberOfSprites)
	
	for i=1, numberOfSprites do 
	   local row = vec[i]
	   local filename =  Res.root .. row["filename"] .. ".png"
	   cc.Director:getInstance():getTextureCache()
	       :addImageAsync(filename, loadingCallBack)
	end 

	return layer
end

return LoadingScene
