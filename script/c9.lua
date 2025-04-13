local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- (1) All "The Wicked Worm Beast" gain 500 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE) -- assuming this is a Field Spell
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(s.atktg)
    e1:SetValue(500)
    c:RegisterEffect(e1)

    -- (2) "The Wicked Worm Beast" can be used as tribute the turn it is summoned
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_TRIBUTE_LIMIT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.tribute_target)
    e2:SetValue(s.tribute_limit)
    c:RegisterEffect(e2)
end

-- Target only "The Wicked Worm Beast"
function s.atktg(e,c)
    return c:IsCode(06205579) -- Card ID for The Wicked Worm Beast
end

-- Apply tribute limit override to The Wicked Worm Beast
function s.tribute_target(e,c)
    return c:IsCode(06205579)
end

-- Allow it to be tributed even if it was summoned this turn
function s.tribute_limit(e,c)
    return 0 -- 0 = no restriction
end
