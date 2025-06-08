SMODS.Joker{
    key = "10ToeJimbo",
    loc_txt = {
        name = "10 Toe Jimbo",
        text = {
            "Gain {C:money}$#1#{} if the",
            "played hand is {C:attention}On Fire{}",
            "{s:0.5} {}",
            "{B:1,C:white,s:0.75,E:1}Code: CGNik",
            "{B:1,C:white,s:0.75,E:1}Art: -----",
            "{B:1,C:white,s:0.75,E:1}Idea: InfamousInvictis"
        },
    },
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
    loc_txt = {
        name = "Amusing Park",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult per {C:attention}unique{} poker hand played this {C:attention}Ante{}",
            "{C:inactive}(Currently {}{X:mult,C:white}X#2#{}{C:inactive} Mult){}",
            "{C:inactive}(Poker Hands played: #4#){}",
            "{s:0.5} {}",
            "{B:1,C:white,s:0.75,E:1}Code: CGNik",
            "{B:1,C:white,s:0.75,E:1}Art: -----",
            "{B:1,C:white,s:0.75,E:1}Idea: InfamousInvictis"
        },
    },
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
    key = "Ray Banned",
    loc_txt = {
        name = "Ray Banned",
        text = {
            "Played {C:hearts}Hearts{} and {C:diamonds}Diamonds{} turn into",
            "{C:spades}Spades{} and {C:clubs}Clubs{} respectively",
            "{s:0.5} {}",
            "{B:1,C:white,s:0.75,E:1}Code: CGNik",
            "{B:1,C:white,s:0.75,E:1}Art: -----",
            "{B:1,C:white,s:0.75,E:1}Idea: InfamousInvictis"
        },
    },
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
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit("Hearts") then
                SMODS.change_base(context.other_card, "Spades")
            elseif context.other_card:is_suit("Diamonds") then
                SMODS.change_base(context.other_card, "Clubs")
            end
        end
    end
}

SMODS.Joker{
    key = "Red Handed",
    loc_txt = {
        name = "Red Handed",
        text = {
            "Played {C:spades}Spades{} and {C:clubs}Clubs{} turn into",
            "{C:hearts}Hearts{} and {C:diamonds}Diamonds{} respectively",
            "{s:0.5} {}",
            "{B:1,C:white,s:0.75,E:1}Code: CGNik",
            "{B:1,C:white,s:0.75,E:1}Art: -----",
            "{B:1,C:white,s:0.75,E:1}Idea: InfamousInvictis"
        },
    },
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
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit("Spades") then
                SMODS.change_base(context.other_card, "Hearts")
            elseif context.other_card:is_suit("Clubs") then
                SMODS.change_base(context.other_card, "Diamonds")
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
    loc_txt = {
        name = "Sunburnt Sam",
        text = {
            "{X:mult,C:white}X#1#{} Mult if all cards {C:attention}held in hand{}",
            "are {C:hearts}Hearts{} or {C:diamonds}Diamonds{}",
            "{s:0.5} {}",
            "{B:1,C:white,s:0.75,E:1}Code: CGNik",
            "{B:1,C:white,s:0.75,E:1}Art: gfsgfsgfs",
            "{B:1,C:white,s:0.75,E:1}Idea: InfamousInvictis"
        },
    },
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

-- add an anim to Ray Banned and Red Handed