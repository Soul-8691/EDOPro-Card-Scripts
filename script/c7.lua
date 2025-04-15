-- Tribal Chant
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.efilter(e,re)
    -- Filter for effects to bypass
    return re:IsHasEffect(EFFECT_CANNOT_BP) or
           re:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) or
           re:IsHasEffect(EFFECT_NO_BATTLE_DAMAGE) or
           re:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Allow Battle Phase entry
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(0,0)
    e1:SetTarget(s.bptarget)
    e1:SetValue(s.efilter)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    -- Allow monsters to attack, deal damage, and destroy
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(s.efilter)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function s.bptarget(e,c)
    -- Target the player for Battle Phase immunity
    return e:GetHandlerPlayer()
end