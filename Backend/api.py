from flask import Flask, request, jsonify
import sqlite3
from datetime import datetime

app = Flask(__name__)
DB_NAME = 'NSC_final.db'

def init_db():
    conn = sqlite3.connect(DB_NAME, timeout=0.01)
    c = conn.cursor()
    
    # Tabla para las compras individuales
    c.execute('''CREATE TABLE IF NOT EXISTS compras 
                 (id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  fecha TEXT, 
                  producto TEXT, 
                  precio REAL)''')
                  
    # Tabla para el historial del dashboard
    c.execute('''CREATE TABLE IF NOT EXISTS partidas 
                 (id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  fecha TEXT,
                  usuario TEXT,
                  ventas INTEGER, 
                  errores INTEGER, 
                  puntaje INTEGER)''')
                  
    conn.commit()
    conn.close()

@app.route('/comprar', methods=['POST'])
def registrar_compra():
    try:
        data = request.get_json()
        producto = data.get('producto')
        precio = data.get('precio')

        if not producto or precio is None:
            return jsonify({"error": "Faltan datos de producto o precio"}), 400

        conn = sqlite3.connect(DB_NAME)
        c = conn.cursor()
        fecha_actual = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        c.execute("INSERT INTO compras (fecha, producto, precio) VALUES (?, ?, ?)",
                  (fecha_actual, producto, precio))
        conn.commit()
        conn.close()

        return jsonify({"mensaje": "Compra registrada con exito", "producto": producto}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/guardar_partida', methods=['POST'])
def guardar_partida():
    datos = request.get_json()
    usuario = datos.get('usuario', 'Jugador Godot')
    ventas = datos.get('ventas', 0)
    errores = datos.get('errores', 0)
    
    # Calculamos el puntaje
    puntaje = (ventas * 100) - (errores * 50)
    if puntaje < 0: puntaje = 0

    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    fecha_actual = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    c.execute("INSERT INTO partidas (fecha, usuario, ventas, errores, puntaje) VALUES (?, ?, ?, ?, ?)",
              (fecha_actual, usuario, ventas, errores, puntaje))
    conn.commit()
    conn.close()
    
    return jsonify({"mensaje": "Partida registrada en el Dashboard", "puntaje": puntaje}), 201

if __name__ == '__main__':
    init_db()
    print("Servidor API de Night Shift Chaos corriendo en el puerto 5000...")
    app.run(host='0.0.0.0', port=5000, debug=True)
