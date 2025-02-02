extends DebugPanel

@export var watch_node: Node
@export var watch_list: Array[String]

var node_path_dict: Dictionary[String, NodePath]
var control_prop_list: VBoxContainer

func _ready() -> void:
	visible = false
	
	control_prop_list = %PropList
	for w in watch_list:
		watch_node.get(w)
		# spawn a debug line item child node
		var d:HSplitContainer = HSplitContainer.new()
		d.name = w
		var p:Label = Label.new()
		var v:Label = Label.new()
		p.name = w
		v.name = "value"
		p.text = w
		d.add_child(p)
		d.add_child(v)
		control_prop_list.add_child(d)
		node_path_dict[d.name] = d.get_path()


func _process(_delta: float) -> void:
	if node_path_dict:
		for w in watch_list:
			var line_item: HSplitContainer = control_prop_list.get_node(node_path_dict.get(w))
			for child in line_item.get_children():
				if child.name == "value":
					child.text = watch_node.get(w).name
