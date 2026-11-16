extends Control


func _ready():
	$Pontos.text = "Pontos: " + str(Global.pontos) + "     Figurinhas: " + str(Global.figurinhas)
	$Botoes/BotaoTentar.grab_focus()


func _on_botao_tentar_pressed():
	# recomeca da fase em que perdeu, com as vidas cheias e sem os pontos
	var fase = Global.fase_atual
	Global.resetar()
	Global.ir_para_fase(fase)


func _on_botao_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/inicio.tscn")
