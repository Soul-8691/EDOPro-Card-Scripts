local s,id=GetID()
function s.initial_effect(c)
    -- Activate this Normal Spell
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(0)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- When this Spell is activated, register a lingering effect until End Phase.
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Lingering effect: whenever you successfully Normal Summon a Level 4 or lower monster,
    -- you may tribute (discard) 1 monster from your hand to flag that summon as a tribute summon.
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(s.lingering_op)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_CARD,0,id)
end

-- Filter for monsters in your hand that can be tributed (adjust if you want a different cost)
function s.tribute_filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end

-- This operation triggers when a monster is Normal Summoned.
function s.lingering_op(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(function(tc)
        return tc:IsControler(tp) and tc:IsLevelBelow(4)
            and tc:IsSummonType(SUMMON_TYPE_NORMAL)
            and not tc:HasFlagEffect(id)
    end, nil)
    for tc in aux.Next(g) do
        if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            if Duel.IsExistingMatchingCard(s.tribute_filter,tp,LOCATION_HAND,0,1,nil) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
                local dg=Duel.SelectMatchingCard(tp,s.tribute_filter,tp,LOCATION_HAND,0,1,1,nil)
                if #dg>0 then
                    Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
                    -- Flag the summoned monster so that it is treated as having been Tribute Summoned.
                    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
                    -- (Optionally, you could apply additional effects here to simulate a Tribute Summon.)
                end
            end
        end
    end
end