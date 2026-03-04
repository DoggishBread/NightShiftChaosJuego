extends Node

var escena_cliente = preload("res://Scenes/cliente.tscn")

@onready var contador_de_npc: Node = $"../Cosas Camara/Camera3D/Contador de NPC"
@onready var timer_spawneo: Timer = $"../Extras/TimerSpawneo"
@onready var punto_spawn = $"../Extras/PuntoSpawn"

func _ready():
	timer_spawneo.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var nuevo_cliente = escena_cliente.instantiate()
	add_child(nuevo_cliente)
	
	nuevo_cliente.global_position = punto_spawn.global_position
	contador_de_npc.addpoint()
