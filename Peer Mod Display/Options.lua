if not _G.PeerModDisplay then
    _G.PeerModDisplay = {}
    PeerModDisplay._path = ModPath
    PeerModDisplay._data_path = SavePath .. "PeerModDisplay.txt"
    PeerModDisplay._data = {} 

    function PeerModDisplay:Save()
	    local file = io.open( self._data_path, "w+" )
	    if file then
	    	file:write( json.encode( self._data ) )
	    	file:close()
    	end
    end

    function PeerModDisplay:Load()
    	local file = io.open( self._data_path, "r" )
    	if file then
    		self._data = json.decode( file:read("*all") )
    		file:close()
    	end
    end

    function PeerModDisplay:GetOption(id)
	    return self._data[id]
    end
	
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_PeerModDisplay", function( loc )
		local localization = PeerModDisplay._path .. "loc/"
		local GetFiles = _G.file.GetFiles
		local Idstring = _G.Idstring
		local activelanguagekey = SystemInfo:language():key()
		for __, filename in ipairs(GetFiles(localization)) do
			if Idstring(filename:match("^(.*).json$") or ""):key() == activelanguagekey then
				loc:load_localization_file(localization .. filename)
				break
			end
		end
		loc:load_localization_file(localization .. "english.json", false)
	end)

    Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_PeerModDisplay", function( menu_manager )

        MenuCallbackHandler.callback_list_scale = function(self, item)
            PeerModDisplay._data.list_scale = item:value()
		    PeerModDisplay:Save()
        end
		MenuCallbackHandler.callback_list_pos_y = function(self, item) --;)
            PeerModDisplay._data.list_pos_y = item:value()
		    PeerModDisplay:Save()
        end
	    PeerModDisplay:Load()
	    MenuHelper:LoadFromJsonFile( PeerModDisplay._path .. "options/options.json", PeerModDisplay, PeerModDisplay._data )
    end )
end