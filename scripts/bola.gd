extends CharacterBody2D

var direcao    = 1 # 1 = direita, -1 = esquerda
var velocidade = 650
var gravidade  = 1200


func _ready():
	velocity.x = velocidade * direcao
	velocity.y = -250


func _physics_process(delta):
	velocity.y += gravidade * delta
	$Sprite2D.rotation += 15 * direcao * delta

	var colisao = move_and_collide(velocity * delta)
	if colisao:
		var objeto = colisao.get_collider()
		if objeto.has_method("levar_dano"):
			objeto.levar_dano(direcao)
			queue_free()
		else:
			# quica no chao / parede e perde um pouco de forca
			velocity = velocity.bounce(colisao.get_normal()) * 0.6


func _on_timer_timeout():
	queue_free()
