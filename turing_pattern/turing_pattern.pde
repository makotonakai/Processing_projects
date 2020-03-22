
import gifAnimation.*;

GifMaker gifMaker;

int NX = 50;
int NY = 50;
Cell[][] cells;
Cell[][] cellbuf;

//Giraff
float Du = 1.00; // Diffusion coefficient of the substance u
float Dv = 9.00; // Diffusion coefficient of the substance v
float dt = 0.02;  // time step

void setup() {
  size(600, 600);
  cells = new Cell[NX][NY];
  cellbuf = new Cell[NX][NY];
  float cell_width = width/NX;
  float cell_height = height/NY;
  for (int i = 0; i < NX; i++) {
    for (int j = 0; j < NY; j++) {
      
      //put random binary number of each cell as its value of u and v
      cells[i][j] = new Cell(i*cell_width, j*cell_height, (random(100)>50)? 1:0, (random(100)>50)? 1:0);
      cellbuf[i][j] = new Cell();
    }
  }
  gifMaker = new GifMaker(this, "turing_pattern.gif"); 
  gifMaker.setRepeat(0); 
  gifMaker.setDelay(10);
}  

void draw() {

  for (int j = 0; j < NY; j++) {
    for (int i = 0; i < NX; i++) {
      // Preserve the value of variables to the other array
      cellbuf[i][j].u = cells[i][j].u;
      cellbuf[i][j].v = cells[i][j].v;
    }
  }

  for (int i = 0; i < NX; i++) {
    for (int j = 0; j < NY; j++) {
      // The state of the cell(i,j) depends on its Von Neumann's neightborhood 
      int i0 = (i==0)? NX-1:i-1;
      int i1 = (i==NX-1)?0:i+1;
      int j0 = (j==0)? NY-1:j-1;
      int j1 = (j==NX-1)? 0 : j+1;

      //Laplacian with respect to  the variable u calculated by Euler's method
      float nabla_u = (cellbuf[i1][j].u + cellbuf[i0][j].u + cellbuf[i][j0].u + cellbuf[i][j1].u - 4*cellbuf[i][j].u);
      
      //Laplacian of the variable v calculated by Euler's method
      float nabla_v = (cellbuf[i1][j].v + cellbuf[i0][j].v + cellbuf[i][j0].v + cellbuf[i][j1].v - 4*cellbuf[i][j].v);
      
      
      // I took the following formulas from https://qiita.com/krrka/items/e5c0720ac6382e61dc60
      // Derivative with respect to  the variable u 
      float du = Du*nabla_u + cellbuf[i][j].u*(1-cellbuf[i][j].u*cellbuf[i][j].u) - cellbuf[i][j].v;
                  
       // Derivative of the variable v           
      float dv = Dv*nabla_v + 3*cellbuf[i][j].u - 2*cellbuf[i][j].v;
      
      
      cells[i][j].u += du*dt;
      cells[i][j].v += dv*dt;
    }
  }

  float cell_width = width/NX;
  float cell_height = height/NY;
  for (int j = 0; j < NY; j++) {
    for (int i = 0; i < NX; i++) {
      if (cells[i][j].u >= cells[i][j].v) {
        rect(cells[i][j].x, cells[i][j].y, cell_width, cell_height);
        fill(255,255,0);
      } else {
        rect(cells[i][j].x, cells[i][j].y, cell_width, cell_height);
        fill(0,0,0);
      }
   
    }
  }
  gifMaker.addFrame(); 

  if (frameCount >= 300){
    gifMaker.finish(); 
    exit();
  }
}

class Cell {
  float x, y, u, v;

  //Default constructor
  Cell() {
    this.x = 0;
    this.y = 0;
    this.u = 0;
    this.v = 0;
  }

  Cell(float _x, float _y, float _u, float _v) {
    this.x = _x;
    this.y = _y;
    this.u = _u;
    this.v = _v;
  }
}
