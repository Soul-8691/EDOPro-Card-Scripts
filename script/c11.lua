local s,id=GetID()
function s.initial_effect(c)
    -- Fusion materials
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,89631139,s.matfilter) -- 89631139 = Blue-Eyes White Dragon

    -- (1) Once per turn: Destroy 1 own Fish/Sea Serpent/Thunder/Aqua → Destroy 1 opponent's card
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
end

-- Fusion material: Sea Serpent or "Sea Horse" (excluding Marincess Sea Horse)
function s.matfilter(c,fc,sumtype,tp)
    return (c:IsRace(RACE_SEASERPENT,fc,sumtype,tp) or c:IsCode(54332792) or c:IsCode(17444133) or c:IsCode(48049769)) 
end

-- Valid monsters to destroy from your field
function s.costfilter(c)
    return (c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT)
        or c:IsRace(RACE_THUNDER) or c:IsRace(RACE_AQUA))
        and c:IsFaceup() and c:IsDestructable()
end

-- Check if both sides have targets
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_ONFIELD)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    -- Select and destroy your own monster
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    if #g1==0 or Duel.Destroy(g1,REASON_EFFECT)==0 then return end

    -- Then select and destroy opponent's card
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #g2>0 then
        Duel.Destroy(g2,REASON_EFFECT)
    end
end
