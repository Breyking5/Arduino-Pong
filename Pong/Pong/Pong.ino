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
