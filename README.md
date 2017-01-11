# Arduino-Pong (IHM)
Trabajo del Juego de Ping Pong con Arduino + Processing

## Docente:
Ing. Paulo Chiliguano.

## Integrantes:
- Flores Alejandra.
- Ibarra Brayan.
- Troya Jaime.

# INFORME DEL JUEGO DE PING PONG CON ARDUINO + PROCESSING:

La idea del proyecto fue encontrado en [hackster.io](https://www.hackster.io "Título").

## 1. Introducción:

El siguiente trabajo busca mejorar el juego clásico de _"Ping Pong"_ combinando los mecanismos que brinda Arduino para el control físico y Processing para la interfaz de usuario, brindado un juego entretenido y de una calidad visual agradable para el usuario.

## 2. Objetivos:
- Analizar el código base de referencia del juego de ping pong clásico para conocer su estructura y funcionamiento.
- Desarrollar en processing la interfaz del juego actualizado de ping pong agregando mejorías al tomado como referencia.
- Implementar la versión de la interfaz final en processing al respectivo circuito aplicado en Arduino.

## 3. Materiales:
- 1 Arduino
- 2 Potenciometros de 10 K ohms
- 6 Jumpers aproximadamente 10 Centímetros
- 1 Protoboard

## 4. Conceptos:

Arduino | Processing
-------------------------------------------------|-------------------------------------------------
Es una plataforma de hardware y software de código abierto, basada en una sencilla placa con entradas y salidas, analógicas y digitales, en un entorno de desarrollo que está basado en el lenguaje de programación Processing. | Es un lenguaje de programación creado en 2001, el cual es capaz de representar o emular en 2 o 3D una serie de instrucciones para así mostrar un resultado gráfico.

## 5. Código:

### * Arduino:
```
/*
Arduino + Processing - Ping Pong
By.:
Flores Alejandra
Ibarra Brayan
Troya Jaime
*/

  int const potPin1=A2;
  int const potPin2=A0;
  
void setup(){
  Serial.begin(9600);
}
void loop(){
  String dati = "";
  dati += analogRead(potPin1);
  dati += '-';
  dati += analogRead(potPin2);
  Serial.println(dati);
  delay(100);
}
```
### * Processing:

#### Notas:

- Es necesario instalar la librería Minim. 
- Se debe crear la fuente "AgencyFB-Bold-250.vlw" la cual será almacenada en una carpeta data donde tenga su sketch.
- En la misma carpeta data del sketch también deben estar los 2 audios para los sonidos de la pelota nombrados como "ping.mp3 y pong.mp3".

```
/*
Arduino + Processing - Ping Pong
By.:
Flores Alejandra
Ibarra Brayan
Troya Jaime
*/

import processing.serial.*;
import ddf.minim.*;

String portname = "COM3";
Serial Port;
int[] posicion;
int pad1 = 100;
int pad2 = 15;
int dim_pantalla = 20;
float p1pos,p2pos;
float x,y,v_x,v_y;
float init_x,init_y;
int rebotes;
boolean start = false;
boolean iniciar = true;
int punto1,punto2;
boolean ganar = false;
boolean titulo = true;
boolean pausa = false;

Minim minim;
AudioPlayer sonido_ping;
AudioPlayer sonido_pong;

void setup(){
  size(800,600);
  init_x = width/2;
  init_y = height/2;
  noCursor();
  Port = new Serial(this, portname, 9600);
  Port.bufferUntil('\n');
  textFont(loadFont("AgencyFB-Bold-250.vlw"),100);
  textAlign(CENTER);
  minim = new Minim(this);
  sonido_ping = minim.loadFile("ping.mp3");
  sonido_pong = minim.loadFile("pong.mp3");
}

void draw(){
 if(!pausa){ 
  if(ganar){
    puntaje();
    if(punto1>punto2){
      stroke(0);
      strokeWeight(2);
      fill(0);
      textAlign(CENTER,CENTER);
      textSize(90);
      text("GANA",width*0.25,height/2);
      text("PIERDE",width*0.75,height/2);
      textSize(70);
      strokeWeight(2);
    }
    else{
      stroke(0);
      strokeWeight(2);
      fill(0);
      textAlign(CENTER,CENTER);
      textSize(90);
      text("PIERDE",width*0.25,height/2);
      text("GANA",width*0.75,height/2);
      textSize(70);
      strokeWeight(2);
    }
  }
  
  if(titulo){
    background(#6BDE81);
    pantalla_titulo();
    fill(255);
  }
  
  if(start){
    textSize(100);
    background(#6BDE81);
    campo();
    fill(255);
    puntaje();
    if(iniciar){
      x = init_x;
      y = init_y;
      v_x = random(2,3)*rnd_sign();
      v_y = random(2,3)*rnd_sign();
      rebotes = 0;
      iniciar = !iniciar;
    }
    posicionPad();
    pelota();
    }
 }
}

void serialEvent (Serial Port) {
  String stringa = Port.readStringUntil('\n');
  if (stringa != null) {
    stringa = trim(stringa);
    posicion = get_position(stringa);
  }
}

float rnd_sign(){
  float n = random(-1,1);
  if(n>=0){
    return 1.0;
  }
  else{
    return -1.0;
  }
}

void campo(){
  stroke(0);
  strokeWeight(2);
  fill(0);
  rectMode(CORNER);
  rect(0,0,width,10);
  rect(0,height-10,width,10);
  strokeWeight(2);
  int segmenti=25;
  for(int i=0;i<segmenti;i++){
    if(i%2==0){
      line(width/2,i*(height/segmenti),width/2,i*(height/segmenti)+(height/segmenti));
    }
  }
  noFill();
  ellipse(width/2,height/2,150,150);
}

void pantalla_titulo(){
  stroke(0);
  strokeWeight(2);
  fill(0);
  rectMode(CORNER);
  rect(0,0,width,10);
  rect(0,height-10,width,10);
  strokeWeight(2);
  textAlign(CENTER,CENTER);
  textSize(100);
  text("JUEGO MULTIPLAYER\nBREYKING PONG\nARDUINO+PROCESSING",width/2,height*0.35);
  textSize(60);
  text("I : INICIAR   P : PAUSA",width/2,height*0.8);
}

int[] get_position(String dati){
  return int(split(dati,'-'));
}

void posicionPad(){
  p1pos = map(posicion[0],0,1023,10+pad1/2,height-(10+pad1/2));
  p2pos = map(posicion[1],0,1023,10+pad1/2,height-(10+pad1/2));
  rectMode(CENTER);
  rect(20+pad2/2,p1pos,pad2,pad1,5);
  rect(width-(20+pad2/2),p2pos,pad2,pad1,5);
}

void pelota(){
  fill(0);
  stroke(0);
  ellipse(x,y,dim_pantalla,dim_pantalla);
  x=x+v_x;
  y=y+v_y;
  
  if(y<10+dim_pantalla/2 || y>height-(10+dim_pantalla/2)){
    v_y=-v_y;
    sonido_ping.pause();
    sonido_ping.rewind();
    sonido_pong.pause();
    sonido_pong.rewind();
    sonido_pong.play();
  }
  if((v_x<0 && x<20+pad2+dim_pantalla/2 && x>20+pad2/2 && y>=p1pos-pad1/2 && y<=p1pos+pad1/2) || (v_x>0 && x>width-(20+pad2+dim_pantalla/2) && x<width-(20+pad2/2) && y>=p2pos-pad1/2 && y<=p2pos+pad1/2)){
    if(rebotes<20){
      v_x = -1.1*v_x;
      rebotes++;
    }
    else{
      v_x = -v_x;
    }
    sonido_pong.pause();
    sonido_pong.rewind();
    sonido_ping.pause();
    sonido_ping.rewind();
    sonido_ping.play();
  }
  if(x<0){
    punto2++;
    iniciar = true;
  }
  if(x>width){
    punto1++;
    iniciar = true;
  }
}

void puntaje(){
  textSize(90);
  text(punto1,(width/2)*0.85,height/6);
  text(punto2,(width/2)*1.15,height/6);
  textSize(70);
  if(punto1 == 3){
    ganar = true;
    start = false;
  }
  if(punto2 == 3){
    ganar = true;
    start = false;
  }
}

void keyPressed(){
  if((key == 'i' && !pausa)||(key == 'I' && !pausa)){
    start = !start;
    iniciar = true;
    punto1 = 0;
    punto2 = 0;
    titulo = !titulo;  
  }
  if(ganar){
    ganar = false;
    start = false;
    titulo = true;
  }
  if((key == 'p' && start)||(key == 'P' && !pausa)){
    pausa = !pausa;
  }
}
```
## 6. Recomendaciones:

- Si no desea instalar la librería Minim o tiene problemas con la misma, opte por quitar las líneas de código que le brindan sonido al juego.
- Si no tiene con quien jugar, puede implementar si desea líneas de código para permitir que el juego de ping pong nos asigne contra una máquina aleatoria.

## 7. Resultado:

### Se obtiene como resultado final un juego de ping pong con nuevas características añadidas a la base tomada de la fuente inicial:

- En vez de solo ser a blanco y negro ahora tendrá un color verde claro y tonos b/n (dando una semejanza a una cancha de fútbol).
- Se implementó un jugador 2, convirtiendo el juego en multiplayer, tienen marcadores individuales y un límite de victoria de 3 goles.
- Ya no es un juego silencioso pues se asignaron 2 sonidos distintos, uno al ser golpeado el balón por un jugador y otro cuando el balón rebote en paredes.

## 8. Bibliografía:
- Referencia base del [ping pong tradicional uniplayer](http://ingenieriaelectronica.org/juego-de-ping-pong-con-arduino-y-processing-version-1/ "Título").
- [Manejo de escritura y tipo de letras](http://www.programacionyrobotica.com/mostrando-informacion-en-processing/ "Título").
- [Librería Minim y su uso para sonidos](http://dunadigital.com/processing/2014/01/14/como-reproducir-un-sonido/ "Título").
