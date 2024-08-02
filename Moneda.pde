import java.awt.Component;
import java.awt.image.BufferedImage;
// JOSE IGNACIO GARCÍA JÁVEGA

class Moneda
{
  // Posición y tamaño de la moneda
  float pos_x,
        pos_y, 
        tam_x, 
        tam_y;
        
  // Imagen para mostrar la moneda
  PImage imagen;
  
  Moneda(float x1, float y1, float tx, float ty)
  {
    pos_x = x1;
    pos_y = y1;
    tam_x = tx;
    tam_y = ty;
    
    imagen = new PImage();
    
    imagen = loadImage("moneda.png");
  }
  
  // Función que comprueba si el jugador colisiona con la moneda
  boolean coger_moneda(Barry barry)
  {
 
   PVector d = new PVector(pos_x - barry.pos_actual.x,
                           pos_y - barry.pos_actual.y);
   float distance = sqrt(pow(d.x,2) + pow(d.y,2));
   float minDist = tam_x/2 + barry.tam_personaje.x/2;
   
   // Si hay colisión...
   if (distance < minDist) 
   { 
     monedas++; //...incrementamos el contador de monedas...
     return true; //... y devolvemos true para que sea eliminada
   }
   
   // Pero si no hay colisión...
   else
   {
     // ...devolvemos true para que sea eliminada si se encuentra detrás del jugador
     if(pos_x <= 0)
       return true;
    }
      
    return false; // Devolvemos false para no eliminar aún la moneda
  }
   
}
