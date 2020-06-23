//---------------------------
//---------------------------

void GuardarCSV(){
  output = createWriter("data/sistema_innatural_" + cantidad_modelos + ".csv");
  
  output.println("eje_x" + "," + "eje_y" + "," + "eje_z"); // Escribo los headers de las columnas
  
  for (int _a = 1; _a < numerouno.length; _a++)
  {
    if ( numerouno[_a] != 0 && numerodos[_a] != 0 && numerotres[_a] != 0)
    {
    output.println(numerouno[_a] + "," + numerodos[_a] + "," + numerotres[_a]);
    }
  }
 
  output.println();
  output.flush();
  output.close(); // Termina el archivo
  
}
