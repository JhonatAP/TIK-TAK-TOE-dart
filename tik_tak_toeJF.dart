import 'dart:io';
// Version 0.1.1 de Tik Tak Tow
// Programacion funcional
// Version 0.2 -> Agregar POO
// Version 0.3 -> Agregar juego solitario
// Version 0.4 -> Agregar mejor algoritmo de juego

// Inicializa el tablero con celdas vacías
List<List<String>> crearTablero() {
  return List.generate(3, (_) => List.filled(3, '.'));
}

// Imprime el tablero con bordes
void mostrarTablero(List<List<String>> tablero) {
  print('\n  1   2   3');
  for (int fila = 0; fila < 3; fila++) {
    stdout.write('${fila + 1} ');
    for (int col = 0; col < 3; col++) {
      stdout.write(tablero[fila][col]);
      if (col < 2) stdout.write(' | ');
    }
    print('');
    if (fila < 2) print('  ---------');
  }
  print('');
}

// Realiza un movimiento; retorna true si es válido
bool realizarMovimiento(
  List<List<String>> tablero,
  int fila,
  int col,
  String jugador,
) {
  if (fila < 0 || fila > 2 || col < 0 || col > 2) return false;
  if (tablero[fila][col] != '.') return false;
  tablero[fila][col] = jugador;
  return true;
}

// Revisa si hay un ganador
String? verificarGanador(List<List<String>> tablero) {
  // Filas y columnas
  for (int i = 0; i < 3; i++) {
    if (tablero[i][0] != '.' &&
        tablero[i][0] == tablero[i][1] &&
        tablero[i][1] == tablero[i][2]) {
      return tablero[i][0];
    }
    if (tablero[0][i] != '.' &&
        tablero[0][i] == tablero[1][i] &&
        tablero[1][i] == tablero[2][i]) {
      return tablero[0][i];
    }
  }
  // Diagonales
  if (tablero[0][0] != '.' &&
      tablero[0][0] == tablero[1][1] &&
      tablero[1][1] == tablero[2][2]) {
    return tablero[0][0];
  }
  if (tablero[0][2] != '.' &&
      tablero[0][2] == tablero[1][1] &&
      tablero[1][1] == tablero[2][0]) {
    return tablero[0][2];
  }
  return null;
}

// Revisa si el tablero está lleno (empate)
bool tableroLleno(List<List<String>> tablero) {
  return tablero.every((fila) => fila.every((celda) => celda != '.'));
}

// Pide al jugador una posición válida (fila col)
(int, int) pedirMovimiento(String jugador) {
  while (true) {
    stdout.write('Jugador $jugador ingresa fila y columna (ej: 1 2): ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    final partes = entrada.split(RegExp(r'\s+'));
    if (partes.length == 2) {
      final fila = int.tryParse(partes[0]);
      final col = int.tryParse(partes[1]);
      if (fila != null && col != null) {
        return (fila - 1, col - 1); // convertir a índice 0-based
      }
    }
    print('Entrada inválida. Ingresa dos números separados por espacio.');
  }
}

void main() {
  print('TIK TAK TOW');

  var tablero = crearTablero();
  final jugadores = ['X', 'O'];
  int turno = 0;

  while (true) {
    final jugador = jugadores[turno % 2];
    mostrarTablero(tablero);

    final (fila, col) = pedirMovimiento(jugador);

    if (!realizarMovimiento(tablero, fila, col, jugador)) {
      print('Celda ocupada o fuera de rango. Intenta de nuevo.\n');
      continue;
    }

    final ganador = verificarGanador(tablero);
    if (ganador != null) {
      mostrarTablero(tablero);
      print('¡Jugador $ganador gana!\n');
      break;
    }

    if (tableroLleno(tablero)) {
      mostrarTablero(tablero);
      print('¡Empate!\n');
      break;
    }

    turno++;
  }

  stdout.write('¿Jugar de nuevo? (s/n): ');
  final respuesta = stdin.readLineSync()?.trim().toLowerCase();
  if (respuesta == 's') {
    main(); // reinicio recursivo
  } else {
    print('¡Hasta luego!');
  }
}