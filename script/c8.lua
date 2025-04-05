--Tribal Chant
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    -- Force allow Battle Phase
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(1,0)
    e1:SetValue(function(eff,re,rp) return false end)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)

    -- Force allow Battle Damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(1,0)
    e2:SetValue(aux.FALSE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)

    -- Force allow monsters to be destroyed by battle
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(s.not_indestructible)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)

    -- Disable all cards currently applying EFFECT_CANNOT_BP
    local g=Duel.GetMatchingGroup(s.has_bp_lock_effect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    for tc in g:Iter() do
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_DISABLE)
        e4:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e4)
    end
end

function s.not_indestructible(e,c)
    return false
end

-- Checks if a card is applying EFFECT_CANNOT_BP to the player
function s.has_bp_lock_effect(c)
    local ef_list={c:GetCardEffect(EFFECT_CANNOT_BP)}
    return #ef_list > 0
end