extends CharacterBody2D

# Chefao: anda atras do jogador e, de tempos em tempos, da uma pancada no chao
# que solta duas ondas (uma pra cada lado). O jogador precisa pular as ondas.
# Com metade da vida ele fica nervoso: mais rapido e ataca mais vezes.

var vida_maxima = 20
var vida        = 20
var gravidade   = 1800
var velocidade  = 110
var direcao     = -1
var ativo       = false # so comeca a lutar quando o jogador entra na arena
var nervoso     = false
var morto       = false


func _ready():
	Global.chefao = self


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	if morto or not ativo or not is_instance_valid(Global.jogador):
		velocity.x = 0
		move_and_slide()
		return

	var jogador = Global.jogador

	if $AnimationPlayer.current_animation == "atacando":
		velocity.x = 0
	else:
		if jogador.global_position.x < global_position.x:
			direcao = -1
		else:
			direcao = 1
		velocity.x = velocidade * direcao
		$AnimationPlayer.play("andando")

	$Sprite2D.flip_h = (direcao == -1)
	move_and_slide()

	for corpo in $AreaDano.get_overlapping_bodies():
		if corpo == jogador:
			jogador.receber_dano(1, global_position.x)


func ativar():
	ativo = true
	$TimerAtaque.start()


func _on_timer_ataque_timeout():
	if not morto:
		$AnimationPlayer.play("atacando")


# chamada pela animacao "atacando" no quadro em que o soco bate no chao
func bater_no_chao():
	$SomImpacto.play()
	var cena_onda = preload("res://cenas/onda.tscn")
	for lado in [-1, 1]:
		var onda = cena_onda.instantiate()
		onda.direcao = lado
		get_parent().add_child(onda)
		onda.global_position = global_position + Vector2(60 * lado, 0)


func levar_dano(direcao_do_golpe):
	if morto or not ativo:
		return
	vida -= 1
	$SomDano.play()
	if vida <= 0:
		morrer()
		return
	$Efeito.play("dano")
	if vida <= vida_maxima / 2 and not nervoso:
		nervoso = true
		velocidade = 180
		$TimerAtaque.wait_time = 1.6
		$Sprite2D.self_modulate = Color(1, 0.7, 0.7)


func morrer():
	morto = true
	Global.ganhar_pontos(1000)
	$TimerAtaque.stop()
	$SomDerrotado.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AreaDano/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("parado")
	$Efeito.play("morrendo")
	# avisa a fase que o chefao caiu (ela abre os portoes do estadio)
	get_parent().chefao_derrotado(global_position)
