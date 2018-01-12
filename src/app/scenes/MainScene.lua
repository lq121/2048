
local Card = require("app.scenes.Card")
local cardList = {}--卡片字典
local BeginPos = {x = 0, y = 0}
local totalScore = 0 -- 当前分数

local MainScene = class("MainScene", function()
  return display.newScene("MainScene")
  end)

function MainScene:ctor()
   -- 获取屏幕的size
   
   size = cc.Director:getInstance():getVisibleSize()
   -- 背景色
   cc.LayerColor:create(cc.c4b(180, 170, 160, 255)):addTo(self)

   -- 标题label
   local titleLabel = cc.ui.UILabel.new({text = "2048",size = 30}):addTo(self)
   titleLabel:setPosition(cc.p(display.cx,display.height-30))

   -- 分数label
   scoreLabel = cc.ui.UILabel.new({text = "0'",size = 30}):addTo(self)
   :setPosition(cc.p(display.width - 140,display.height-30))

   -- 通关label
   -- local passGameLabel = cc.ui.UILabel.new({text = "Success!",size = 30,color = cc.c4b(255, 255, 0, 255)})
   --                       :addTo(self)
   --                       :align(display.CENTER, display.cx, display.cy)
   --                       :setVisible(false)
   -- 结束label
   overLabel = cc.ui.UILabel.new({text = "game over",size = 30,color = cc.c4b(251, 0, 255, 255)})
   :addTo(self)
   :align(display.CENTER, display.cx, display.cy)
   :setVisible(false)


   local function clickRestar(tag,sender)
   self:resetGame()
 end
   -- 重新开始按钮
   local restartItem = cc.MenuItemFont:create("restart")
   restartItem:setColor(cc.c4b(22, 100, 255, 255))
   restartItem:setPosition(display.cx,display.bottom + 100)
   restartItem:registerScriptTapHandler(clickRestar)
   local restartMenu = cc.Menu:create(restartItem)
   restartMenu:setPosition(0,0)
   self:addChild(restartMenu)



   	-- 绘制表格
   	self:initGrid()
   	-- 初始化卡片
   	self:initCard()

   	-- 添加触摸时间
   	function onTouchBegan(touch, event) 
   		-- body
      BeginPos = touch:getLocation()
        --网上都说这里一定要返回为true才行 具体不是很清楚为什么
        return true
      end
      local function onTouchMoved(touch, event)
      end

      local function onTouchEnd(touch, event)
        local location = touch:getLocation()
        local nMoveY = location.y - BeginPos.y 

        -- 获取触摸的方向
        if location.x - BeginPos.x > 50 then

          self:rightCombineNumber()
          elseif location.x - BeginPos.x < -50 then

            self:leftCombineNumber()
            elseif location.y - BeginPos.y > 50 then

              self:upCombineNumber()
              elseif location.y -BeginPos.y < -50 then

                self:downCombineNumber()
              end
            end

            local layer = cc.Layer:create()
            local listener = cc.EventListenerTouchOneByOne:create()
            listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
            listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
            listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
            local eventDispatcher = layer:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
            self:addChild(layer, -1)
          end

          function MainScene:initGrid() 
	-- body
	-- 获取格子的宽度
	local gridW = size.width *0.8*0.25
	local draw = cc.DrawNode:create()
	local drawBox = cc.Sprite:create()
	drawBox:setPosition(cc.p(display.cx - 2*gridW, display.cy*0.5))
	drawBox:addChild(draw)
	self:addChild(drawBox)
	for index=0,4 do
		draw:drawSegment(cc.p(index*gridW, 0), cc.p(index*gridW, gridW*4), 1, cc.c4f(1, 1, 1, 1)) -- 竖线
		draw:drawSegment(cc.p(0, index*gridW), cc.p(gridW*4, index*gridW), 1, cc.c4f(1, 1, 1, 1)) -- 横线
	end
end

function MainScene:initCard() 
	-- body
	local random1 = self:getRandom(4);
  local random2 = self:getRandom(4);
  while (random1 == random2) do
    random2 = self:getRandom(4);
  end
  local random11 = self:getRandom(4);
  local random22 = self:getRandom(4);

  local key
    -- 卡片的宽度
    local cardW = size.width *0.8*0.25
    for i=0,3 do
    	for j=0,3 do
    		local card = Card:create("0",cardW,cardW,cc.p(i,j))
    		local cardX = display.cx - 2 *cardW + i * cardW;
    		local cardY = display.cy*0.5 + j * cardW
    		card:setPosition(cardX,cardY)
    		self:addChild(card)
    		if (i == random1 and j == random11) then
          card:setNum("2")
          elseif (i == random2 and j == random22) then
            card:setNum("2")
          else
            card:setNum(0)
          end
            --根据位置保存card对象
            key = i..":"..j
            cardList[key] = card
          end
        end

      end

      function MainScene:getRandom(maxSize)
	 --这里需要这样写一下 才能让随即数每次都不一样
   math.randomseed(os.time())
   return math.floor(math.random() * maxSize) % maxSize
 end


