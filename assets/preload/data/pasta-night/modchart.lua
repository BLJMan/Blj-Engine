function start (song)
    hideTimeAndRating = true
	setActorY(80, "dad")
	
end

function beatHit (beat)
	if curBeat == 1 then 
        for i = 0,3 do
           tweenPosOut(i, -300, _G['defaultStrum'..i..'Y'], 2, (i / 15))
        end
    end
    
end