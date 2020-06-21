# Nodes
# The scene graph
Zariel uses whats known as an "scene graph" to structure itself. An scene graph consists of a node that has no parent, node which have parent and children and nodes which only have parent. Each scene has one node with no parent (the master node).

# Node()
local node = Node(parent: node, name: string, x: number, y: number);
-> parent: node; The node's parent.
-> name: string; Represents the node's name.
-> x: number; Node's horizontal position.
-> y: number; Node's vertical position.

# Node class
node.parent: node; The node's parent, if it has one.
node.x: number; The node's X position.
node.y: number; The node's Y position.
node.name: string; The node's number. This is an unique identifier of the node (multiple children of a node can have the same name).
node.childs: number; The total number of nodes which have this node in their parent tree.
node.uuid: string; An unique identifier for the node.
node.child_index: number; The position of this node in the parent's children if it has.