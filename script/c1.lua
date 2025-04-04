local s,id=GetID()
function s.initial_effect(c)
    --Gain 100 ATK for each monster you control with exactly 1700 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.val)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsFaceup() and c:GetAttack()==1700
end

function s.val(e,c)
    return Duel.GetMatchingGroupCount(s.filter, c:GetControler(), LOCATION_MZONE, 0, nil)*100
end