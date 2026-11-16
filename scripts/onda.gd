extends Area2D

# Onda de choque que o chefao solta quando bate no chao.

var direcao    = 1
var velocidade = 380


func _ready():
	$Sprite2D.flip_h = (direcao == -1)


func _physics_process(delta):
	position.x += velocidade * direcao * delta


func _on_body_entered(body):
	if body == Global.jogador:
		body.receber_dano(1, global_position.x)


func _on_timer_timeout():
	queue_free()
