local s,id=GetID()
function s.initial_effect(c)
    -- (1) Trigger on Flip Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_FLIP)
    e1:SetCondition(s.defcon)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)

    -- (2) Trigger on Tribute Set
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1b:SetCode(EVENT_MSET)
    e1b:SetCondition(s.defcon)
    e1b:SetOperation(s.defop)
    c:RegisterEffect(e1b)

    -- (3) Check material and store flag on self
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    c:RegisterEffect(e2)
end

-- Store flag if any tribute had 1800+ DEF
function s.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(function(tc) return tc:GetDefense()>=1800 end,1,nil) then
        -- Store a flag on this card
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
    end
end

-- Check summon type and that the flag is present
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsSummonType(SUMMON_TYPE_TRIBUTE) or c:IsSummonType(SUMMON_TYPE_MSET))
        and c:GetFlagEffect(id) > 0
end

-- Increase DEF by 500 if condition is met
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