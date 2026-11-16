extends Node2D


func _ready():
	Global.fase_atual = 1
	Global.chefao = null
	$Jogador/Camera2D.limit_right = 5300
	$SomApitoInicio.play()
