-- TheOneGoofAli was here!
SMODS.Atlas{key = "FloridaJawsome", path = "jawsome.png", px = 71, py = 95}

SMODS.Joker{
	key = 'jawsome',
	unlocked = true,
	discovered = true,
	rarity = 2,
	cost = 4,
	atlas = 'FloridaJawsome',
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		if context.skip_blind then
			if #G.jokers.cards > 0 then
				local jokerlist, itercount, iterlimit = G.jokers.cards, 0, 64
				local seljoker = pseudorandom_element(jokerlist, pseudoseed('floridajawz'))
				while seljoker.edition and itercount < iterlimit do
					itercount = itercount + 1
					seljoker = pseudorandom_element(jokerlist, pseudoseed('floridajawz'))
				end
				
				if not seljoker.edition then
					local seledition = poll_edition('floridamen', nil, false, true)
					seljoker:set_edition(seledition, true)
					return { message = localize('k_upgrade_ex'), message_card = seljoker }
				else
					return { message = localize('k_nope_ex') }
				end
			end
		end
	end
}