local s,id=GetID()
function s.initial_effect(c)
    -- Fusion materials
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,74677422,s.matfilter)

    -- (1) Once per turn: Discard 1 Fish/Sea Serpent/Thunder/Aqua; destroy 1 card on the field
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.descost)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
end

-- Fusion material must be Sea Serpent or a card with "Sea Horse" in its name
function s.matfilter(c,fc,sumtype,tp)
    return c:IsRace(RACE_SEASERPENT,fc,sumtype,tp) or c:IsCode(54332792) or c:IsCode(17444133) or c:IsCode(48049769) or c:IsCode(36492575)
end

-- Cost: Discard 1 Fish, Sea Serpent, Thunder, or Aqua
function s.cfilter(c)
    return (c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT)
        or c:IsRace(RACE_THUNDER) or c:IsRace(RACE_AQUA)) and c:IsDiscardable()
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end

-- Target 1 card on the field
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- Destroy it
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
