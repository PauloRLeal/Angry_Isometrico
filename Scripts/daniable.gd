extends RigidBody2D

export (int, 1, 10000) var vida = 10

var velocidade_dano : Vector2
var velocidade_angular : float

onready var vida_maxima = vida

func _ready():
	pass
	
func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	var quantidade_contatos = {}
	for i in range(0, state.get_contact_count()):
		var id_contato = state.get_contact_collider_id(i)
		if (state.get_contact_collider_object(i).get_name() == "Personagem"):
			print("Venceu!!!!!")
		if !quantidade_contatos.has(id_contato):
			quantidade_contatos[id_contato] = 1
		else:
			quantidade_contatos[id_contato] += 1
	
	for i in range(0, state.get_contact_count()):
		var contato = state.get_contact_collider_object(i)
		var velocidade_contato = state.get_contact_collider_velocity_at_position(i)
		var L = global_position - state.get_contact_local_position(i)
		var slef_velocity = velocidade_dano - velocidade_angular * Vector2(-L.y, L.x)
		var V = velocidade_contato - slef_velocity
		var massa = self.mass
		var massa_corpo = contato.mass if contato is RigidBody2D else 100000000000
		var P = V.dot(state.get_contact_local_normal(i)) * (massa_corpo / (massa + massa_corpo)) / quantidade_contatos[contato.get_instance_id()]
		
		receber_dano(P * 0.06)
	
func _physics_process(delta : float) -> void:
	velocidade_dano = linear_velocity
	velocidade_angular = angular_velocity

#func _on_daniable_body_entered(body):
#	receber_dano(velocidade_dano.length())
	
func receber_dano(quant : float):
	quant = round(quant)
	
	if quant > 0:
		vida -= quant
		atualizar_animacao()
		if vida <= 0:
			queue_free()
			
			
func atualizar_animacao():
	if $anim.get_animation_list().size() > 0:
		var h_radio = float(vida) / float(vida_maxima)
		var atual_animacao = ceil(h_radio * $anim.get_animation_list().size()) - 1
		$anim.play($anim.get_animation_list()[atual_animacao])
	
	
	
	
	
	
	
	
	
	
