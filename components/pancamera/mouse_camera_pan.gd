extends Camera2D
class_name PanCamera

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_action("pan_camera"):
		get_viewport().set_input_as_handled();
		if event.is_pressed():
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_viewport().set_input_as_handled();
		position += (_previousPosition - event.position);
		_previousPosition = event.position;
