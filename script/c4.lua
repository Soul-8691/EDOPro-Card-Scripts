--Replace FLAME_ID, DARKFLARE_ID, and DARKFLARE_SWORDSMAN_ID with the actual card IDs.
local s,id=GetID()
function s.initial_effect(c)
    ----------------------------------------------------------------
    -- (1) Each "Flame Swordsman", "Dark Flare Knight", and
    --     "Dark Flare Swordsman" you control (except this card) gains 300 ATK
    ----------------------------------------------------------------
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.atktg)
    e1:SetValue(300)
    c:RegisterEffect(e1)
    
    ----------------------------------------------------------------
    -- (2) Discard this card from your hand; Special Summon 1
    --     "Flame Swordsman" from your Extra Deck
    ----------------------------------------------------------------
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,id)
    e2:SetCost(s.spcost)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    
    ----------------------------------------------------------------
    -- (3) Tribute this card; Special Summon 1 "Dark Flare Knight"
    --     from your Extra Deck
    ----------------------------------------------------------------
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,{id,1})
    e3:SetCost(s.spcost2)
    e3:SetTarget(s.sptg2)
    e3:SetOperation(s.spop2)
    c:RegisterEffect(e3)
end

--(1) ATK Gain Target
function s.atktg(e,c)
    return c:IsFaceup()
       and (c:IsCode(45231177) or c:IsCode(13722870) or c:IsCode(4))
       and c~=e:GetHandler()
end

--(2) Discard from hand cost
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.spfilter1(c,e,tp)
    return c:IsCode(45231177) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCountFromEx(tp)>0
           and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end

--(3) Tribute this card
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end

function s.spfilter2(c,e,tp)
    return c:IsCode(13722870) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
           and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())<=0 then return end
    local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end