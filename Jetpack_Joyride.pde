import controlP5.*;
import java.awt.Component;
import java.awt.image.BufferedImage;
// JOSE IGNACIO GARCÍA JÁVEGA

ControlP5 cp5;

// Nombre de los estados que hay, que es cada pantalla de la aplicación:
// 1. Pantalla de inicio
// 2. Juego
// 3. Game Over
// 4. Salir
String estado = "Pantalla de inicio";

// Imágenes que se usan para representar la mayoría de las pantallas y los 
// botones que aparecen en 1. Pantalla de inicio
PImage titulo, 
       game_over,
       adios, 
       play, 
       exit;

// Botones que se usan en 1. Pantalla de inicio
Button Jugar, 
       Salir;

// Metros recorridos y monedas recogidas en el momento en que se juega
int metros = 0, 
    monedas = 0, 
    
// Cantidad máxima de metros recorridos y monedas recogidas
    max_metros = 0, 
    max_monedas = 0,
 
    
// Temporizador para mostrar las pantallas 3. Game Over y 4. Salir
    tiempo = 0;

// Lista que contiene los componentes gráficos del juego

// No es necesario un array de Barry ya que solo hay uno en todo momento, pero de 
// esta forma podemos destruirlo cuando dejemos de jugar
ArrayList <Barry> barry; 
ArrayList <Moneda> coins;
ArrayList <Cohete> rockets; 

void setup() 
{ 
  // Características de la aplicación en el dispositivo
  orientation(LANDSCAPE);
  fullScreen(); 
  
  cp5 = new ControlP5(this);
  
  // Inicializamos todos los ArrayLists y todas las imágenes
  barry = new ArrayList<Barry>();
  coins = new ArrayList<Moneda>();
  rockets = new ArrayList<Cohete>();
  
  titulo = loadImage("titulo.jpg");
  game_over = loadImage("game_over.jpg");
  adios = loadImage("adios.png");
  play = loadImage("Play.png");
  exit = loadImage("Exit.png");
  
  // Como la pantalla que mostramos al comienzo es 1. Pantalla de inicio, en
  // setup() creamos y mostramos sus dos botones
  Jugar = cp5.addButton("Jugar").setLabel("Jugar").setBroadcast(false).setSize(play)
             .setPosition(width/2-125, height - 300).setImage(play).setBroadcast(true).show();
       
  Salir = cp5.addButton("Salir").setLabel("Salir").setBroadcast(false).setSize(exit)
             .setPosition(width/2-125, height - 120).setImage(exit).setBroadcast(true).show();
       
}

