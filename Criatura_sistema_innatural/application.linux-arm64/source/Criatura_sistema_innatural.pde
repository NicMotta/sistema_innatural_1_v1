//--------Nic Motta----------------------------------
//-------MAE UNTREF - EJE TIEMPO - 1ER CUATRI - 2020-
//---------------------------------------------------
//----- SISTEMA INNATURAL ---------------------------
//---------------------------------------------------

import mqtt.*;

PrintWriter output;

int cantidadpuntos = 10000;

float[] randoms1 = new float[cantidadpuntos];
float[] randoms2 = new float[cantidadpuntos];
float[] randoms3 = new float[cantidadpuntos];

float[] backupX = new float[cantidadpuntos];
float[] backupY = new float[cantidadpuntos];
float[] backupZ = new float[cantidadpuntos];

int inc_valor = 1;

float randx, randy, randz;

float size = 250;

float incremento = 30;
float decrecimiento = -30;

float tiempo = 0;
float tiempo_segundos = 0;
int tiempo_maximo = 10000; // cambiar acá
float tiempo_random;

float eje_x, eje_y, eje_z;

float indice_crecimiento;
float indice_expansion;

float indice_distancia;

int cantidad_modelos;
int reinicio = 0;

int Hora = 0;
float minuto_promedio;

MQTTClient client;

//-----------------------------------------------------------
//-----------------------------------------------------------
//-----------------------------------------------------------

void setup() {
  size(400, 400, P3D);  
  smooth();
  background(50);

  client = new MQTTClient(this);
  client.connect("mqtt://93e4e00c:e672031caf720a6b@broker.shiftr.io", "SISTEMA_INNATURAL_BETA");

  randoms1[0] = 0;
  randoms2[0] = 0;
  randoms3[0] = 0;
}

//-----------------------------------------------------------
//-----------------------------------------------------------
//-----------------------------------------------------------

void draw() {
  background(50);
  strokeWeight(2);
  stroke(255);

  //------------PARTE CENTRAL DEL SISTEMA-------------------------
  //--------------------------------------------------------------
  if ( millis() > tiempo ) 
  {
    int _minuto = minute();
    
    tiempo_random = random(tiempo_maximo);
    tiempo = millis() + tiempo_random;
    randx = random(decrecimiento, incremento);
    randy = random(decrecimiento, incremento);
    randz = random(decrecimiento, incremento);

    randoms1[inc_valor] = ((randoms1[inc_valor - 1] + randx + backupX[inc_valor]) / 2 ) + minuto_promedio;
    randoms2[inc_valor] = ((randoms2[inc_valor - 1] + randy + backupY[inc_valor]) / 2 ) + minuto_promedio; 
    randoms3[inc_valor] = ((randoms3[inc_valor - 1] + randz + backupZ[inc_valor]) / 2 ) + minuto_promedio;

    eje_x = randoms1[inc_valor];
    eje_y = randoms2[inc_valor];
    eje_z = randoms3[inc_valor];
    
    backupX[inc_valor] = randoms1[inc_valor];
    backupY[inc_valor] = randoms2[inc_valor];
    backupZ[inc_valor] = randoms3[inc_valor];
    
    minuto_promedio = _minuto / 20;

    //-------------- PUBLICAR----------------------------------------------
    //---------------------------------------------------------------------
    Publicar();
    

    indice_crecimiento = (eje_x + eje_y + eje_z) / 3;
    indice_expansion = indice_expansion + indice_crecimiento;
    indice_distancia = dist(randoms1[inc_valor], 
                            randoms2[inc_valor], 
                            randoms3[inc_valor], 
                            randoms1[inc_valor-1], 
                            randoms2[inc_valor-1], 
                            randoms3[inc_valor-1]);
                            
    

    inc_valor++;

    reinicio = 0;
    
  }

  //-----------------TEXTOS------------------------
  //-----------------------------------------------

  Texto_GUI();

  //----------------Cada 4 horas reincia-------------------------
  //--------------------------------------------------------------

  if ( millis() > tiempo_segundos ) 
  {
    tiempo_segundos = millis() + 3600000; // un segundo
    Hora++;
  }
  
  
  if (Hora == 4)
  {
    GuardarCSV();
    for (int _f = 0; _f < randoms1.length; _f ++)
    {
      randoms1[_f] = 0;
      randoms2[_f] = 0;
      randoms3[_f] = 0;
    }
    
    client.publish("/sistema_innatural/info/reinicio/", "" + 1); // unica publicacion que no esta en la pestaña
    inc_valor = 1;
    cantidad_modelos++;
    Hora = 0; 
  }
}



//------------------------------------------------------------------------
//------------------------------------------------------------------------

void clientConnected() {
  println("[Cliente conectado]");
}

void connectionLost() {
  println("[Conexión perdida]");
}

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
}
