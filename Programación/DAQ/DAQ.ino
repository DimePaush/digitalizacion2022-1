char var[5];

void setup() {
  // Inicializa la comunicación serial
  Serial.begin(115200);

  //Envia un encabezado en las lecturas del puerto serial
  //Se recomienda usarlo si se hará una captura desde la terminal
  //Serial.print("Test 1\t");Serial.println("Fecha: 2021.10.30");
  //Serial.print('\n');
  //Serial.print("Tension [V]");

}

void loop() {
  //Escribe la lectura del pin A0 directo al serial
  //Serial.print(analogRead(A5));Serial.print("\t");
  //Serial.println(analogRead(A0));
  

  //Escribe una variable numérica en un "char" de ancho fijo
  //Este es el que debe usarse con el script de matlab
  sprintf(var,"%04d",analogRead(A0));
  Serial.println(var);

  //Controla la frecuencia de dicretizacion
  delay(1);

}
