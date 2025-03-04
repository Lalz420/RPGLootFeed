local addonName = G_RLF.addonName
local acd = LibStub("AceConfigDialog-3.0")
RLF = G_RLF.RLF
G_RLF.L = LibStub("AceLocale-3.0"):GetLocale(G_RLF.localeName)

function RLF:OnInitialize()
	G_RLF.db = LibStub("AceDB-3.0"):New(G_RLF.dbName, G_RLF.defaults, true)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, G_RLF.options)
	G_RLF.LootDisplay:Initialize()
	self:Hook(acd, "Open", "OnOptionsOpen")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterChatCommand("rlf", "SlashCommand")
	self:RegisterChatCommand("RLF", "SlashCommand")
	self:RegisterChatCommand("rpglootfeed", "SlashCommand")
	self:RegisterChatCommand("rpgLootFeed", "SlashCommand")
end

function RLF:SlashCommand(msg, editBox)
	if msg == "test" then
		G_RLF.TestMode:ToggleTestMode()
	elseif msg == "clear" then
		G_RLF.LootDisplay:HideLoot()
	else
		acd:Open(addonName)
	end
end

function RLF:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	if self.optionsFrame == nil then
		self.optionsFrame = acd:AddToBlizOptions(addonName, addonName)
	end
	self:LootToastHook()
	self:BossBannerHook()
	if isLogin and isReload == false then
		self:Print(G_RLF.L["Welcome"])
		if G_RLF.db.global.enableAutoLoot then
			C_CVar.SetCVar("autoLootDefault", "1")
		end
	end
end

local optionsFrame
local isOpen = false
function RLF:OnOptionsOpen(...)
	local _, name, container, path = ...
	if name == addonName and not isOpen then
		isOpen = true
		G_RLF.LootDisplay:SetBoundingBoxVisibility(true)
		self:ScheduleTimer(function()
			optionsFrame = acd.OpenFrames[name]
			if self:IsHooked(optionsFrame, "Hide") then
				self:Unhook(optionsFrame, "Hide")
			end
			self:Hook(optionsFrame, "Hide", "OnOptionsClose", true)
		end, 0.25)
	end
end

function RLF:OnOptionsClose(...)
	isOpen = false
	G_RLF.LootDisplay:SetBoundingBoxVisibility(false)
	self:Unhook(optionsFrame, "Hide")
	optionsFrame = nil
end
