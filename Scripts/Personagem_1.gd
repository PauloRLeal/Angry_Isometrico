extends "res://Scripts/daniable.gd"

export (int, 100, 500) var vel_transferencia = 100

enum {
	ESTADO_QUIETO,
	ESTADO_TRANSFERIR,
	ESTADO_TOMADO,
	ESTADO_ARRASTADO,
	ESTADO_RELEASED,
	ESTADO_LANCADO
}

var estado = ESTADO_QUIETO
var impulso =null
var gomera = null

func _ready():
	pass
	
func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	._integrate_forces(state)
	if state.get_contact_count() > 0 && estado == ESTADO_LANCADO:
		estado = ESTADO_QUIETO
	var pos_lancado = gomera.get_node("Pos_saida").get_global_position()
	var diff_pos = pos_lancado - get_global_position()
	if Input.is_action_just_released("touch") && estado == ESTADO_ARRASTADO:
		impulso = gomera.obter_impulso() #diff_pos * 0.06
		if impulso.x > 0:
			estado = ESTADO_RELEASED
		else:
			estado = ESTADO_TOMADO
	var vl = state.linear_velocity
	var va = state.angular_velocity
	var delta = (1 / state.step)
	
	match estado:
		ESTADO_TRANSFERIR:
			if diff_pos.length() < vel_transferencia / delta:
				vl = diff_pos * delta
				estado = ESTADO_TOMADO
				gomera.tomar_o_personagem(self)
			else:
				vl = diff_pos.normalized() * vel_transferencia #* delta
		ESTADO_TOMADO:
			vl = diff_pos * 20 # delta * 0.3
			va = -rotation * delta
		ESTADO_ARRASTADO:
			var forca = get_global_mouse_position() - pos_lancado
			var angulo = diff_pos.angle()
			va = (angulo - rotation) * delta
			if angulo < -1.2 && angulo > -2:
				forca = forca.clamped(10)
			else:
				forca = forca.clamped(100)
			vl = (forca + diff_pos) * 20 #0.03 * delta
		ESTADO_RELEASED:
			if diff_pos.length() < impulso.length() / delta:
				estado = ESTADO_LANCADO
				gomera.soltar_o_personagem()
			else:
				vl = diff_pos.normalized() * impulso.length()  #* delta
		ESTADO_LANCADO:
			pass
			
	state.linear_velocity = vl 
	state.angular_velocity = va
	
func agregar_a(gomera):
	self.gomera = gomera
	estado = ESTADO_TRANSFERIR
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("touch") && estado == ESTADO_TOMADO:
		estado = ESTADO_ARRASTADO
		
	
	
	
	
	
	
	
	
	
	
	