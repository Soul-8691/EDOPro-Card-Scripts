local s,id=GetID()
function s.initial_effect(c)
    -- (1) Tribute Summon Success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.defcon)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)

    -- (2) Tribute Set Success
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1b:SetCode(EVENT_MSET)
    e1b:SetCondition(s.defcon)
    e1b:SetOperation(s.defop)
    c:RegisterEffect(e1b)

    -- (3a) Material Check for Summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)

    -- (3b) Material Check for Set
    local e2b=e2:Clone()
    e2b:SetLabelObject(e1b)
    c:RegisterEffect(e2b)
end

-- Material Check: set Label=1 on the trigger effect if any material has 1800+ DEF
function s.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(function(tc) return tc:GetDefense()>=1800 end,1,nil) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end

-- Condition: if tribute summon/set AND label = 1
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsSummonType(SUMMON_TYPE_ADVANCE) or c:IsSummonType(SUMMON_TYPE_MSET))
        and e:GetLabel()==1
end

-- Operation: +500 DEF if condition met
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