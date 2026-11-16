extends Control

var canal_musica
var canal_efeitos


func _ready():
	canal_musica  = AudioServer.get_bus_index("Musica")
	canal_efeitos = AudioServer.get_bus_index("Efeitos")
	# os sliders comecam com o volume atual (0 = mudo, 1 = maximo)
	$Opcoes/SliderMusica.value  = db_to_linear(AudioServer.get_bus_volume_db(canal_musica))
	$Opcoes/SliderEfeitos.value = db_to_linear(AudioServer.get_bus_volume_db(canal_efeitos))
	$Opcoes/BotaoTelaCheia.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	$BotaoVoltar.grab_focus()


func _on_slider_musica_value_changed(valor):
	AudioServer.set_bus_volume_db(canal_musica, linear_to_db(valor))


func _on_slider_efeitos_value_changed(valor):
	AudioServer.set_bus_volume_db(canal_efeitos, linear_to_db(valor))
	$SomTeste.play()


func _on_botao_tela_cheia_toggled(ligado):
	if ligado:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$Opcoes/BotaoTelaCheia.text = "Tela cheia: SIM"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$Opcoes/BotaoTelaCheia.text = "Tela cheia: NÃO"


func _on_botao_voltar_pressed():
	get_tree().change_scene_to_file("res://cenas/inicio.tscn")
