//---------------------------------------------
//---------------------------------------------

void Publicar(){
  
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