-- 向右
function MainScene:rightCombineNumber()
  if isPlay == false then
    return true 
  end
  local card 
  local nextCard 
  for i = 0,3 do
    for j = 3,0,-1 do 
      card = cardList[j..":"..i]
      if card:getData() ~= 0 then
       local k = j - 1
       while k >= 0 do
         nextCard = cardList[k..":"..i]
         if nextCard:getData() ~= 0 then
           if card:getData() == nextCard:getData() then
             card:setNum(card:getData() * 2)
             nextCard:setNum(0)
             totalScore = totalScore + card:getData()
           end
           k = -1
           break
         end
         k = k- 1
       end
     end 
   end
 end

 for i = 0,3 do
  for j = 3,0,-1 do
    card = cardList[j..":"..i]
    if card:getData() == 0 then
      local k = j -1
      while k >= 0 do
        nextCard = cardList[k..":"..i]
        if nextCard:getData() ~= 0 then
          card:setNum(nextCard:getData())
          nextCard:setNum(0)
          k = -1
        end
        k = k - 1
      end
    end
  end
end
self:updataNumber()
end

-- 向左
function MainScene:leftCombineNumber() 
  if isPlay == false then
    return true 
  end
  local card 
  local nextCard
  for i = 0,3 do
    for j = 0, 3 do
      card = cardList[j..":"..i]
      if card:getData() ~= 0 then
        local k = j + 1
        while k < 4 do
          nextCard = cardList[k..":" .. i]
          if nextCard:getData() ~= 0  then
            if card:getData() == nextCard:getData() then
              card:setNum(card:getData()*2)
              nextCard:setNum(0)
              totalScore = totalScore + card:getData()
            end
            k = 4
            break
          end
          k = k +1
        end
      end
    end
  end

  for i = 0, 3 do
    for j = 0, 3 do
      card = cardList[j..":"..i]
      if card:getData() == 0 then
        local k = j + 1
        while k < 4 do
          nextCard = cardList[k..":"..i]
          if nextCard:getData() ~= 0 then
            card:setNum(nextCard:getData())
            nextCard:setNum(0)
            k = 4
            break
          end
          k = k + 1
        end
      end
    end
  end
  self:updataNumber()
end

-- 向上
function MainScene:upCombineNumber() 
  if isPlay == false then
    return true
  end

  local card 
  local nextCard

  for x = 0,3 do
    for y = 3,0,-1 do
      for y1 = y -1,0,-1 do
        if (cardList[x..":"..y1]:getData() > 0) then
          if (cardList[x..":"..y]:getData() <= 0) then
            cardList[x..":"..y]:setNum(cardList[x..":"..y1]:getData());
            cardList[x..":"..y1]:setNum(0);
            y = y+1;
--                        isMove = true;
elseif(cardList[x..":"..y]:getData() == cardList[x..":"..y1]:getData()) then
  cardList[x..":"..y]:setNum(cardList[x..":"..y]:getData() * 2)
  cardList[x..":"..y1]:setNum(0)
  totalScore = totalScore+cardList[x..":"..y]:getData()
end
break
end
end
end
end
self:updataNumber()
end


-- 向下
function MainScene:downCombineNumber() 
 if (isPlay == false) then
  return true
end

for x = 0,3 do
  for y = 0,3 do
    for y1 = y + 1,3 do
      if (cardList[x..":"..y1]:getData() > 0) then
        if (cardList[x..":"..y]:getData() <= 0) then
          cardList[x..":"..y]:setNum(cardList[x..":"..y1]:getData())
          cardList[x..":"..y1]:setNum(0);
          y = y-1
          elseif(cardList[x..":"..y]:getData() == cardList[x..":"..y1]:getData()) then
            cardList[x..":"..y]:setNum(cardList[x..":"..y]:getData() * 2)
            cardList[x..":"..y1]:setNum(0);
            totalScore = totalScore+cardList[x..":"..y]:getData()
          end
          break
        end
      end
    end
  end
  self:updataNumber()
end


-- 更新是否有空格，有的话添加一个随机数
function MainScene:updataNumber(  )
  local emptyList = {}
  local key 
  local card 
  local num = 0
  for i = 0,3 do
    for j = 0,3 do
      card = cardList[i..":"..j]
      if card:getData() ~= 0 then
      else
        emptyList[num] = card 
        num = num + 1
      end
    end
  end

  self:updateScore()


  if num < 1 then
      -- 失败
      isPlay = false
      overLabel:setVisible(true)
    else
      local newCard = emptyList[self:getRandom(num)]
      newCard:setNum(2)
      newCard:play()
    end
  end

  function MainScene:resetGame() 
    overLabel:setVisible(false)
    isPlay = true 
    totalScore = 0
    self:updateScore()
    local random1 = self:getRandom(4);
    local random2 = self:getRandom(4);
    while (random1 == random2) do
      random2 = self:getRandom(4);
    end
    local random11 = self:getRandom(4);
    local random22 = self:getRandom(4);
    
    local oldKey1 = random1..":"..random11
    local oldKey2 = random2..":"..random22
    for key,value in pairs(cardList) do
      value:setNum(0)
      if (key == oldKey1 or key == oldKey2) then
        value:setNum(2)
      end
    end
  end

  function MainScene:updateScore( )
    scoreLabel:setString(totalScore.."'")
  end

  function MainScene:onEnter()
  end

  function MainScene:onExit()
  end

  return MainScene
