extends Node

# guarda tudo que precisa continuar existindo quando a cena muda

var vidas_maximas = 5
var vidas         = 5
var pontos        = 0
var figurinhas    = 0
var bolas_maximas = 10
var bolas         = 6 # municao: cada chute gasta uma bola
var fase_atual    = 1
var jogador       = null # cada fase avisa quem e o jogador
var chefao        = null # so existe na fase 2


func resetar():
	vidas      = vidas_maximas
	pontos     = 0
	figurinhas = 0
	bolas      = 6
	fase_atual = 1


func _ready():
	resetar()


func ganhar_pontos(quantidade):
	pontos += quantidade


func perder_vida(quantidade):
	if vidas <= 0:
		return
	vidas -= quantidade
	if vidas <= 0:
		vidas = 0
		# espera um pouquinho pra dar tempo de ver o personagem caindo
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")


func ganhar_vida():
	if vidas < vidas_maximas:
		vidas += 1


func ir_para_fase(numero):
	fase_atual = numero
	# call_deferred: troca de cena so depois que a fisica terminar o quadro atual
	get_tree().change_scene_to_file.call_deferred("res://cenas/fase_" + str(numero) + ".tscn")
