extends CharacterBody2D

# Arbitro: fica parado olhando para o jogador e, quando ele chega perto,
# apita e joga um cartao. A cada 3 cartoes, um e vermelho (tira 2 vidas).

var vida      = 3
var gravidade = 1800
var direcao   = -1
var distancia_visao = 600
var cartoes_jogados = 0
var morto     = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta
	velocity.x = move_toward(velocity.x, 0, 20)
	move_and_slide()

	if morto or not is_instance_valid(Global.jogador):
		return

	var jogador = Global.jogador

	# sempre olhando para o jogador
	if jogador.global_position.x < global_position.x:
		direcao = -1
	else:
		direcao = 1
	$Sprite2D.flip_h = (direcao == -1)
	$Marker2D.position.x = abs($Marker2D.position.x) * direcao

	var distancia = abs(jogador.global_position.x - global_position.x)
	var mesma_altura = abs(jogador.global_position.y - (global_position.y - 60)) < 140

	if distancia < distancia_visao and mesma_altura and $TimerCartao.is_stopped():
		# o 3o, 6o, 9o... cartao e vermelho: ele ja levanta o cartao da cor certa
		if (cartoes_jogados + 1) % 3 == 0:
			$AnimationPlayer.play("apitando_vermelho")
		else:
			$AnimationPlayer.play("apitando_amarelo")
		$TimerCartao.start()
	elif $AnimationPlayer.current_animation == "":
		$AnimationPlayer.play("parado")


# chamada pelas animacoes "apitando_amarelo" e "apitando_vermelho" (method track)
func jogar_cartao():
	if morto:
		return
	cartoes_jogados += 1
	$SomApito.play()
	var cena_cartao = preload("res://cenas/cartao.tscn")
	var cartao = cena_cartao.instantiate()
	cartao.direcao = direcao
	cartao.vermelho = (cartoes_jogados % 3 == 0)
	get_parent().add_child(cartao)
	cartao.global_position = $Marker2D.global_position


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
	Global.ganhar_pontos(100)
	$SomDerrotado.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("parado")
	$Efeito.play("morrendo") # no fim da animacao o no e apagado (method track)
