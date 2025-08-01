-- Chat tags for TEDED Matchmaking Lobby
-- Made by SirKingBinx

local Services = {
	Players = game:GetService("Players"),
	TextChatService = game:GetService("TextChatService"),
	ReplicatedStorage = game:GetService("ReplicatedStorage")
}

-- Note: Tag priority is calculated in order of the table.
--       Tags at the start of the table have more priority than tags at the end of the list.
local Tags = {
	{
		Tag = "Developer",
		Color = Color3.fromRGB(33, 123, 162),
		-- Owners accept:
		-- Tables of UserIDs and/or Names
		-- A function returning true or false (plr) -> (bool)
		Owners = {game.CreatorId},
	},
	{
		Tag = "#1 Doors",
		Color = Color3.fromRGB(255, 238, 56),
		Owners = function(plr: Player)
			local topPlayer = Services.ReplicatedStorage.Leaderstats.TopPlayer:InvokeServer("Doors")
			return tostring(plr.UserId) == tostring(topPlayer)
		end,
	},
	{
		Tag = "#1 Deaths",
		Color = Color3.fromRGB(255, 238, 56),
		Owners = function(plr: Player)
			local topPlayer = Services.ReplicatedStorage.Leaderstats.TopPlayer:InvokeServer("Deaths")
			return tostring(plr.UserId) == tostring(topPlayer)
		end,
	},
	{
		Tag = "Admin",
		Color = Color3.fromRGB(255, 25, 25),
		Owners = {8275682881, 4301624135},
	},
	{
		Tag = "YouTube",
		Color = Color3.fromRGB(218, 0, 4),
		Owners = {339310190, 140258990, 22207531},
	},
	{
		Tag = "Beta Tester",
		Color = Color3.fromRGB(255, 82, 39),
		Owners = {8275682881, 4301624135, 3170371006, 137762328, 2700529611, 4206985010, 3082895890, 3794365190},
	}
}

local function CalculateChatTagsForPlayer(player: Player)
	for priority, tagInfo in Tags do
		local isOwning = 
			(typeof(tagInfo.Owners) == "table" and (table.find(tagInfo.Owners, player.UserId) or table.find(tagInfo.Owners, player.Name))
			or (typeof(tagInfo.Owners) == "function" and tagInfo.Owners(player) == true)	
		)
		
		if isOwning then
			return tagInfo
		end
	end
end

Services.TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	local NetPlayer = Services.Players:GetPlayerByUserId(message.TextSource.UserId)
	local tagInfo = CalculateChatTagsForPlayer(NetPlayer)
	local props = Instance.new("TextChatMessageProperties")

	if tagInfo then
		props.PrefixText = string.format("<font color=\"#%s\">[%s] %s</font>", tagInfo.Color:ToHex(), tagInfo.Tag, message.PrefixText)
		return props
	end
end
