extends CharacterBody2D

# VAR: robo-monitor que persegue o jogador dando saltos na direcao dele.

var vida       = 4
var gravidade  = 1800
var velocidade = 120
var forca_salto = 620
var direcao    = -1
var morto      = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	if morto or not is_instance_valid(Global.jogador):
		velocity.x = move_toward(velocity.x, 0, 20)
		move_and_slide()
		return

	var jogador = Global.jogador
	var distancia = abs(jogador.global_position.x - global_position.x)

	if is_on_floor():
		if distancia < 600:
			# persegue o jogador
			if jogador.global_position.x < global_position.x:
				direcao = -1
			else:
				direcao = 1
			velocity.x = velocidade * direcao
			$AnimationPlayer.play("andando")
			# de tempos em tempos salta em direcao ao jogador
			if distancia < 350 and $TimerSalto.is_stopped():
				velocity = Vector2(260 * direcao, -forca_salto)
				$SomSalto.play()
				$TimerSalto.start()
		else:
			velocity.x = 0
			$AnimationPlayer.play("parado")

	$Sprite2D.flip_h = (direcao == -1)
	move_and_slide()

	for corpo in $AreaDano.get_overlapping_bodies():
		if corpo == jogador:
			jogador.receber_dano(1, global_position.x)


func levar_dano(direcao_do_golpe):
	if morto:
		return
	vida -= 1
	velocity.x = 250 * direcao_do_golpe
	$SomDano.play()
	if vida <= 0:
		morrer()
	else:
		$Efeito.play("dano")


func morrer():
	morto = true
	Global.ganhar_pontos(200)
	$SomDerrotado.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AreaDano/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("parado")
	$Efeito.play("morrendo")
