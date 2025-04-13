local s,id=GetID()
function s.initial_effect(c)
    -- Activate (Field Spell)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- (1) Boost "The Wicked Worm Beast" by 500 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.atktg)
    e1:SetValue(500)
    c:RegisterEffect(e1)

    -- (2) Allow it to be Tributed the turn it is Summoned
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_TRIBUTE_LIMIT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.atktg)
    e2:SetValue(s.nolimit)
    c:RegisterEffect(e2)
end

function s.atktg(e,c)
    return c:IsCode(6285791) and c:IsFaceup()
end

-- No tribute restriction
function s.nolimit(e,c)
    return false -- "false" means no tribute restriction at all
end
