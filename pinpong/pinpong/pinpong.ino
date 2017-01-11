// Envío de Entrada analógica 0 al puerto serie
int potPin=0; // Designa el numero de entrada analógica
void setup(){
 Serial.begin(19200); //Configura la velocidad de transmisión con el puerto
 }
void loop(){
 int val=analogRead(potPin); // Define val como el valor leído del puerto
 val=val/4; //Acondiciona el valor leído para ajustarse al tamaño de ventana
 Serial.write(val); // envía val al puerto en formato BYTE
 delay(100); // espera 75 ms
 }
