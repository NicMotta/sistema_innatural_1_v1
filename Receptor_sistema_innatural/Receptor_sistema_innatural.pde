//--------Nic Motta----------------------------------
//-------MAE UNTREF - EJE TIEMPO - 1ER CUATRI - 2020-
//---------------------------------------------------
//----- SISTEMA INNATURAL ---------------------------
//---------------------------------------------------

import mqtt.*;

MQTTClient client;

PrintWriter output;

String [] dato_uno;
String [] dato_dos;

int cantidad_valores = 10000;

float[] numerouno = new float [cantidad_valores];
float[] numerodos = new float [cantidad_valores];
float[] numerotres = new float [cantidad_valores];
float[] numerocuatro = new float [cantidad_valores];
float[] numerocinco = new float [cantidad_valores];
float[] numeroseis = new float [cantidad_valores];

int aumento = 0;

int contador = 0;
int numero_archivo = 0;
int reinicio;
int cantidad_modelos;

boolean llamarReinicio = false;

//---------------------------------------------------------------
//---------------------------------------------------------------

void setup() {

  size(600, 600, P3D);
  client = new MQTTClient(this);
  client.connect("mqtt://93e4e00c:e672031caf720a6b@broker.shiftr.io", "Receptor_SISTEMA_INNATURAL");
}

void draw() {
  loop();
  background(50);
  lights();
  translate(width/2, height/2, -130);
  noFill();
  rotateY(frameCount * 0.005);
  stroke(255);
  strokeWeight(2);
  
  for (int _a = 0; _a < numerouno.length; _a++)
  {
    point(numerouno[_a], numerodos[_a], numerotres[_a]);
    //float distancia1 = dist(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-1], numerodos[_a-1], numerotres[_a-1]);
    //float distancia2 = dist(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-2], numerodos[_a-2], numerotres[_a-2]);
    //float distancia3 = dist(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-3], numerodos[_a-3], numerotres[_a-3]);
    
    //if ( distancia1 < 100 && distancia2 < 100 && distancia3 < 100)
    //{
    //line(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-1], numerodos[_a-1], numerotres[_a-1]);
    //line(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-2], numerodos[_a-2], numerotres[_a-2]);
    //line(numerouno[_a], numerodos[_a], numerotres[_a], numerouno[_a-3], numerodos[_a-3], numerotres[_a-3]);
    //}
  }
  
 
  
}

void clientConnected() {
  println("[Cliente conectado]");

  Suscripciones();

}

void messageReceived(String topic, byte[] payload) {

  //println("new message: " + topic + " - " + new String(payload));

  String message = new String(payload);

  switch(topic) {
    
  case "/sistema_innatural/ejes":
    dato_uno = split(message, ",");
    numerouno[aumento] = float(dato_uno[0]);
    numerodos[aumento] = float(dato_uno[1]);
    numerotres[aumento] = float(dato_uno[2]);
    contador++;
    //println(contador);
    break;
    
  case "/sistema_innatural/info/reinicio":
    reinicio = int(message);
    println(reinicio);
    
    if(reinicio == 1)
    {
     GuardarCSV();
     Reiniciar();
    }
    
    break;
    
  case "/sistema_innatural/info/modelos_generados":
    cantidad_modelos = int(message);
    break;
  }

  if (aumento > cantidad_valores)
  {
    aumento = 0;
  }
  else 
  {
  aumento= aumento+1;
  }
  
}

void Reiniciar(){
  for (int _f = 0; _f < numerouno.length; _f ++)
    {
      numerouno[_f] = 0;
      numerodos[_f] = 0;
      numerotres[_f] = 0;
    }
    
}

void connectionLost() {
  println("[Conexión perdida]");
}
