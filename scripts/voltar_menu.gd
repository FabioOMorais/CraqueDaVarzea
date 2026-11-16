extends Control

# Usado na tela "Como jogar": so tem o botao de voltar.


func _ready():
	$BotaoVoltar.grab_focus()


func _on_botao_voltar_pressed():
	get_tree().change_scene_to_file("res://cenas/inicio.tscn")
