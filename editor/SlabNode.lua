SlabDebug = require "eng/Slab/SlabDebug"

require "editor/LoadCustomNode"

GuiState.NND = {};

egui.selected_node = nil;

-- helper functions
-- deletes the selected node
function slab_selnode_delete()
	if egui.selected_node and egui.selected_node.parent then
		if #egui.selected_node.parent.children == 1 and egui.selected_node.parent.parent == nil then

		else
			egui.selected_node:remove();
			egui.selected_node = nil;
			--[[Slab = nil;
			Slab = require "eng/Slab"]]
			Slab.ClearCache();
		end
	end
end

-- shows a zariel tree as an slab tree
function zariel_as_slab(n)
	if table.is_empty(n.children) then
		print("Leaf", n.name);
		Slab.BeginTree(n.name..n.uuid, {Label = n.name, IsLeaf=true});
		if Slab.IsControlClicked(1) then
			egui.selected_node = n;
		end
	else
		if Slab.BeginTree(n.name..n.uuid, {Label = n.name, OpenWithHighlight=false}) then
			print("Begin", n.name);
			if Slab.IsControlClicked(1) then
				egui.selected_node = n;
			end
			for i, v in ipairs(n.children) do
				zariel_as_slab(v);
			end
			print("End", n.name);
			Slab.EndTree();
		else
			if Slab.IsControlClicked(1) then
				egui.selected_node = n;
			end
		end
	end
end

function Slab.IsKeyZarielInternal(k)
	return (k == "childs") or
		   (k == "child_index") or
		   (k == "children") or
		   (k == "class") or
		   (k == "parent") or
		   (k == "super") or
		   (k == "uuid")
end

function Slab.ZarielProperty(Table, K, V)
	--print("Property: " .. K);
	local Type = type(V)
	if Type == "boolean" and not Slab.IsKeyZarielInternal(K) then
		if Slab.CheckBox(V, K) then
			Table[K] = not Table[K]
		end
	elseif Type == "number" and not Slab.IsKeyZarielInternal(K) then
		Slab.Text(K .. ": ")
		Slab.SameLine()
		if Slab.Input(K, {Text = tostring(V), NumbersOnly = true, ReturnOnText = false}) then
			Table[K] = Slab.GetInputNumber()
		end
	elseif Type == "string" and not Slab.IsKeyZarielInternal(K) then
		Slab.Text(K .. ": ")
		Slab.SameLine()
		if Slab.Input(K, {Text = V, ReturnOnText = false}) then
			Table[K] = Slab.GetInputText()
		end
	elseif Type == "table" and not Slab.IsKeyZarielInternal(K) then
		--Slab.ZarielProperties(V);
		Slab.Text(K);
		if V[1] then -- table is array
			Slab.ZarielArrayProperties(K, V);
		else 
		end
	end
end

-- Slab.properties but for arrays and excludes internal zar values
function Slab.ZarielArrayProperties(Name, Table)
	if Table ~= nil then
		Slab.BeginListBox("ListBox"..Name)
		for K, V in ipairs(Table) do
			Slab.BeginListBoxItem("ListBox"..Name..K)
			Slab.ZarielProperty(Table, K, V)
			Slab.EndListBoxItem()
		end
		Slab.EndListBox()
	end
end

-- Slab.Properties but excludes internal zariel values
function Slab.ZarielProperties(Table)
	if Table ~= nil then
		for K, V in pairs(Table) do
			Slab.ZarielProperty(Table, K, V)
		end
	end
end

GuiState.NND.Is = false;
GuiState.NND.Selected = "";
GuiState.NND.CustomAdd = false;
GuiState.NND.MasterNode = nil;

function Slab.NewNodeDialogSelectable(a)
	Slab.BeginTree(a, {IsLeaf=true});
	if Slab.IsControlClicked() then
		GuiState.NND.Selected = a
	end
end

function Slab.NewNodeDialog()
	if not GuiState.NND.Is then return; end
	Slab.BeginWindow("NewNodeDialog", {Title="New node"})

	if Slab.BeginTree("New node...") then
		Slab.NewNodeDialogSelectable("Default");
		Slab.NewNodeDialogSelectable("Custom");
		Slab.EndTree();
	end

	Slab.Separator();
	Slab.Text("Selected: " .. GuiState.NND.Selected);

	if GuiState.NND.Selected == "Custom" then
		if Slab.CheckBox(GuiState.NND.CustomAdd, "Add custom node to list") then
			GuiState.NND.CustomAdd = not GuiState.NND.CustomAdd;
		end
	end

	if Slab.Button("Select") then
		GuiState.NND.Is = false;
		if GuiState.NND.Selected == "Default" then
			Node(GuiState.NND.MasterNode, "node", 0, 0);
		else
			GuiState.FileDialog.CustomN = true;
		end
	end

	Slab.EndWindow();
end


SlabNode = Node:extend("Slab");

function SlabNode:init(args)
	SlabNode.super.init(self, egui, "SlabGUI", 0, 0);
	love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	Slab.SetINIStatePath(nil)
	Slab.Initialize(args)
end

function SlabNode:update(dt)
	Slab.Update(dt)



	Slab.BeginWindow('ZarielTree', {
		Title = "Scene graph", 
		AutoSizeWindow = false,
		AllowResize = true,
		AllowMove = true,
		ResetContent = true,
		--ResetLayout = true
	})
	
	Slab.BeginLayout("ZarielTreeLayout");

	zariel_as_slab(scene);

	Slab.EndLayout();
	Slab.Separator();
	if Slab.Button("Add children") and egui.selected_node then
		--Node(egui.selected_node, "node", 0, 0);
		GuiState.NND.MasterNode = egui.selected_node;
		GuiState.NND.Is = true;
	end
	if Slab.Button("Delete") then
		slab_selnode_delete()
	end

    Slab.EndWindow()



    Slab.BeginWindow("Inspector", {Title = "Inspector"});

    Slab.Separator();
    Slab.ZarielProperties(egui.selected_node or {});

    Slab.EndWindow();

    Slab.NewNodeDialog();

    LoadCustomNode()

    --[[if Slab.BeginMainMenuBar() then

		SlabDebug.Menu()

		Slab.EndMainMenuBar()
	end

	SlabDebug.Begin()]]
end

function SlabNode:draw()
	Slab.Draw();
end

function SlabNode:keypressed(k)
	if k == "delete" then 
		slab_selnode_delete()
	end
end

