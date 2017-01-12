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
  if((key == 'p' && start)||(key == 'P' && start)){
    pausa = !pausa;
  }
}