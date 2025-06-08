SMODS.Joker{
    key = "10ToeJimbo",
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    config = { extra = {
        dollars = 10
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.dollars,
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        if context.after and context.main_eval then
            local chipsThisHand = hand_chips * mult
            local requirement = G.GAME.blind.chips
            if chipsThisHand > requirement then
                return {
                    dollars = 10
                }
            end
        end
    end
}

SMODS.Joker{
    key = "AmusingPark",
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    config = { extra = {
        scaling = 0.1,
        mult = 1,
        poker_hands = {},
        poker_hands_formatted = ""
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.scaling,
            card.ability.extra.mult,
            localize(card.ability.extra.poker_hands, "poker_hands"),
            card.ability.extra.poker_hands_formatted,
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        function updateFormattedList()
            if #card.ability.extra.poker_hands == 0 then
                card.ability.extra.poker_hands_formatted = "None"
            elseif #card.ability.extra.poker_hands == 1 then
                card.ability.extra.poker_hands_formatted = card.ability.extra.poker_hands[1]
            elseif #card.ability.extra.poker_hands == 2 then
                card.ability.extra.poker_hands_formatted = card.ability.extra.poker_hands[1].." and "..card.ability.extra.poker_hands[2]
            else
                for i,v in ipairs(card.ability.extra.poker_hands) do
                    if i == 1 then
                        card.ability.extra.poker_hands_formatted = card.ability.extra.poker_hands[1]
                    elseif i == #card.ability.extra.poker_hands then
                        card.ability.extra.poker_hands_formatted = card.ability.extra.poker_hands_formatted..", and "..v 
                    else
                        card.ability.extra.poker_hands_formatted = card.ability.extra.poker_hands_formatted..", "..v
                    end
                end 
            end
        end
        
        if context.joker_main then
            return {
                Xmult = card.ability.extra.mult
            }
        end

        if context.before and context.main_eval and not context.blueprint then
            local unique = true
            for i,v in ipairs(card.ability.extra.poker_hands) do
                if context.scoring_name == v then
                    unique = false
                    break
                end
            end
            if unique then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.scaling
                card.ability.extra.poker_hands[#card.ability.extra.poker_hands+1] = context.scoring_name
                updateFormattedList()
                return {
                    message = "+X"..card.ability.extra.scaling.." Mult",
                    colour = G.C.MULT
                } 
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
            card.ability.extra.mult = 1
            card.ability.extra.poker_hands = {}
            updateFormattedList()
            return {
                message = localize('k_reset')
            }
        end
    end
}

SMODS.Joker{
    key = "RayBanned",
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    loc_vars = function(self,info_queue,card)
        return {vars = {
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local othercard = context.other_card
            if othercard:is_suit("Hearts") then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                othercard:flip()
                                play_sound('card1', 1)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.2)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                SMODS.change_base(othercard, "Spades")
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message="Ray Banned!",colour = G.C.SUITS.Spades}, othercard)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                othercard:flip()
                                play_sound('tarot2', 1, 0.6)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.5)
                    end
                }
            elseif othercard:is_suit("Diamonds") then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                othercard:flip()
                                play_sound('card1', 1)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.2)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                SMODS.change_base(othercard, "Clubs")
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message="Ray Banned!",colour = G.C.SUITS.Clubs}, othercard)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                othercard:flip()
                                play_sound('tarot2', 1, 0.6)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.5)
                    end
                }
            end
        end
    end
}

SMODS.Joker{
    key = "RedHanded",
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    loc_vars = function(self,info_queue,card)
        return {vars = {
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local othercard = context.other_card
            if othercard:is_suit("Spades") then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                othercard:flip()
                                play_sound('card1', 1)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.2)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                SMODS.change_base(othercard, "Hearts")
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message="Red Handed!",colour = G.C.SUITS.Hearts}, othercard)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                othercard:flip()
                                play_sound('tarot2', 1, 0.6)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.5)
                    end
                }
            elseif othercard:is_suit("Clubs") then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                othercard:flip()
                                play_sound('card1', 1)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.2)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                SMODS.change_base(othercard, "Diamonds")
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message="Red Handed!",colour = G.C.SUITS.Diamonds}, othercard)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                othercard:flip()
                                play_sound('tarot2', 1, 0.6)
                                othercard:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.5)
                    end
                }
            end
        end
    end
}

SMODS.Atlas{
    key = "SunburntSam",
    path = "SunburntSam.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "SunburntSam",
    atlas = "SunburntSam",
    pos = {x = 0, y = 0},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    config = { extra = {
        mult = 3
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.mult,
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local all_correct_suit = true
            for i,v in ipairs(G.hand.cards) do
                if v.base.suit ~= "Hearts" and v.base.suit ~= "Diamonds" then
                    all_correct_suit = false
                end
            end

            if all_correct_suit then
                return {
                    Xmult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Atlas{
    key = "BuccoJimbo",
    path = "BuccoJimbo.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "BuccoJimbo",
    atlas = "BuccoJimbo",
    pos = {x = 0, y = 0},
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,
    config = { extra = {
        dollars = 13,
        planet_max = 3
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {
            card.ability.extra.dollars,
            card.ability.extra.planet_max,
            colours={G.C.DARK_EDITION}
        }}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            local weights = {
                3, -- Joker
                3, -- Tarot
                3, -- Planets
                3, -- Money
                2, -- Spectral
                -- 1 -- Keys
            }

            local totalWeight = 0
            for i,v in ipairs(weights) do
                totalWeight = totalWeight + v
            end

            local random = pseudorandom("flor_buccojimbo",1,totalWeight)

            local itemIndex = 0
            for i,v in ipairs(weights) do
                if random > v then
                    random = random - v
                else
                    itemIndex = i
                    break
                end
            end

            if itemIndex == 1 then
                SMODS.calculate_effect({message="Joker!",colour = G.C.FILTER}, card)
                SMODS.add_card({set = "Joker",soulable = true})
                return
            elseif itemIndex == 2 then
                SMODS.calculate_effect({message="Tarot!",colour = G.C.FILTER}, card)
                SMODS.add_card({set = "Tarot",soulable = true})
                return
            elseif itemIndex == 3 then
                SMODS.calculate_effect({message="Planets!",colour = G.C.FILTER}, card)
                local planetRandom = pseudorandom("flor_buccojimbo_planets",1,card.ability.extra.planet_max)
                for count = 1,planetRandom,1 do
                    SMODS.add_card({set = "Planet",soulable = true})
                end
                return
            elseif itemIndex == 4 then
                SMODS.calculate_effect({message="Money!",colour = G.C.FILTER}, card)
                return {
                    dollars = 10
                }
            elseif itemIndex == 5 then
                SMODS.calculate_effect({message="Spectral!",colour = G.C.FILTER}, card)
                SMODS.add_card({set = "Spectral",soulable = true})
                return
            else
                SMODS.calculate_effect({message="Keys!",colour = G.C.DARK_EDITION}, card)
                -- add the functionality for this once the keys are made, keys are currently unobtainable using buccojimbo due to the keys weight being commented out
            end
        end
    end
}
