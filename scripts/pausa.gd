extends CanvasLayer

# Este no continua funcionando com o jogo pausado (process_mode = Sempre)


func _ready():
	visible = false


func _process(delta):
	if Input.is_action_just_pressed("pausa"):
		alternar_pausa()


func alternar_pausa():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused


func _on_botao_continuar_pressed():
	alternar_pausa()


func _on_botao_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/inicio.tscn")
