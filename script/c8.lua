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
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Allow Battle Phase entry
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    -- Allow monsters to attack
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetValue(0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    -- Allow battle damage
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetValue(0)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    -- Allow destruction by battle
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetValue(0)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end