//-------------- Guardar las coordendas en un CSV
//-----------------------------------------------

void GuardarCSV(){
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
