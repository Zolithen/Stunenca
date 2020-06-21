GuiState.FileDialog = {}

GuiState.FileDialog.CustomN = false;
GuiState.FileDialog.CustomNMes = false;

function LoadCustomNode()
	if GuiState.FileDialog.CustomN then
		local Result = Slab.FileDialog({Type = 'openfile'})

		if Result.Files[1] then
			print("found file: " .. Result.Files[1]);
			GuiState.FileDialog.CustomN = false
			local nc = dofile(Result.Files[1]);
			if class.isClass(nc) then
				nc(GuiState.NND.MasterNode, nc.defname, 0, 0);
			else
				GuiState.FileDialog.CustomNMes = true;
			end
		elseif Result.Button ~= "" then
			GuiState.FileDialog.CustomN = false
		end
	end

	if GuiState.FileDialog.CustomNMes then
		local Result = Slab.MessageBox("Error", "Couldn't add node: File didnt return a class.")
		if Result ~= "" then
			GuiState.FileDialog.CustomNMes = false
		end
	end
end