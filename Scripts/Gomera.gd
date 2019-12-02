tool
extends Node2D

export (PackedScene) var ponto_trajetoria
export (int, 1, 10) var impulso = 4
export (int, 5, 15) var quantidade_ponto_trajetoria = 5
export (float, 0.2, 1, 0.1) var separacao = 0.5
export (int, 10, 100) var impulso_trajetoria = 70
export (int, -90, 90) var angulo_trajetoria = 45
export var trajetoria_visivel: bool = true

var Personagem
var script_personagem = preload("res://Scripts/Personagem_1.gd")

func _ready():
	$trajetoria.position = $Pos_saida.position
	
func _process(delta):
	for sp in $trajetoria.get_children():
		sp.queue_free()
	if Engine.is_editor_hint() && trajetoria_visivel:
		desenhar_trajetoria_do_impulso(Vector2(impulso_trajetoria * impulso, 0).rotated(deg2rad(-angulo_trajetoria)))
	else:
		atualizar_elastico($elastico_1)
		atualizar_elastico($elastico_2)
		var impul = obter_impulso()
		if Personagem && Personagem.estado == script_personagem.ESTADO_ARRASTADO && impul.x > 0:
			desenhar_trajetoria_do_impulso(impul)
	
func atualizar_elastico(elastico):
	var pos_tomado = Personagem.get_node("pos").get_global_position() if Personagem else $Pos_saida.get_global_position()
	var pos_dif = pos_tomado - elastico.get_node("friccion").get_global_position()
	var medio = pos_dif / 2
	var imagem = elastico.get_node("img")
	imagem.position = medio
	imagem.scale.x = -medio.length() * 0.009
	imagem.rotation = medio.angle()
	
func tomar_o_personagem(personagem):
	Personagem = personagem
	
func soltar_o_personagem():
	Personagem = null
	
func obter_impulso():
	if Personagem == null:
		return
	return ($Pos_saida.global_position - Personagem.global_position) * impulso
	
func desenhar_trajetoria_do_impulso(impulso):
	var gravidade = ProjectSettings.get("physics/2d/default_gravity")
	
	for i in range(1, quantidade_ponto_trajetoria):
		var t = i * separacao
		var x = impulso.x * t
		var y = gravidade * t * t / 2 + impulso.y * t
		desenhar_ponto(Vector2(x, y))
	
func desenhar_ponto(lugar):
	var sp = ponto_trajetoria.instance()
	sp.position = lugar
	$trajetoria.add_child(sp)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	