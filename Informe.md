# INFORME DEL JUEGO DE PING PONG CON ARDUINO + PROCESSING:

La idea del proyecto fue encontrado en [hackster.io](https://www.hackster.io "Título").

### Nota:
_El proyecto aún está en proceso, por ende el siguiente informe por ahora **solo contendrá las partes de código e información** tanto de Arduino como de processing_ según se vaya desarrollando.

## 1. Introducción:

El siguiente proyecto busca diseñar el juego clásico de _"Ping Pong"_ combinando los mecanismos que brinda Arduino para el control físico y Processing para la interfaz de usuario, brindado una calidad de juego entretenida para el usuario.

## 2. Materiales:
- 1 Arduino
- 1 Potenciometro de 5 K ohms
- 3 Jumpers aproximadamente 10 Centímetros
- 1 Protoboard

## 3. Código:

Arduino | Processing
-------------------------------------------------|-------------------------------------------------
```   | ```
int potPin=0;   | a
void setup(){   | a
Serial.begin(19200);   | a
}   | a
void loop(){   | a
int val=analogRead(potPin);   | a
val=val/4;   | a
Serial.write(val); //   | a
delay(100);   | a
} | a
```  | ```
