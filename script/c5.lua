--Gaia the Fierce Knight Spirit
local s,id=GetID()
function s.initial_effect(c)
    ----------------------------------------------------------------
    --(1) If this card is in your hand: You can send 1 Level 4 or higher
    --    Warrior monster from your Deck or hand to the GY, then
    --    Special Summon this card (once per turn).
    ----------------------------------------------------------------
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)  -- "each effect once per turn" part 1
    e1:SetCost(s.sscost)
    e1:SetTarget(s.sstg)
    e1:SetOperation(s.ssop)
    c:RegisterEffect(e1)
    
    ----------------------------------------------------------------
    --(2) If this card is in your hand: You can send 1 Level 4 or higher
    --    Warrior monster from your Deck or hand to the GY, then send
    --    this card to the GY, then you can Special Summon 1 "Gaia The
    --    Fierce Knight" monster from your GY (once per turn).
    ----------------------------------------------------------------
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,{id,1})  -- "each effect once per turn" part 2
    e2:SetCost(s.sscost)
    e2:SetTarget(s.gytg)
    e2:SetOperation(s.gyop)
    c:RegisterEffect(e2)
end

-- Check for a Level 4 or higher Warrior monster to send to GY
function s.cfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(4) and c:IsAbleToGraveAsCost()
end

-- Shared cost: Send 1 Level 4 or higher Warrior monster from Deck or hand to the GY
function s.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

--------------------------------------------------------------------------
--(1) Special Summon this card from the hand
--------------------------------------------------------------------------
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

--------------------------------------------------------------------------
--(2) Send this card to the GY, then Special Summon 1 "Gaia The Fierce Knight"
--    monster from your GY
--------------------------------------------------------------------------
function s.gaiafilter(c,e,tp)
    return c:IsCode(6368038) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.gaiafilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
        if Duel.IsExistingMatchingCard(s.gaiafilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
            and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,s.gaiafilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
            if #g>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end