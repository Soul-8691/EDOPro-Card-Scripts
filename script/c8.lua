--Tribal Chant
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    -- ✅ Override Battle Phase lock
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(1,0)
    e1:SetValue(function(e,re,r,rp) return false end)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)

    -- ✅ Override "cannot attack"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(1,0)
    e2:SetValue(function() return false end)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)

    -- ✅ Override "cannot announce attack"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetTargetRange(1,0)
    e3:SetValue(function() return false end)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)

    -- ✅ Restore damage to opponent (e.g. from Dragon Revival Rhapsody)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CHANGE_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(0,1)
    e4:SetValue(function(e,re,val,r,rp,rc) return val end)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)

    -- ✅ Override avoid battle damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetTargetRange(1,0)
    e5:SetValue(aux.FALSE)
    e5:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e5,tp)

    -- ✅ Override indestructible by battle
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetValue(s.not_indestructible)
    e6:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e6,tp)

    -- ✅ Force Battle Phase to be allowed manually (EDOPro workaround)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
    e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        return Duel.GetTurnPlayer()==tp
    end)
    e7:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
    end)
    e7:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e7,tp)
end

function s.not_indestructible(e,c)
    return false
end
