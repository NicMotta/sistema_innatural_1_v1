import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import mqtt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Criatura_sistema_innatural extends PApplet {

//--------Nic Motta----------------------------------
//-------MAE UNTREF - EJE TIEMPO - 1ER CUATRI - 2020-
//---------------------------------------------------
//----- SISTEMA INNATURAL ---------------------------
//---------------------------------------------------



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

public void setup() {
    
  
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

public void draw() {
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

public void clientConnected() {
  println("[Cliente conectado]");
}

public void connectionLost() {
  println("[Conexión perdida]");
}

public void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
}
//-------------- Guardar las coordendas en un CSV
//-----------------------------------------------

public void GuardarCSV(){
  output = createWriter("data/MODELO_sistema_innatural_" + cantidad_modelos + ".csv");
  
  output.println("eje_x" + "," + "eje_y" + "," + "eje_z"); // Escribo los headers de las columnas
  
  for (int _a = 1; _a < randoms1.length; _a++)
  {
    if ( randoms1[_a] != 0 && randoms2[_a] != 0 && randoms3[_a] != 0)
    {
    output.println(randoms1[_a] + "," + randoms2[_a] + "," + randoms3[_a]);
    }
  }
 
  output.println();
  output.flush();
  output.close(); // Termina el archivo
  
  println("modelo_CSV_" + cantidad_modelos + "_creado");
}
//---------------------------------------------
//---------------------------------------------

public void Publicar(){
  
    client.publish("/sistema_innatural/ejes", "" + randoms1[inc_valor] + "," + randoms2[inc_valor] + "," + randoms3[inc_valor]);
    client.publish("/sistema_innatural/info/puntos_creados", "" + inc_valor);
    client.publish("/sistema_innatural/info/tiempo", "" + tiempo_random);
    client.publish("/sistema_innatural/info/randoms/valor_randX", "" + randx);
    client.publish("/sistema_innatural/info/randoms/valor_randY", "" + randy);
    client.publish("/sistema_innatural/info/randoms/valor_randZ", "" + randz);
    client.publish("/sistema_innatural/info/indices/indice_expansion", "" + indice_expansion);
    client.publish("/sistema_innatural/info/indices/indice_crecimiento", "" + indice_crecimiento);
    client.publish("/sistema_innatural/info/indices/indice_distancia", "" + indice_distancia);
    client.publish("/sistema_innatural/info/modelos_generados/", "" + cantidad_modelos);
    client.publish("/sistema_innatural/info/reinicio/", "" + 0);
    
}
//------------------------------------
//------------------------------------

public void Texto_GUI(){
  text("[SISTEMA_INNATURAL_CRIATURA V1.0]", width*0.1f, height*0.1f);
  text("[NIC MOTTA / MAE EJE_TIEMPO / 2020]", width*0.1f, height*0.15f);

  text("[X] " + eje_x, width*0.1f, height*0.3f);
  text("[Y] " + eje_y, width*0.4f, height*0.3f);
  text("[Z] " + eje_z, width*0.7f, height*0.3f);

  text("[Cantidad_puntos] " + inc_valor, width*0.1f, height*0.4f);
  text("[Tiempo_variable] " + tiempo_random, width*0.5f, height*0.4f);

  text("[Indice_crecimiento] " + indice_crecimiento, width*0.1f, height*0.5f);
  text("[Indice_expansion] " + indice_expansion, width*0.1f, height*0.55f);

  text("[Cantidad_modelos] " + cantidad_modelos, width*0.1f, height*0.6f);
  text("[Reinicio] " + reinicio, width*0.5f, height*0.6f);
  text("[Segundos] " + Hora, width*0.7f, height*0.6f);
  
  }
  public void settings() {  size(400, 400, P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Criatura_sistema_innatural" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
