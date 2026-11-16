extends CharacterBody2D

var velocidade = 320
var gravidade  = 1800
var forca_pulo = 780
var velocidade_carrinho = 450
var direcao    = 1 # 1 = direita, -1 = esquerda
var atacando   = false
var derrotado  = false
var posicao_inicial


func _ready():
	Global.jogador = self
	posicao_inicial = global_position


func _physics_process(delta: float) -> void:
	# gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	# caiu para fora da fase: perde uma vida e volta pro comeco
	if global_position.y > 1500:
		global_position = posicao_inicial
		velocity = Vector2.ZERO
		receber_dano(1, global_position.x)

	if derrotado:
		velocity.x = 0
		move_and_slide()
		return

	# logo depois de levar dano o jogador fica sem controle um instante (empurrao)
	if not $TimerAtordoado.is_stopped():
		move_and_slide()
		return

	# enquanto estiver atacando o jogador nao controla o personagem
	if atacando:
		if $AnimationPlayer.current_animation == "carrinho":
			velocity.x = velocidade_carrinho * direcao
		elif $AnimationPlayer.current_animation == "cabecada":
			velocity.x = 150 * direcao
		else:
			velocity.x = 0
		move_and_slide()
		return

	# andar
	var entrada = Input.get_axis("ir_para_esquerda", "ir_para_direita")
	if entrada != 0:
		velocity.x = entrada * velocidade
		if entrada > 0:
			virar(1)
		else:
			virar(-1)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)

	# pular
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = -forca_pulo
		$SomPulo.play()

	# ataques
	if Input.is_action_just_pressed("cabecada"):
		# a cabecada funciona no chao e no ar
		atacando = true
		$AnimationPlayer.play("cabecada")
		$SomCabecada.play()
	elif is_on_floor():
		if Input.is_action_just_pressed("carrinho"):
			atacando = true
			$AnimationPlayer.play("carrinho")
			$SomCarrinho.play()
		elif Input.is_action_just_pressed("chutar"):
			# so chuta se ainda tiver bola (municao)
			if Global.bolas > 0:
				Global.bolas -= 1
				atacando = true
				$AnimationPlayer.play("chutando")
			else:
				$SomSemBola.play()

	move_and_slide()

	if not atacando:
		escolher_animacao()


func escolher_animacao():
	if is_on_floor():
		if velocity.x == 0:
			$AnimationPlayer.play("parado")
		else:
			$AnimationPlayer.play("correndo")
	else:
		if velocity.y < 0:
			$AnimationPlayer.play("pulando")
		else:
			$AnimationPlayer.play("caindo")


func virar(nova_direcao):
	direcao = nova_direcao
	$Sprite2D.flip_h = (direcao == -1)
	# o ponto da bola e as hitboxes mudam de lado junto com o personagem
	$Marker2D.position.x = abs($Marker2D.position.x) * direcao
	$HitboxCarrinho/CollisionShape2D.position.x = abs($HitboxCarrinho/CollisionShape2D.position.x) * direcao
	$HitboxCabecada/CollisionShape2D.position.x = abs($HitboxCabecada/CollisionShape2D.position.x) * direcao


# chamada pela animacao "chutando" (method track)
func chutar_bola():
	$SomChute.play()
	var cena_bola = preload("res://cenas/bola.tscn")
	var bola = cena_bola.instantiate()
	bola.direcao = direcao
	get_parent().add_child(bola)
	bola.global_position = $Marker2D.global_position


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "carrinho" or anim_name == "chutando" or anim_name == "cabecada":
		atacando = false


# as duas hitboxes (carrinho e cabecada) usam esta mesma funcao
func _on_hitbox_body_entered(body):
	if body.has_method("levar_dano"):
		body.levar_dano(direcao)


# a cabecada rebate os cartoes do arbitro
func _on_hitbox_cabecada_area_entered(area):
	if area.has_method("rebater"):
		area.rebater(direcao)


func receber_dano(quantidade, posicao_x_de_quem_bateu):
	# depois de levar dano o jogador fica um tempo invencivel (piscando)
	if derrotado or not $TimerInvencivel.is_stopped():
		return

	$SomDano.play()
	Global.perder_vida(quantidade)

	# cancela qualquer ataque que estava acontecendo
	atacando = false
	$HitboxCarrinho/CollisionShape2D.set_deferred("disabled", true)
	$HitboxCabecada/CollisionShape2D.set_deferred("disabled", true)

	if Global.vidas <= 0:
		derrotado = true
		$AnimationPlayer.play("derrotado")
		return

	# empurrao para o lado contrario de quem bateu
	if global_position.x > posicao_x_de_quem_bateu:
		velocity = Vector2(350, -400)
	else:
		velocity = Vector2(-350, -400)
	$AnimationPlayer.play("pulando")
	$TimerAtordoado.start()
	$TimerInvencivel.start()
	$Piscar.play("piscar")


func _on_timer_invencivel_timeout():
	$Piscar.stop()
	$Sprite2D.modulate.a = 1
