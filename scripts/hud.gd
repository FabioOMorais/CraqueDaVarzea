extends CanvasLayer


func _process(delta):
	$Vidas.text = "x " + str(Global.vidas)
	$Pontos.text = "PONTOS: " + str(Global.pontos)
	$Figurinhas.text = "x " + str(Global.figurinhas)
	$Bolas.text = "x " + str(Global.bolas)
	$Fase.text = "FASE " + str(Global.fase_atual)

	# barra de vida do chefao (so aparece durante a luta)
	if Global.chefao != null and is_instance_valid(Global.chefao) and Global.chefao.ativo and not Global.chefao.morto:
		$BarraChefao.visible = true
		$BarraChefao.max_value = Global.chefao.vida_maxima
		$BarraChefao.value = Global.chefao.vida
	else:
		$BarraChefao.visible = false
