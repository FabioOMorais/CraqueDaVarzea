extends Area2D

# Cartao jogado pelo arbitro. Se o jogador der uma cabecada nele,
# o cartao volta e acerta os inimigos.

var direcao    = 1
var velocidade = 420
var vermelho   = false
var rebatido   = false


func _ready():
	if vermelho:
		$Sprite2D.texture = preload("res://assets/cartao_vermelho.png")


func _physics_process(delta):
	position.x += velocidade * direcao * delta
	$Sprite2D.rotation += 12 * direcao * delta


func rebater(nova_direcao):
	if rebatido:
		return
	rebatido = true
	direcao = nova_direcao
	velocidade = 650
	$Sprite2D.modulate = Color(0.6, 1, 0.6)


func _on_body_entered(body):
	if body == Global.jogador:
		if not rebatido:
			if vermelho:
				body.receber_dano(2, global_position.x)
			else:
				body.receber_dano(1, global_position.x)
			queue_free()
	elif body.has_method("levar_dano"):
		if rebatido:
			body.levar_dano(direcao)
			queue_free()
	else:
		# bateu em parede ou plataforma
		queue_free()


func _on_timer_timeout():
	queue_free()
