function create_spritesheet_editor()
	scene = new_node(nil, "scene");
	new_node_tree_viewer(scene, "tree_viewer", 0.2, 0.2, 0.2, 0.2, scene);
	
end

create_spritesheet_editor()