extends Area2D

# Item coletavel. O "tipo" e escolhido no Inspetor de cada item:
# "vida"      -> garrafinha de agua, recupera 1 vida
# "bolas"     -> municao: +3 bolas para chutar
# "figurinha" -> vale pontos

@export var tipo = "figurinha"
var pego = false


func _on_body_entered(body):
	if pego or body != Global.jogador:
		return
	pego = true

	if tipo == "vida":
		Global.ganhar_vida()
		Global.ganhar_pontos(50)
	elif tipo == "bolas":
		Global.bolas = min(Global.bolas + 3, Global.bolas_maximas)
	else:
		Global.figurinhas += 1
		Global.ganhar_pontos(10)

	# esconde o item, toca o som e so depois apaga
	visible = false
	$Som.play()
	await $Som.finished
	queue_free()
