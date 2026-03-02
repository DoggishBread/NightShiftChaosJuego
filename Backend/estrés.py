import requests
import threading
import random

URL = "http://127.0.0.1:5000/guardar_partida"

def enviar_partida_fantasma():
    datos = {
        "usuario": f"Bot_{random.randint(100, 999)}",
        "ventas": random.randint(10, 100),
        "errores": random.randint(0, 15)
    }
    try:
        requests.post(URL, json=datos)
    except:
        pass

def ataque_masivo(hilos):
    threads = []
    print("Simulando", hilos, "partidas terminando exactamente al mismo tiempo...")
    for i in range(hilos):
        hilo = threading.Thread(target=enviar_partida_fantasma)
        threads.append(hilo)
        hilo.start()
    for hilo in threads:
        hilo.join()
    print("Finalizado")

ataque_masivo(500)
