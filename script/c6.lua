local s,id=GetID()
function s.initial_effect(c)
    --(1) During the Tribute Summon cost, check if a monster with >=1800 DEF was used
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SUMMON_COST)
    e0:SetOperation(s.regop)
    c:RegisterEffect(e0)
    
    --(2) On successful Tribute Summon, if flagged, increase DEF by 500
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.defcon)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)
end

-- Store a flag if any tributed monster had 1800+ DEF
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetTributeGroup(c)            -- The group of tributed monsters
    if g and g:IsExists(Card.IsDefenseAbove,1,nil,1800) then
        -- If at least one tributed monster has >=1800 DEF, set a flag
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE,0,1)
    end
end

-- Check that this card was actually Tribute Summoned and the flag is present
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetFlagEffect(id)>0
end

-- Increase this card’s DEF by 500
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
end