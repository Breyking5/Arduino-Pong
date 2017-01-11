/**
 * Programa PinPong.
 *
 * 5 Junio 2013 Douglass Mejia
 */
import processing.serial.*;
String portname = "COM8"; // aquí colocamos el puerto por el que recibimos el dato
Serial port; // Creamos un objeto llamado port de la clase Serial
// Variables para definir la pelota
float ball_x;
float ball_y;
float ball_dir = 1;
float ball_size = 5; // Radio
float dy = 0; // Dirección
// variables para definir la pala
int paddle_width = 5;
int paddle_height = 20;
int paddle_pos; // nueva posición
int paddle_ppos; // última posición
int dist_wall = 15;
void setup()
{
 size(255, 255);
 rectMode(CENTER);
 ellipseMode(CENTER);
 noStroke();
 smooth();
 ball_y = height/2;
 ball_x = 1;
 // Abre el puerto al que esta conectada la tarjeta con una velocidad de (19200 bps)
 port = new Serial(this, portname, 19200);
}
void draw()
{
 background(51);
 ball_x += ball_dir * 2.0;
  ball_y += dy;
 if(ball_x > width+ball_size) {
 ball_x = -width/2 - ball_size;
 ball_y = random(0, height);
 dy = 0;
 }
 if (port.available() > 0) { // Si el dato está disponible,
 paddle_ppos = paddle_pos; // guarda la ultima posición
paddle_pos = port.read(); // lee y almacena la nueva posición
}
 // Desplaza la pala verticalmente en la pantalla
 float paddle_y = constrain(paddle_pos, paddle_height, height-paddle_height);
 // Testea si la pelota toca la pala
 float py = width-dist_wall-paddle_width-ball_size;
 if(ball_x == py
 && ball_y > paddle_y - paddle_height - ball_size
 && ball_y < paddle_y + paddle_height + ball_size) {
 ball_dir *= -1;
 if(paddle_pos != paddle_ppos) {
 dy = (paddle_pos - paddle_ppos)/2.0;
 if(dy > 5) { dy = 5; }
 if(dy < -5) { dy = -5; }
 }
 }
 // Si la pelota toca la pala o la pared, cambia de dirección
 if(ball_x < ball_size && ball_dir == -1) {
 ball_dir *= -1;
 }
 // Si la pelota toca la parte superior o inferior del borde, cambia dirección
 if(ball_y > height-ball_size) {
 dy = dy * -1;
 }
 if(ball_y < ball_size) {
 dy = dy * -1;
 }
 // Dibuja la pelota
 fill(255);
 ellipse(ball_x, ball_y, ball_size, ball_size);
 stroke(255,255,255);  
 // Dibuja la paleta
 fill(153);
 rect(width-dist_wall, paddle_y, paddle_width, paddle_height);
 rect(2, paddle_y, paddle_width, paddle_height);
}