void draw()
{
  
  // Mostramos lo deseado según el estado en que esté indicado
  switch (estado)
  {
    // 1. Pantalla de inicio
    case "Pantalla de inicio":
    
    image(titulo, 0, 0, width, height);
    
    break;
    
    // 2. Juego
    case "Juego":
    
      // Usamos un fondo el blanco para camuflar el fondo de los sprites
      background(255,255,255);
      frameRate(12);
      
      // Si es jugador toca la pantalla, hacemos que el personaje suba
      if(mousePressed)
        barry.get(0).subir();
      
      // En caso contrario...
      else
      {
        // Hacemos que corra por el suelo...
        if(barry.get(0).x >= 0)
          barry.get(0).correr();
          
       //... o, en caso contrario, le aplicamos una aceleración para que descienda
        else
          barry.get(0).caer();
      }
   
     // Introducimos cohetes y monedas en la escena cada cierto tiempo diferente.
     // Para simular un poco "lo aleatorio". Se colocan entre la parte superior del
     // dispositivo y el suelo del juego. Así se asegura que habrá colisión con el 
     // jugador
     if(metros % 50 == 0)
          coins.add(new Moneda(width - 50, random(0, height - 150),  50, 50));
     
     if(metros % 30 == 0)
          rockets.add(new Cohete(width - 50, random(0, height - 150),  50, 50));
  
     // En cada moneda que haya en la escena...
     for(int i = 0; i < coins.size(); i++)
     {
       //... la mostramos...
       image(coins.get(i).imagen, coins.get(i).pos_x, coins.get(i).pos_y, 
             coins.get(i).tam_x, coins.get(i).tam_y);
       
       // ... la desplazamos en dirección hacia el jugador...
       coins.get(i).pos_x -= 15;
   
       // ... y la eliminamos si el jugador la ha tocado.
       if(coins.get(i).coger_moneda(barry.get(0)))
         coins.remove(i);
     }
     
     // En cada cohete que haya en la escena...
     for(int j = 0; j < rockets.size(); j++)
     {
       // ... lo mostramos...
       rockets.get(j).mostrar_cohete();
       
       // ... lo desplazamos en dirección hacia el jugador...
       rockets.get(j).pos_x -= 15;
       
       // ... y vemos si dicho cohete choca con el jugador.
       choque_cohete(j);
     }
     
     
     textSize(35);
     fill(0,0,0);
     
     // El suelo del juego
     line(0, height - 100, width, height - 100);
     
     // Los resultados actuales durante la partida
     text("SCORE: " + metros + " m", 10, 30);
     text("COINS: " + monedas, 10, 70);
     metros++; //incrementamos la cantidad de trayecto que hace el jugador
     
     // Comprobamos si los resultados actuales son mayores que los máximos obtenidos
     if(max_metros < metros)
       max_metros = metros;
             
     if(max_monedas < monedas)
       max_monedas = monedas;
     
     // Los resultados máximos obtenidos
     text("HIGH SCORE: " + max_metros + " m", width - 375, 30);
     text("HIGH COINS: " + max_monedas, width - 375, 70);
     
   break;
   
   // 3. Game Over
   case "Game Over":
   
     // Si el temporizador de 3 segundos aún no ha terminado...
     if(second() <= tiempo + 3)
     {
       // ...mostramos la pantalla que finaliza la partida, junto con los resultados
       // obtenidos
       image(game_over, 0, 0, width, height);
       textSize(35);
       fill(255);
       text("SCORE: " + metros + " m", 10, 30);
       text("COINS: " + monedas, 10, 70);
     }
     
     // Pero si ya ha terminado de mostrar la pantalla, cambiamos el estado
     //  a 1. Pantalla de inicio, mostrando sus botones
     else
     {
       estado = "Pantalla de inicio";
       Jugar.show();
       Salir.show();
     }
     
   break;
   
   // 4. Salir
   case "Salir":
   
     // Si el temporizador de 2 segundos aún no ha terminado, mostramos la 
     // imagen de despedida, y al acabar, cerramos la aplicación.
     if(second() <= tiempo + 2)
       image(adios, 0, 0, width, height);
     else
       exit();
       
   break;
  }
}

// Función que comprueba si el jugador colisiona con un cohete
void choque_cohete(int i)
{
  PVector d = new PVector(rockets.get(i).pos_x - barry.get(0).pos_actual.x, 
                          rockets.get(i).pos_y - barry.get(0).pos_actual.y);
  float distance = sqrt(pow(d.x,2) + pow(d.y,2));
  float minDist = rockets.get(i).tam_x/2 + barry.get(0).tam_personaje.x/2;
  
  // Si hay colisión...
  if (distance < minDist) 
  { 
    // ...eliminamos los componentes gráficos...
    barry.remove(0);
        
    for(int j = 0; j < coins.size(); j++)
      coins.remove(j);
        
    for(int j = 0; j < rockets.size(); j++)
      rockets.remove(j);
    
    // ...e inicializamos el temporizador para mostrar 3. Game Over
    tiempo = second();
    estado = "Game Over";
  }
  
  // Pero si no hay colisión...
  else
  {
    // ...lo eliminamos del ArrayList si ese cohete se encuentra detrás del jugador
    // (ya que no habrá en ningun momento colisión)
    if(rockets.get(i).pos_x <= 0)
      rockets.remove(i); 
  }
}

void controlEvent(ControlEvent theEvent) 
{
  
  switch(theEvent.getController().getLabel())
  {
    // El botón Play
    case "Jugar":
    
      // Ocultamos los botones de 1. Pantalla de inicio
      Jugar.hide();
      Salir.hide();
      
      // Inicializamos el juego
      barry.add(new Barry(height - 200, new PVector(330,0), new PVector(100, 100), 0.05, 30, 5));
      metros = 0;
      monedas = 0;
      
      // Cambiamos el estado
      estado = "Juego";
      
    break;
    
    // El botón Exit
    case "Salir":
    
      // Ocultamos los botones de 1. Pantalla de inicio
      Jugar.hide();
      Salir.hide();
      
      // ...e inicializamos el temporizador para mostrar 4. Salir
      tiempo = second();
      estado = "Salir";
      
    break;
 
  }

}
