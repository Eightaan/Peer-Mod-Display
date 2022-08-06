local close_person_joining_original = MenuManager.close_person_joining

function MenuManager:show_person_joining(id, nick, join_start)
	if not managers.hud or not managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2).panel:child("user_dropin" .. id) then
		return
	end
	
	self.peer_join_start_t = self.peer_join_start_t or {}
	self.peer_join_start_t[id] = os.clock()
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
    local peer = managers.network:session():peer(id)
	if not self._person_joining then
		self._person_joining = join_start or os.clock()
	    local panel = hud.panel:panel({name = "user_dropin" .. id, layer = 10000})
	
	    local scale = PeerModDisplay:GetOption("list_scale") or 1
	    local mod_y = PeerModDisplay:GetOption("list_pos_y") or 0

	    if peer and peer:synced_mods() and #peer:synced_mods() > 0 then 
		    local modslist_panel = panel:panel({name = "modslist_panel", x = -15})
			modslist_panel:text({
				name = "mods_title",
				font_size = 25 * scale,
				font = tweak_data.menu.pd2_large_font,
				text = managers.localization:text("menu_players_list_mods"),
				align = "right",
				y = 40 + mod_y,
				layer = 2,
				color = Color.white
			})
	        local last_mod
		    self._joining_mods = {}
			for i, mod in ipairs(peer:synced_mods()) do
				last_mod = modslist_panel:text({
					name = "mod_" .. tostring(i),
					font_size = 18 * scale,
					font = tweak_data.menu.pd2_large_font,
					text = mod.name,
					align = "right",
					y = (i-1) * (18 * scale) + 70 + mod_y,
					layer = 2,
					color = Color.white
				})
				managers.hud:make_fine_text(last_mod)
				last_mod:set_right(modslist_panel:w())
				table.insert(self._joining_mods, last_mod)
			end
			
			if last_mod then
				modslist_panel:set_h(last_mod:bottom())
			end
		end
	else
		self._joining_queue = self._joining_queue or {}
		table.insert(self._joining_queue, {id = id, nick = nick, join_start = os.clock()})
	end

	local level_string, _ = managers.experience:gui_string(peer:level(), peer:rank())
	local dialog_data = {
		title = string.upper("(" .. level_string .. ") " .. nick),
		text = managers.localization:text("dialog_wait") .. " 0%",
		id = "user_dropin" .. id,
		no_buttons = true
	}

	managers.system_menu:show(dialog_data)
end
	
function MenuManager:close_person_joining(id, ...)
	if not managers.hud or not managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) then
		return
	end
	
	local hud =	managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local panel = hud.panel:child("user_dropin" .. id)
	
	if panel then
		managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2).panel:remove(panel)
		self._person_joining = nil
		if self._joining_queue and self._joining_queue[1] then
			local joining = self._joining_queue[1]
			self:show_person_joining(joining.id, joining.nick, joining.join_start)
			table.remove(self._joining_queue, 1)
		end
	    self._joining_mods = nil
	elseif self._joining_queue then
		for i, data in pairs(self._joining_queue) do
			if data.id == id then
				table.remove(self._joining_queue, i)
			end
		end		
	end
	close_person_joining_original(self, id, ...)
end