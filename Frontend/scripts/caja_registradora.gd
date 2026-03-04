extends Area3D

@onready var http_request = $HTTPRequest
@onready var sonido_error = $SonidoError
@onready var sonido_caja = $SonidoCaja

var ventas_acomuladas = 0
var errores_acomulados = 0
var jugador_cerca = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		jugador_cerca = true
		print("Presiona ACEPTAR para procesar la venta")

func _on_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false

func _input(event):
	# Si el jugador esta cerca y presiona Enter o Espacio
	if jugador_cerca:
		if event.is_action_pressed("ui_accept"):
			ventas_acomuladas += 1
			sonido_caja.play()
			print("Venta registrada. Llevas: ", ventas_acomuladas)

		if event.is_action_pressed("cometer_error"):
			errores_acomulados += 1
			sonido_error.play()
			print("Error registrado. Llevas: ", errores_acomulados)
	
	if event.is_action_pressed("ui_cancel"):
		enviar_partida_al_servidor()
		

func enviar_compra():
	print("Enviando transaccion a la base de datos...")
	var url = "http://127.0.0.1:5000/comprar"
	
	var datos = {
		"producto": "Hamburguesa",
		"precio": 120.0
	}
	
	var json_datos = JSON.stringify(datos)
	var headers = ["Content-Type: application/json"]
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_datos)
	
	if error != OK:
		print("Hubo un problema de conexion con la API")

func enviar_partida_al_servidor():
	print("Enviando reporte de turno al servidor...")
	var url = "http://127.0.0.1:5000/guardar_partida"

	var datos = {
		"usuario": "Ram_Admin",
		"ventas": ventas_acomuladas,
		"errores": errores_acomulados
	}

	var json_datos = JSON.stringify(datos)
	var headers = ["Content-Type: application/json"]

	http_request.request_completed.connect(on_request_completed)
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_datos)

func on_request_completed(_result, response_code, _headers, _body):
	print("Servidor respondio con codigo: ", response_code)
	get_tree().quit()
