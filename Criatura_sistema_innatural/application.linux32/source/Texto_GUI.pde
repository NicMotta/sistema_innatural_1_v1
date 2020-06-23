//------------------------------------
//------------------------------------

void Texto_GUI(){
  text("[SISTEMA_INNATURAL_CRIATURA V1.0]", width*0.1, height*0.1);
  text("[NIC MOTTA / MAE EJE_TIEMPO / 2020]", width*0.1, height*0.15);

  text("[X] " + eje_x, width*0.1, height*0.3);
  text("[Y] " + eje_y, width*0.4, height*0.3);
  text("[Z] " + eje_z, width*0.7, height*0.3);

  text("[Cantidad_puntos] " + inc_valor, width*0.1, height*0.4);
  text("[Tiempo_variable] " + tiempo_random, width*0.5, height*0.4);

  text("[Indice_crecimiento] " + indice_crecimiento, width*0.1, height*0.5);
  text("[Indice_expansion] " + indice_expansion, width*0.1, height*0.55);

  text("[Cantidad_modelos] " + cantidad_modelos, width*0.1, height*0.6);
  text("[Reinicio] " + reinicio, width*0.5, height*0.6);
  text("[Segundos] " + Hora, width*0.7, height*0.6);
  
  }
