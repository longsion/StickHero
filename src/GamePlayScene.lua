
require("SystemConst")

local size = cc.Director:getInstance():getWinSize()
local frameCache = cc.SpriteFrameCache:getInstance()
local schedulerId = nil
local scheduler = cc.Director:getInstance():getScheduler()
local max_stick_len
local stick     -- 用来走的小棍
--local stick01   -- 平台1
--local stick02   -- 平台2
local platform = {}
local hero
local hero_width
local init_stick_size
local score_label
local can_touch = false

local GamePlayScene = class("GamePlayScene",function()
    return cc.Scene:create()
end)

function GamePlayScene:create()
    local scene = GamePlayScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function GamePlayScene:ctor()

end

function GamePlayScene:createLayer()
    local layer = cc.Layer:create()
    
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    
    local bg_sprite = cc.Sprite:create(Res.bg00_map_res)
    layer:addChild(bg_sprite)
    bg_sprite:setPosition(size.width/2, size.height/2)
    --    bg_sprite:setContentSize(size.width, size.height)
    local bg_sprite_size = bg_sprite:getContentSize()
    bg_sprite:setScale(size.width/bg_sprite_size.width, size.height/bg_sprite_size.height)

    -- 分数背景
    local score_bg = cc.Sprite:create(Res.gray_texture_res)
    layer:addChild(score_bg)
    score_bg:setPosition(size.width/2, size.height/5*4)
    -- 分数
    score_label = cc.Label:createWithTTF("0", Res.market_ttf, 45)
    score_bg:addChild(score_label)
    local score_bg_size = score_bg:getContentSize()
    score_label:setPosition(score_bg_size.width/2, score_bg_size.height/2-5)
    -- 玩法提示
    local play_tip = cc.Sprite:create(Res.tip_texture_res)
    layer:addChild(play_tip)
    local score_bg_pos = cc.p(score_bg:getPosition())
    play_tip:setPosition(score_bg_pos.x, score_bg_pos.y - score_bg_size.height)
    -- 分数玩法提示等淡入
    score_bg:setOpacity(10)
    play_tip:setOpacity(10)
    score_bg:runAction(cc.FadeIn:create(1))
    play_tip:runAction(cc.FadeIn:create(1))
    
    -- 平台01
    local stick01
    stick01 = ccui.Scale9Sprite:create(Res.stick_black_texture_res)
    layer:addChild(stick01)
--    local stick01_size = stick01:getContentSize()
    stick01:setContentSize(init_stick_size.width, init_stick_size.height)
--    stick:setScale(80/stick_size.width, 125/stick_size.height)
    stick01:setPosition(init_stick_size.width/2, init_stick_size.height/2)
    platform[1] = {}
    platform[1].stick = stick01
    --平台2
    local stick02
    stick02 = ccui.Scale9Sprite:create(Res.stick_black_texture_res)
    layer:addChild(stick02)
    stick02:setContentSize(init_stick_size.width, init_stick_size.height)
    stick02:setPosition(size.width + init_stick_size.width/2, init_stick_size.height/2)
    platform[2] = {}
    platform[2].stick = stick02
    platform.cur = 1
    -- 棍子
    local rect1 = cc.rect(0, 0, 5, 287)
    local rect2 = cc.rect(1, 1, 3, 285)    
    stick = ccui.Scale9Sprite:create(Res.stick_black_texture_res, rect1, rect2)
    layer:addChild(stick)
    stick:setPosition(-size.width/2, size.height/2)
    stick:setAnchorPoint(cc.p(1, 0))
    stick:setContentSize(stick:getContentSize().width, 0)
    print("stick %d, %d", stick:getContentSize().width, stick:getContentSize().height)
    
    -- 人物
    hero = cc.Sprite:createWithSpriteFrameName("d0009.png")
    layer:addChild(hero)
    local hero_size = hero:getContentSize()
    hero:setAnchorPoint(0.5, 0)
    local stick01_postion = stick01:getPosition()
    hero:setPosition(init_stick_size.width/2, init_stick_size.height)

    -- 英雄走到平台边
    hero_width = hero_size.width/2 - 5
    cclog("hero_width = %d", hero_width)
    self:setHeroWalk(init_stick_size.width/2-hero_width)

    self:platformEnter()
    
    -- 触摸事件
    local function touchBegan(touch, event)
    	cclog("touchBegan")
    	if not can_touch then 
    	    return 
    	end
        -- 下面的getContentSize()和setContentSize()会出错
--        local stick_size = cc.size(5, 287) --stick:getContentSize()   
--    	cclog("add stick %d, %d", stick_size.width, stick_size.height)  
--    	stick:setContentSize(stick_size.width, 0)   
--    	stick:setOpacity(1000)     	-stick_size.width
        stick:setPosition(platform[platform.cur].stick:getContentSize().width-3, 
            init_stick_size.height)
    	
    	-- 增加棍子长度
    	local function addStickLen()
            local stick_size = stick:getContentSize()
            stick:setContentSize(stick_size.width, stick_size.height+8)
