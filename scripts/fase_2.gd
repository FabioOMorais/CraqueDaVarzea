extends Node2D

var luta_comecou = false


func _ready():
	Global.fase_atual = 2
	$Jogador/Camera2D.limit_right = 4300
	$SomApitoInicio.play()


# quando o jogador entra na arena: fecha a porta e o chefao acorda
func _on_entrada_arena_body_entered(body):
	if body != Global.jogador or luta_comecou:
		return
	luta_comecou = true
	$ParedeArena/CollisionShape2D.set_deferred("disabled", false)
	$ParedeArena.visible = true
	$Musica.stop()
	$MusicaChefao.play()
	$Chefao.ativar()


func chefao_derrotado(posicao):
	# o chefao caiu: a musica volta e os portoes do estadio se abrem
	$MusicaChefao.stop()
	$Musica.play()
	$SomPortao.play()
	$Portao.abrir()
