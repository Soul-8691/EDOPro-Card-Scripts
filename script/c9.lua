local s,id=GetID()
function s.initial_effect(c)
    -- Activate (Field Spell)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- (1) Boost "The Wicked Worm Beast" by 500 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.atktg)
    e1:SetValue(500)
    c:RegisterEffect(e1)

    -- (2) Once per turn: Tribute "Wicked Worm Beast" to Special Summon a Level 5 or 6 monster from hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end

-- ATK boost target: "The Wicked Worm Beast"
function s.atktg(e,c)
    return c:IsCode(6285791) and c:IsFaceup()
end

-- Helper filter: face-up "The Wicked Worm Beast"
function s.wormfilter(c)
    return c:IsFaceup() and c:IsCode(6285791)
end

-- Can only be used if you control a face-up Wicked Worm Beast
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.wormfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- Filter: Level 5 or 6 monster that can be Special Summoned
function s.spfilter(c,e,tp)
    return c:IsLevelAbove(5) and c:IsLevelBelow(6)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- Tribute 1 Wicked Worm Beast to Special Summon Level 5/6 monster from hand
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.wormfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local tribute=Duel.SelectMatchingCard(tp,s.wormfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
    if not tribute or Duel.Release(tribute,REASON_COST)==0 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
