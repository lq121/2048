require "app.scenes.Version"

local Card = class("Card", function()
	-- body
	return cc.Sprite:create()
end)

function Card:ctor()
	
end


Card.num = 0
Card.numLabel = nil


function Card:create( num,w,h,p)
	local cardBox = Card:new()
	cardBox:setAnchorPoint(0,0)
	cardBox:setContentSize(w,h)

	local bg = cc.LayerColor:create(cc.c4b(255, 255, 255, 100),w,h)
	cardBox.numLabel = cc.ui.UILabel.new({text = num,size = 80})
	cardBox.numLabel:setColor(Version:getColor(1))
	cardBox.numLabel:setPosition(bg:getContentSize().width*0.5,bg:getContentSize().height*0.5)
	cardBox:addChild(bg)
	cardBox:addChild(cardBox.numLabel)
	return cardBox
end

--修改数字
function Card:setNum(num)
    local n = tonumber(num)
    if (n>0) then
        local index = Version:getScoreIndex(n)
        if index ~= nil then
        	print(index)
        	self.numLabel:setColor(Version:getColor(index))
        end
        
        self.num = n
        self.numLabel:setString(num)
    else
        self.numLabel:setString("")
        self.num = 0
    end
end

function Card:getData( )
	return self.num
end


function Card:play( )
	self.numLabel:runAction(cc.Sequence:create(cc.ScaleTo:create(0,0.1,0.1),cc.ScaleTo:create(0.5,1,1)))
end

return Card
