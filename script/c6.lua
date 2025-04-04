local s,id=GetID()
function s.initial_effect(c)
    -- (1) Trigger on Summon Success (Tribute Summon)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.defcon)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)
    -- (2) Trigger on Set Success (Tribute Set)
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1b:SetCode(EVENT_MSET)
    e1b:SetCondition(s.defcon)
    e1b:SetOperation(s.defop)
    c:RegisterEffect(e1b)
    -- (3) Material Check: store a flag if any tribute material has 1800 or more DEF
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    e2:SetLabelObject(e1)
    e2:SetLabelObject(e1b)
    c:RegisterEffect(e2)
end

-- Material Check: if any tribute material has 1800 or more DEF, store flag=1 on the card.
function s.valcheck(e,c)
    local g=c:GetMaterial()
    local tc=g:GetFirst()
    if tc:IsDefenseAbove(1800) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end

-- Condition: If the card was either Tribute Summoned (face-up) or Tribute Set (face-down)
-- and the stored flag equals 1, then the condition is met.
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsSummonType(SUMMON_TYPE_ADVANCE) or c:IsSummonType(SUMMON_TYPE_MSET))
       and c:GetFlagEffectLabel(id)==1
end

-- Operation: Increase this monster's DEF by 500.
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end