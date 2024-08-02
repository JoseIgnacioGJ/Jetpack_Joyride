import java.awt.Component;
import java.awt.image.BufferedImage;
// JOSE IGNACIO GARCÍA JÁVEGA

class Cohete
{
  // Posición y tamaño del cohete
  float pos_x,
        pos_y, 
        tam_x, 
        tam_y; 

  // Imágenes para mostrar el cohete
  PImage[] imagen;
  
   // Variables que se usan para mostrar los sprites
  int currentFrame_Cohete,  numSprites_Cohete;
  
  Cohete(float x1, float y1, float tx, float ty)
  {
    pos_x = x1;
    pos_y = y1;
    tam_x = tx;
    tam_y = ty;
    
    currentFrame_Cohete = 0;
    numSprites_Cohete = 2;
    
    imagen = new PImage[numSprites_Cohete];
   
    for(int i=0; i < numSprites_Cohete; i++)
      imagen[i]  = loadImage("cohete " + i + ".png");
  }
  
  // Mostramos el cohete desplázandose
  void mostrar_cohete()
  {
    image(imagen[currentFrame_Cohete % numSprites_Cohete], pos_x, pos_y, tam_x, tam_y);
    currentFrame_Cohete++;
  }
  
}
