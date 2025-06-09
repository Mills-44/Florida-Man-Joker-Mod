SMODS.Atlas {
    key = "jawsome", 
    path = "jawsome.png", 
    px = 71, 
    py = 95
}

SMODS.Joker{
	key = 'liftoff',
	unlocked = true,
	discovered = true,
	rarity = 1,
	cost = 5,
	atlas = 'jawsome',
	pos = { x = 0, y = 0 },
    config = {
        extra = {
            gain = 5
        }
    },
    loc_vars = function(self, info_queue, card)
      return {
        vars = {
          card.ability.extra.gain,
        }
      }
    end,
	calculate = function(self, card, context)
            if context.joker_main and next(context.poker_hands["Straight"] )then
                local ace_five = 0
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 14 then ace_five = ace_five + 1 end
                end
                if ace_five >= 1 and next(context.poker_hands["Straight"]) then
                    card.ability.extra.gain = card.ability.extra.gain + 1
                end
                ease_dollars(tonumber(card.ability.extra.gain))
                return
                {
                    message = "+$" .. tostring(card.ability.extra.gain) .. "!",
                    colours = G.C.GOLD
                }
            end
    end
}