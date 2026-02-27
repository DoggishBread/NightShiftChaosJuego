extends Node3D

var escena_cliente = preload("res://cliente.tscn")
@onready var punto_spawn = $PuntoSpawn
@onready var contador_de_npc: Node = $"Camera3D/Contador de NPC"

func _ready():
	$TimerSpawneo.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var nuevo_cliente = escena_cliente.instantiate()
	add_child(nuevo_cliente)
	
	nuevo_cliente.global_position = punto_spawn.global_position
	contador_de_npc.addpoint()
