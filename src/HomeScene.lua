
require("SystemConst")

local size = cc.Director:getInstance():getWinSize()
--local defaults = cc.UserDefault:getInstance()
local stick
local hero
local start_menu
local stick_width 
local stick_height

local HomeScene = class("HomeScene",function()
    return cc.Scene:create()
end)

function HomeScene.create()
    local scene = HomeScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function HomeScene:ctor()

end

function HomeScene:createLayer()
    local layer = cc.Layer:create()
    
    local bg_sprite = cc.Sprite:create(Res.bg00_map_res)
    layer:addChild(bg_sprite)
    bg_sprite:setPosition(size.width/2, size.height/2)
--    bg_sprite:setContentSize(size.width, size.height)
    local bg_sprite_size = bg_sprite:getContentSize()
    bg_sprite:setScale(size.width/bg_sprite_size.width, size.height/bg_sprite_size.height)
    cclog("%d, %d", size.width, size.height)
    cclog("%d, %d", bg_sprite_size.width, bg_sprite_size.height)
    cclog("%d, %d", size.width/bg_sprite_size.width, size.height/bg_sprite_size.height)
    
    -- 开始按钮
    local function transitionScene()
        local GamePlayScene = require("GamePlayScene")
        GamePlayScene:setInitStickSize(stick_width, stick_height)        
        local scene = GamePlayScene:create()
        cc.Director:getInstance():pushScene(scene)    	
    end
    local function startMenuCallback(tag, sender)
        cclog("startBtnCalback tag=%s", tag)
        -- 开始按钮渐变消失
        start_menu:runAction(cc.FadeTo:create(1, 0))
        -- 英雄和棍子左移
        local stick_size = stick:getContentSize()
        local dis = -(size.width/2-stick_size.width/2)
        stick:runAction(cc.MoveBy:create(1, cc.p(dis, 0)))
        local ac = hero:runAction(cc.MoveBy:create(1, cc.p(dis, 0)))
        local acf = cc.CallFunc:create(transitionScene)
--        local seq = cc.Sequence:create(ac, acf)
        hero:runAction(cc.Sequence:create(ac, acf))
    end
--    local start_btn_normal = cc.Sprite:create(Res.start_normal_texture_res)
--    local start_btn_normal_size = start_btn_normal:getContentSize()
--    local start_btn_selected = cc.Sprite:create(Res.start_selected_texture_res)
    local start_btn_normal = ccui.Scale9Sprite:create(Res.start_normal_texture_res)
    local start_btn_normal_size = start_btn_normal:getContentSize()
    local start_btn_selected = ccui.Scale9Sprite:create(Res.start_selected_texture_res)
    local start_menu_item = cc.MenuItemSprite:create(start_btn_normal, 
            start_btn_selected)
    start_menu_item:registerScriptTapHandler(startMenuCallback)
--    start_menu_item:setTag(HomeMenuTypes.StartMenuItem)

    start_menu = cc.Menu:create(start_menu_item)
    start_menu:setPosition(size.width/2, size.height/2)
    layer:addChild(start_menu)
    
    -- 开始按钮动画
    local ac1 = start_menu:runAction(cc.MoveBy:create(1.2, cc.p(0, 10)))
    local ac2 = ac1:reverse()
    local seq = cc.Sequence:create(ac1, ac2)
    start_menu:runAction(cc.RepeatForever:create(seq))
--    local start_btn = ccui.Button:create(Res.start_normal_texture_res, 
--        Res.start_selected_texture_res)
--    local start_btn = cc.Sprite:create(Res.start_normal_texture_res)
--    layer:addChild(start_btn)
--    start_btn:setPosition(size.width/2, size.height/2)
--    start_btn:setTouchEnabled(true)
--    start_btn:addClickEventListener(startBtnCallback)
--    local listener = cc.EventListenerTouchOneByOne:create()
--    listener:setSwallowTouches(true)
--    listener:registerScriptHandler(startBtnTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
--    listener:registerScriptHandler(startBtnTouchMove, cc.Handler.EVENT_TOUCH_MOVED)
--    
--    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
--    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, start_btn)
    -- 柱子
--    local stick = cc.Sprite:create(Res.stick_black_texture_res)
    stick = ccui.Scale9Sprite:create(Res.stick_black_texture_res)
    layer:addChild(stick)
    local stick_size = stick:getContentSize()
    stick_width = start_btn_normal_size.width-20
    stick_height = size.height - size.height/3*2
    stick:setContentSize(stick_width, stick_height)
--    stick:setScale(80/stick_size.width, 125/stick_size.height)
    stick:setPosition(size.width/2, stick_height/2)

    -- 人物
    hero = cc.Sprite:createWithSpriteFrameName("d0009.png")
    layer:addChild(hero)
    local hero_size = hero:getContentSize()
    hero:setAnchorPoint(0.5, 0)
    local stick_postion = stick:getPosition()
    hero:setPosition(size.width/2, stick_height)
    
    -- 人物动画
    local frameCache = cc.SpriteFrameCache:getInstance()
    local animation = cc.Animation:create()
    for i=1, 9 do 
        local frameName = string.format("dq000%d.png", i)
        local spriteFrame = frameCache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end 
    
    animation:setDelayPerUnit(0.1)
--    animation:setRestoreOriginalFrame(true)
    local action = cc.Animate:create(animation)
    hero:runAction(cc.RepeatForever:create(action))
    cclog("end---")
 
    return layer
end 

return HomeScene
