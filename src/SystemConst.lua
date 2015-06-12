
-- 系统常量 

--local targetPlatform = cc.Application:getInstance():getTargetPlatform()


Res = {
    -- 资源目录路径
    root = 'hd/texture/',
    -- 走路精灵帧缓存
    walk_texture_res = 'hd/texture/walk.png',
    walk_texture_plist = 'hd/texture/walk.plist',
    -- 纹理缓存文件
    image_meta_data_plist = 'hd/ImageMetaData.plist',
    
    -- 分享朋友圈文字
    share_text_texture_res = 'hd/texture/arrow.png',
    -- 玩法提示文字
    tip_texture_res = 'hd/texture/guide_text.png',
    -- 分享按钮
    share_normal_texture_res = 'hd/texture/notify.png',
    -- 白色背景
    white_texture_res = 'hd/texture/overSoreBg.png',
    -- 灰色背景
    gray_texture_res = 'hd/texture/scoreBg.png',
    -- 重新开始
    restart_normal_texture_res = 'hd/texture/shuaxin.png',
    -- 开始
    start_normal_texture_res = 'hd/texture/start_normal.png',
    start_selected_texture_res = 'hd/texture/start_select.png',
    -- 棍子
    stick_black_texture_res = 'hd/texture/stick_black.png',
    -- 主页
    home_normal_texture_res = 'hd/texture/zhuye.png',
    
    -- 背景
    bg00_map_res = 'hd/map/background0.png',
    bg01_map_res = 'hd/map/background1.png',
    bg02_map_res = 'hd/map/background2.png',
    bg03_map_res = 'hd/map/background3.png',
    
    -----------------------------------
    -- 字体 
    market_ttf = 'hd/fonts/Marker Felt.ttf',    
}

--HomeMenuTypes = {
--    StartMenuItem = 100,
--}

SpriteVelocity = {
    Hero = cc.p(10, 0),
    Stick = cc.p(10, 0)
}
