extends Area2D

# Porta do vestiario no fim da fase 1: leva para a fase 2.


func _on_body_entered(body):
	if body == Global.jogador:
		Global.ir_para_fase(2)
