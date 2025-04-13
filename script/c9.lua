local s,id=GetID()
function s.initial_effect(c)
    -- Activate as Field Spell
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- (1) All "The Wicked Worm Beast" gain 500 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(s.atktg)
    e1:SetValue(500)
    c:RegisterEffect(e1)

    -- (2) Prevent "The Wicked Worm Beast" from returning to the hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPIRIT_DONOT_RETURN)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.noreturn)
    c:RegisterEffect(e2)
end

-- ATK boost targets
function s.atktg(e,c)
    return c:IsFaceup() and c:IsCode(6205579)
end

-- Prevent Spirit return
function s.noreturn(e,c)
    return c:IsCode(6205579)
end
