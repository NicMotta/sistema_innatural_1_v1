Table table;
int id;
int id2;
int id3;

int [] nX = new int [5000];
int [] nY = new int [5000];
int [] nZ = new int [5000];

int aumento = 1;


void setup() {
  size(600, 600, P3D);
}

void draw()
{

  table = loadTable("data/MODELO_sistema_innatural_" + aumento + ".csv", "header");
  background(50);
  smooth();
  translate(width/2, height/2, 130);

  strokeWeight(2);
  stroke(255);

  rotateY(frameCount * 0.005);

  for (TableRow row : table.rows()) 
  {
    for ( int i = 0; i < table.getRowCount(); i ++)
    {
      id = row.getInt("eje_x");
      id2 = row.getInt("eje_y");
      id3 = row.getInt("eje_z");

      nX [i] = id;
      nY [i] = id2;
      nZ [i] = id3;

      point(nX[i], nY[i], nZ[i]);
    }
  }
}

void keyPressed() {
  
  if (key == 'n' || key == 'N')
  aumento++;
  
  if (key == 'b' || key == 'B')
  aumento--;
  
  if (aumento > 5) aumento = 5;
  if (aumento < 1) aumento = 1;
}
