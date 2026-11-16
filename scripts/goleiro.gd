extends CharacterBody2D

# Goleiro: anda de um lado pro outro na "area" dele. Quando o jogador chega
# perto, corre atras e da um bote (mergulho) na direcao dele.

var vida       = 3
var gravidade  = 1800
var velocidade = 90
var velocidade_correndo = 190
var velocidade_bote     = 480
var direcao    = -1
var tamanho_area = 200 # quanto ele anda para cada lado
var posicao_inicial_x
var dando_bote = false
var morto      = false


func _ready():
	posicao_inicial_x = global_position.x


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta

	if morto or not is_instance_valid(Global.jogador):
		velocity.x = 0
		move_and_slide()
		return

	var jogador = Global.jogador
	var distancia = abs(jogador.global_position.x - global_position.x)
	var mesma_altura = abs(jogador.global_position.y - (global_position.y - 60)) < 140

	if dando_bote:
		# durante o bote ele so cai; quando encosta no chao o bote acaba
		if is_on_floor() and $TimerBote.time_left < 1.6:
			dando_bote = false
	elif distancia < 450 and mesma_altura:
		# viu o jogador: corre atras dele
		if jogador.global_position.x < global_position.x:
			direcao = -1
		else:
			direcao = 1
		if distancia < 50:
			# ja esta colado no jogador: para de correr
			velocity.x = 0
			$AnimationPlayer.play("parado")
		else:
			velocity.x = velocidade_correndo * direcao
			$AnimationPlayer.play("correndo")
		if distancia < 230 and is_on_floor() and $TimerBote.is_stopped():
			dar_bote()
	else:
		# patrulha a area
		velocity.x = velocidade * direcao
		$AnimationPlayer.play("correndo")
		if global_position.x > posicao_inicial_x + tamanho_area:
			direcao = -1
		if global_position.x < posicao_inicial_x - tamanho_area:
			direcao = 1

	if is_on_wall() and not dando_bote:
		direcao *= -1

	$Sprite2D.flip_h = (direcao == -1)
	move_and_slide()

	# encostou no jogador = dano
	for corpo in $AreaDano.get_overlapping_bodies():
		if corpo == jogador:
			jogador.receber_dano(1, global_position.x)


func dar_bote():
	dando_bote = true
	velocity = Vector2(velocidade_bote * direcao, -380)
	$AnimationPlayer.play("bote")
	$SomBote.play()
	$TimerBote.start()


func levar_dano(direcao_do_golpe):
	if morto:
		return
	vida -= 1
	velocity.x = 300 * direcao_do_golpe
	$SomDano.play()
	if vida <= 0:
		morrer()
	else:
		$Efeito.play("dano")


func morrer():
	morto = true
	Global.ganhar_pontos(150)
	$SomDerrotado.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AreaDano/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("parado")
	$Efeito.play("morrendo")
