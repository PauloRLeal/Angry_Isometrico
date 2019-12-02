extends Camera2D

export var VELOCIDADE = 2
export (float, 0.5, 5) var minimo_zoom = 1
export (float, 1, 10) var maximo_zoom = 1.5
export (int, 1, 10) var vel_zoom = 2

var drag_cam : bool
var ult_pos : Vector2

func _ready():
	pass
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("mover_camera"):
		drag_cam = true
		ult_pos = mouse_pos
	if Input.is_action_just_released("mover_camera"):
		drag_cam = false
		
	if drag_cam == true:
		var posicion_raton = (ult_pos - mouse_pos) * VELOCIDADE
		position = clamp_position(position + posicion_raton)
		ult_pos = mouse_pos
		
func clamp_position (pos : Vector2) -> Vector2:
	var radio_viewport = get_viewport_rect().size / 2 * zoom
	pos.x = clamp(pos.x, limit_left + radio_viewport.x, limit_right - radio_viewport.x)
	pos.y = clamp(pos.y, limit_top + radio_viewport.y, limit_bottom - radio_viewport.y)
	return pos
	
func _input(event: InputEvent) -> void:
	var z = zoom.x
	if event.is_action("zoom_in"):
		z -= 0.02 * vel_zoom
		
	if event.is_action("zoom_out"):
		z += 0.02 * vel_zoom
	
	z = clamp(z, minimo_zoom, maximo_zoom)
	zoom = Vector2(z, z)
	
	
	
	
	
	
	
	
	
	
	