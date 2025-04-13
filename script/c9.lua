local s,id=GetID()
function s.initial_effect(c)
    -- Activate (Field Spell)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- (1) Boost ATK of Wicked Worm Beast
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(function(e,c) return c:IsCode(6205579) end)
    e1:SetValue(500)
    c:RegisterEffect(e1)

    -- (2) Allow tribute the turn it's summoned
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPIRIT_MAYNOT_BE_TRIBUTED)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.allow_tribute)
    e2:SetValue(aux.FALSE) -- prevent the "may not be tributed" restriction
    c:RegisterEffect(e2)
end

-- Allow tributing Wicked Worm Beast this turn
function s.allow_tribute(e,c)
    return c:IsCode(6205579)
end
