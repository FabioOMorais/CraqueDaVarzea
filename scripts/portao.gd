extends Area2D

# Portoes do estadio: comecam fechados e abrem quando o chefao e derrotado.
# Com o portao aberto, o jogador entra e termina o jogo.

var aberto = false


func abrir():
	aberto = true
	$Sprite2D.frame = 1


func _on_body_entered(body):
	if aberto and body == Global.jogador:
		Global.ganhar_pontos(500)
		get_tree().change_scene_to_file.call_deferred("res://cenas/vitoria.tscn")
