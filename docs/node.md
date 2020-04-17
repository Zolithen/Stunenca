# Nodes
A node is the basic building block of Zariel. The nodes are structured in whats known as a scene tree: The master node has no parent, and every other node derives from it in some way.

local node = new_node(parent: node, name: string);
-> name: string; Represents the node's nam
-> x: number; Node's horizontal position.
-> y: number; Node's vertical position.
-> children: {node}
-> parent: node
if parent
-> child_index: number