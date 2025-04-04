local s,id=GetID()
function s.initial_effect(c)
    -- Summon Success: if Tribute Summoned and label set by material check equals 1, gain 500 DEF
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.defcon)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)
    -- Material Check: set a label on e1 if any tribute material has 1800 or more DEF
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
end

-- Check tribute materials: if any have 1800+ DEF, set label to 1; otherwise, 0.
function s.valcheck(e,c)
    local g=c:GetMaterial()
    local flag=0
    if g:IsExists(function(tc) return tc:GetDefense()>=1800 end,1,nil) then
        flag=1
    end
    e:GetLabelObject():SetLabel(flag)
end

-- Condition: This monster must be Tribute Summoned and the label from the material check equals 1.
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()==1
end

-- Operation: Increase this monster's DEF by 500.
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end