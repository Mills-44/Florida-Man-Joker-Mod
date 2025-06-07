-- Announce our loading in console...
sendInfoMessage("Florida!", "FloridaMod")

-- Set our presence for reference later or by others.
floridamod = SMODS.current_mod

-- Set up folder loading...
local NFS = require("nativefs")
local function load_folder(folder)
	local files = NFS.getDirectoryItems(floridamod.path..folder)
	for _, file in ipairs(files) do
		local item = folder.."/"..file
		sendInfoMessage("Loading "..item.."...", "FloridaMod")
		assert(SMODS.load_file(item))()
	end
end

-- ...and load the items of desired folders.
load_folder("items/jokers")