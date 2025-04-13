local s,id=GetID()
function s.initial_effect(c)
    -- (1) Activate directly from hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- (2) Discard 1 card from your field to Special Summon a Level 4 or lower monster from hand this turn
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.sacrificecost)
    e1:SetTarget(s.sactg)
    e1:SetOperation(s.saop)
    c:RegisterEffect(e1)
end

-- Cost: Discard 1 card from your field (can be face-up or face-down)
function s.sacrificecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsOnField,tp,LOCATION_ONFIELD,0,1,nil) 
    end
    -- Select a card on the field to discard
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,Card.IsOnField,tp,LOCATION_ONFIELD,0,1,1,nil)
    
    -- Debug log to check selected card
    Duel.Hint(HINT_MSG_LOG,tp,"Discarding card: " .. g:GetFirst():GetName())
    
    -- Send the selected card to the Graveyard
    Duel.SendtoGrave(g,REASON_COST)
end

-- Target: Special Summon a Level 4 or lower monster from hand
function s.sactg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        -- Check if there is a Level 4 or lower monster in the hand
        return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
    end
    -- Show info about the Special Summon
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

-- Filter: Level 4 or lower monster
function s.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- Operation: Special Summon the monster
function s.saop(e,tp,eg,ep,ev,re,r,rp)
    -- Debug: Log the operation being triggered
    Duel.Hint(HINT_MSG_LOG,tp,"Special Summon operation triggered")

    -- Select a Level 4 or lower monster from hand
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)

    -- Debug: Check if the card selection worked
    if #g>0 then
        Duel.Hint(HINT_MSG_LOG,tp,"Special Summoning: " .. g:GetFirst():GetName())
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