--            cclog("len len %d %d", stick_size.height, max_stick_len)
        	if stick_size.height >= max_stick_len then 
        	   if nil ~= schedulerId then 
        	       scheduler:unscheduleScriptEntry(schedulerId)
        	   end
                stick:setContentSize(stick_size.width, max_stick_len) 
        	end             
    	end
    	
        schedulerId = scheduler:scheduleScriptFunc(addStickLen, 0.01, false)
    	return true
    end
    local function touchMove(touch, event)
--        cclog("touchMove")
    end
    -- 触摸结束
    local function touchEnd(touch, event)
        cclog("touchEnd")
--        stick:setContentSize(stick:getContentSize().width, 0)
        if nil ~= schedulerId then 
            scheduler:unscheduleScriptEntry(schedulerId)
        end
        self:crossStick()
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(touchMove, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(touchEnd, cc.Handler.EVENT_TOUCH_ENDED)
    
    local eventDispather = cc.Director:getInstance():getEventDispatcher()
    eventDispather:addEventListenerWithFixedPriority(listener, 1)

    return layer
end 

function GamePlayScene:crossStick()
    -- 判断是否在下一个平台上
    -- 在 走到棍子末+英雄长，高度-5，然后走到平台边
    
    -- 否 判断棍子与平台间是否小于英雄长
    -- 小 直接掉下去 向后翻
    -- 大 走到棍子末+英雄长再掉下去 向前翻 
    -- 旋转动画
    stick_size = stick:getContentSize()
    local ac1 = stick:runAction(cc.RotateBy:create(1, 90))
    local ac2 = cc.CallFunc:create(function() self:setHeroWalk(stick_size.height, true) end)
    stick:runAction(cc.Sequence:create(ac1, ac2))	
end

-- 平台进入
function GamePlayScene:platformEnter()
    local next_index = self:getNextPlatform()
--    local platform_pos = platform[2].stick:getContentSize()
    platform[next_index].stick:setPosition(size.width + init_stick_size.width/2, 
        init_stick_size.height/2) 
	-- 生成宽度和距离
    max_stick_len = size.width - platform[platform.cur].stick:getContentSize().width
	local platform_width = math.random(25, 220)
    local platform_distance = math.random(init_stick_size.width/2, size.width-
        platform[platform.cur].stick:getContentSize().width - platform_width-10)
    cclog("platform_width, distance %d, %d", platform_width, platform_distance)
    platform[next_index].stick:setContentSize(platform_width, init_stick_size.height)
	-- 进入动画
	local ac1 = platform[next_index].stick:runAction(cc.MoveBy:create(platform_distance/1000,
	    cc.p(-platform_distance, 0)))
	local acf = cc.CallFunc:create(function() can_touch=true end)
	platform[next_index].stick:runAction(cc.Sequence:create(ac1, acf))
	-- 设置可点击
end

-- 返回下一个平台
function GamePlayScene:getNextPlatform()
	return platform.cur % 2 + 1
end
-- 改变当前平台
function GamePlayScene:changeCurPlatform()
    platform.cur = self:getNextPlayform()
end

-- 设置人物站立动画
function GamePlayScene:setHeroStand(is_after_walk)
    hero:stopAllActions()
    if is_after_walk then 
        local pos = cc.p(hero:getPosition())
--        hero:setPosition(cc.p(pos.x, pos.y-5))
        -- 收回棍子，
    end 
    local animation = cc.Animation:create()
    for i=1, 9 do 
        local frameName = string.format("d000%d.png", i)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end 

    animation:setDelayPerUnit(0.1)
    --    animation:setRestoreOriginalFrame(true)
    local action = cc.Animate:create(animation)
    hero:runAction(cc.RepeatForever:create(action))	
end

-- 设置人物行走动画
function GamePlayScene:setHeroWalk(distance, is_after_walk)
    if not distance or distance < 0 then 
        return 
    end 
    if is_after_walk then 
        local pos = cc.p(hero:getPosition())
        hero:setPosition(cc.p(pos.x, pos.y+5))
    end 
    local animation = cc.Animation:create()
    for i=1, 9 do 
        local frameName = string.format("z000%d.png", i)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end 

    animation:setDelayPerUnit(0.1)
    --    animation:setRestoreOriginalFrame(true)
    local action = cc.Animate:create(animation)
    local ac1 = hero:runAction(cc.RepeatForever:create(action))
    local ac2 = hero:runAction(cc.MoveBy:create(distance/150, cc.p(distance, 0)))
--    local ac3 = hero:runAction(cc.Spawn:create(action, ac2))
    local ac4 = cc.CallFunc:create(function() self:setHeroStand(is_after_walk) end)
    hero:runAction(cc.Sequence:create(ac2, ac4)) 
end

function GamePlayScene:setInitStickSize(width, height)
    cclog("setInitStickSize %d, %d", width, height)
	init_stick_size = cc.size(width, height)
end

return GamePlayScene
