extends Control


func _ready():
	$Menu/BotaoJogar.grab_focus()


func _on_botao_jogar_pressed():
	Global.resetar()
	Global.ir_para_fase(1)


func _on_botao_como_jogar_pressed():
	get_tree().change_scene_to_file("res://cenas/como_jogar.tscn")


func _on_botao_configuracoes_pressed():
	get_tree().change_scene_to_file("res://cenas/configuracoes.tscn")


func _on_botao_sair_pressed():
	get_tree().quit()
