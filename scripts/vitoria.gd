extends Control


func _ready():
	$Pontos.text = "Pontos: " + str(Global.pontos) + "     Figurinhas: " + str(Global.figurinhas) + "     Vidas: " + str(Global.vidas)
	$BotaoMenu.grab_focus()


func _on_botao_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/inicio.tscn")
