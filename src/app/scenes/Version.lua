Version = class("Version")
Version.__index = Version

Version.Color = {
		 cc.c3b(255, 255, 255),cc.c3b(255,105,180), cc.c3b(255,215,0), cc.c3b(0,255,127),
    cc.c3b(0,191,255), cc.c3b(0,255,255), cc.c3b(218,112,214),cc.c3b(220,20,60),
    cc.c3b(255,255,0), cc.c3b(218,165,32), cc.c3b(0,128,0),cc.c3b(0,0,255),
    cc.c3b(0,206,209), cc.c3b(106,90,205), cc.c3b(218,112,214),cc.c3b(255,165,0),
    cc.c3b(255,0,255)
}

Version.Scores = {0,2,4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048}

function Version:getColor( index)
	return self.Color[index]
end


function Version:getScore(index)
	return self.Scores[index]
end

function Version:getScoreIndex(score)
	
	local i 
	for i=1,#self.Scores do
		local num = self.Scores[i]
		if num == score then
			return i
		end
		i = i + 1
	end
end