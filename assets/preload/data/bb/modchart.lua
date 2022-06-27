function start (song)
    hideTimeAndRating = true
end

function beatHit (beat)

    if curBeat == 1 then 
        for i = 0,3 do
           tweenPosOut(i, -300, _G['defaultStrum'..i..'Y'], 2, (i / 15))
        end
        for i = 4,7 do 
            tweenPosOut(i, ((screenWidth / 2) - 690) + (115 * i), _G['defaultStrum'..i..'Y'], 2, (i / 15))
        end
    end

end

function stepHit (step)
    if curStep == 20 then
        setActorX(850, "boyfriend")
        setActorY(570, "boyfriend")
    end

end