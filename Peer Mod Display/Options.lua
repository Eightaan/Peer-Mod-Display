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
	    loc:load_localization_file( PeerModDisplay._path .. "loc/en.txt")
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