
import gifAnimation.*;

GifMaker gifMaker;

float x = 200; // x coordinate of the origin
float y = 100; // y coordinate of the origin
float l1 = 150; // The distance between the origin and the first weight
float l2 = 70;  // The distance between the first weight and the second weight
float m1 = 100; // the weight of the first weight
float m2 = 30;  // the weight of the second weight
float g = 9.8;  // the value of the gravitational rate of acceleration
float w1 = 0;   // the natural frequency of the first pendulum
float w2 = 0;   // the natural frequency of the fsecond pendulum
float theta1 = 30;  // the angle between the vewrtical axis and the first weight
float theta2 = 10;  // the angle between the vewrtical axis and the second weight
float dt = 0.5;    // time step

void setup() {
  size(400, 400);
  gifMaker = new GifMaker(this, "double_pendulums.gif"); 
  gifMaker.setRepeat(0); 
  gifMaker.setDelay(20);
}

void draw() {
  
  background(0);
  float x1 = x + l1*sin(theta1);
  float y1 = y + l1*cos(theta1);
  float x2 = x1 + l2*sin(theta2);
  float y2 = y1 + l2*cos(theta2);

  ellipse(x1, y1, 20, 20);
  ellipse(x2, y2, 20, 20);
  line(x, y, x1, y1);
  stroke(255,0,0);
  line(x1, y1, x2, y2);
  stroke(255,0,0);
  
  // I acquired the following equations 
  //from https://www.myphysicslab.com/pendulum/double-pendulum-en.html
  float v1_up = -g*(2*m1+m2)*sin(theta1)-m2*g*sin(theta1-2*theta2)-2*sin(theta1-theta2)*m2*(w2*w2*l2+w1*w1*l1*cos(theta1-theta2));
  float v1_down = l1*(2*m1+m2-m2*cos(2*theta1-2*theta2));
  float v1 = v1_up/v1_down;

  float v2_up = 2*sin(theta1 - theta2)*(w1*w1*l1*(m1+m2)+g*(m1+m2)*cos(theta1)+w2*w2*l2*m2*cos(theta1-theta2));
  float v2_down = l2*(2*m1+m2-m2*cos(2*theta1-2*theta2));
  float v2 = v2_up/v2_down;

  float a1_up = -g*(2*m1+m2)*sin(theta1)-m2*g*sin(theta1-2*theta2)-2*(theta1-theta2)*m2*(v2*v2*l2+v1*v1*l1*cos(theta1-theta2));
  float a1_down = l1*(2*m1+m2-m2*cos(2*theta1-2*theta2));
  float a1 = a1_up/a1_down;

  float a2_up = 2*sin(theta1-theta2)*(v1*v1*l1*(m1+m2)+g*(m1+m2)*cos(theta1)+v2*v2*l2*m2*cos(theta1-theta2));
  float a2_down = l1*(2*m1+m2-m2*cos(2*theta1-2*theta2));
  float a2 = a2_up/a2_down;

  v1 += a1*dt;
  v2 += a2*dt;
  w1 += v1*dt;
  w2 += v2*dt;
  theta1 += w1*dt;
  theta2 += w2*dt;
  
  gifMaker.addFrame(); 

  if (frameCount >= 100){
    gifMaker.finish(); 
    exit();
  }
}
