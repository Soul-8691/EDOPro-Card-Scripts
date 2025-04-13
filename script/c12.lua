local s,id=GetID()
function s.initial_effect(c)
    -- (1) Gain 200 ATK/DEF per Thunder in your GY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.statup)
    c:RegisterEffect(e1)

    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
end

-- Count Thunder monsters in your GY, multiply by 200
function s.statup(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_THUNDER)*200
end
