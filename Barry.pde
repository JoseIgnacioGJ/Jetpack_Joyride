import java.awt.Component;
import java.awt.image.BufferedImage;
// JOSE IGNACIO GARCÍA JÁVEGA

class Barry
{
  // Tamaño y posición del personaje
  PVector tam_personaje,  
          pos_actual;
  float pos_inicial_y;
  
  // Imágenes para mostrar a Barry (cuando corre, usa el propulsor y va cayendo)
  PImage[] correr, 
           subir, 
           caer;
  
  // Variables para aplicar la aceleración
  float m,  // masa
        v,  // velocidad
        Ec, // energía cinética
        P,  // potencia
        dt, // tiempo
        k,  // coeficiente de rozamiento
        x;  // tamaño
 
 // Variables que se usan para mostrar los sprites
 int currentFrame_Barry, numSprites_Barry;
  
  Barry(float i_y, PVector actual, PVector tam, float m1, float P1, float k1)
  {
    pos_inicial_y = i_y;
    pos_actual = actual;
    tam_personaje = tam;
    
    currentFrame_Barry = 0;
    numSprites_Barry = 2;
    
    correr = new PImage[numSprites_Barry];
    subir = new PImage[numSprites_Barry];
    caer = new PImage[numSprites_Barry];
    
    m = m1;
    v = 0;
    Ec = 0;
    P = P1;
    dt = 0.5;
    k = k1;
    x = 0;
   
    for(int i=0; i < numSprites_Barry; i++)
    {
      correr[i]  = loadImage("Image " + i + ".png");
      subir[i]  = loadImage("Image " + (i + 2) + ".png");
      caer[i]  = loadImage("Image " + (i + 4) + ".png");
    }
    
  }
  
  // Función que se usa para propulsar o hacer caer a Barry
  void aplicar_fuerza(float valor)
  {
    // Aplicamos potencia para actualizar Ec
    Ec =  valor * P * dt;
    
    // Actualizamos la velocidad
    v = sqrt(2 * Ec/m);
    
   // Calculamos la nueva posición de Barry (dependiendo de si sube o baja)
    if(valor == 5.0)
      x += v * dt;
    else
      x -= v * dt;
   
    // Calculamos la nueva energía cinética, con el rozamiento
    Ec  += -k * pow(v,2) * dt;
  }
  
  // Mostramos a Barry corriendo
  void correr()
  {
    image(correr[currentFrame_Barry % 2], pos_actual.x, pos_inicial_y, 
          tam_personaje.x, tam_personaje.y);
    currentFrame_Barry++;
  }
  
  // Mostramos a Barry propulsándose, dependiendo de la altura en que se encuentre
  void subir()
  {
    aplicar_fuerza(15.0);
    pos_actual.y = pos_inicial_y + x;
    image(subir[currentFrame_Barry % 2], pos_actual.x, pos_actual.y, 
          tam_personaje.x, tam_personaje.y);
    currentFrame_Barry++;
    
  }
  
  // Mostramos a Barry cayendo, dependiendo de la altura en que se encuentre
  void caer()
  {
    aplicar_fuerza(5.0);
    pos_actual.y = pos_inicial_y + x;
    image(caer[currentFrame_Barry % 2], pos_actual.x, pos_actual.y, 
          tam_personaje.x, tam_personaje.y);
    currentFrame_Barry++;
  }
 
}
