import peasy.*;

PeasyCam cam;

PShape s;

String[] lines;
ArrayList<PVector> points = new ArrayList<>();

PMatrix3D matrix = new PMatrix3D(-1, 3, -3, 1, 3, -6, 3, 0, -3, 0, 3, 0, 1, 4, 1, 0);

int framesPerAnimation = 603;

void setup() {
  size(800, 800, P3D);
  // The ".obj" file must be in the data folder
  // of the current sketch to load successfully
  s = loadShape("aircraft747.obj");
  s.setFill(color(255,255,255));

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(1);
  cam.setMaximumDistance(10);
  lines = loadStrings("spline-points.txt");

  for(String line : lines) {
    String[] tokens = splitTokens(line, " ");
    PVector point = new PVector(float(tokens[0]), float(tokens[1]), float(tokens[2]));

    points.add(point);
    println(point);
  }
}

void drawCoordinateAxes() {
  strokeWeight(1);
  float axisEnd = 200;
  float otherDims = 0.1;

  // X red
  stroke(#cc0000);
  line(-axisEnd, 0, 0, axisEnd, 0, 0);

  // Y green
  stroke(#00cc00);
  line(0, -axisEnd, 0, 0, axisEnd, 0);

  // Z blue
  stroke(#0000cc);
  line(0, 0, -axisEnd, 0, 0, axisEnd);
}

PVector calculateSpline(int seg, float t) {
  float c1 = - 1 * (t*t*t) + 3 * (t*t) - 3 * t + 1;
  float c2 =   3 * (t*t*t) - 6 * (t*t)         + 4;
  float c3 = - 3 * (t*t*t) + 3 * (t*t) + 3 * t + 1;
  float c4 =   1 * (t*t*t)                        ;

  PVector r1 = points.get(seg);
  PVector r2 = points.get(seg+1);
  PVector r3 = points.get(seg+2);
  PVector r4 = points.get(seg+3);

  float x = c1 * r1.x + c2 * r2.x + c3 * r3.x + c4 * r4.x;
  float y = c1 * r1.y + c2 * r2.y + c3 * r3.y + c4 * r4.y;
  float z = c1 * r1.z + c2 * r2.z + c3 * r3.z + c4 * r4.z;

  x /= 6;
  y /= 6;
  z /= 6;

  return new PVector(x, y, z);
}

PVector calculateTangent(int seg, float t) {

  float c1 = - 1 * (t*t) + 2 * t - 1;
  float c2 =   3 * (t*t) - 4 * t    ;
  float c3 = - 3 * (t*t) + 2 * t + 1;
  float c4 =   1 * (t*t)            ;

  PVector r1 = points.get(seg);
  PVector r2 = points.get(seg+1);
  PVector r3 = points.get(seg+2);
  PVector r4 = points.get(seg+3);

  float x = c1 * r1.x + c2 * r2.x + c3 * r3.x + c4 * r4.x;
  float y = c1 * r1.y + c2 * r2.y + c3 * r3.y + c4 * r4.y;
  float z = c1 * r1.z + c2 * r2.z + c3 * r3.z + c4 * r4.z;

  x /= 2;
  y /= 2;
  z /= 2;

  return new PVector(x, y, z);
}

void drawSpline() {
  boolean firstPoint = true;
  float lastX = 0.0, lastY = 0.0, lastZ = 0.0;

  strokeWeight(5);
  randomSeed(0);
  colorMode(HSB);
  
  for(int i=0; i<points.size() - 3; i++) {
    stroke(color(random(255), 255, 255));
    for(float t=0.0; t<=1.0; t+=0.01) {
      PVector point = calculateSpline(i, t);
      float x = point.x;
      float y = point.y;
      float z = point.z;

      if(!firstPoint) {
        line(lastX, lastY, lastZ, x, y, z);
      } else {
        firstPoint = false;
      }

      lastX = x;
      lastY = y;
      lastZ = z;
    }
  }

  colorMode(RGB);
}

void rotateAroundAxis(float angle, float x, float y, float z) {
  float sina = sin(angle);
  float cosa = cos(angle);
  float oneMinCosa = 1 - cosa;

  float r00 = cosa + x*x*oneMinCosa;
  float r01 = x*y*oneMinCosa - z * sina;
  float r02 = x*z*oneMinCosa + y*sina;
  float r10 = y*z*oneMinCosa + z*sina;
  float r11 = cosa + y*y*oneMinCosa;
  float r12 = y*z*oneMinCosa - x*sina;
  float r20 = z*x*oneMinCosa - y*sina;
  float r21 = z*y*oneMinCosa + x*sina;
  float r22 = cosa + z*z*oneMinCosa;

  applyMatrix(r00, r01, r02, 0.0,
              r10, r11, r12, 0.0,
              r20, r21, r22, 0.0,
              0.0, 0.0, 0.0, 1.0);
}

void draw() {
  background(0);
  perspective(PI/3.0,(float)width/height,1,100000);
  scale(1, -1, 1);
  lights();
  drawCoordinateAxes();
  drawSpline();


  int animationTime = frameCount % framesPerAnimation;
  int numOfSegments = points.size() - 3;

  int framesPerSegment = framesPerAnimation / numOfSegments;
  int segment = animationTime / framesPerSegment;
  float t = (float)(animationTime % framesPerSegment) / (framesPerSegment);

  for(int i=0; i<3; i++) {
    PVector point1 = points.get(segment + i);
    PVector point2 = points.get(segment + i + 1);
    stroke(#6666ff);
    strokeWeight(6);
    point(point1.x, point1.y, point1.z);
    if(i==2) {
      point(point2.x, point2.y, point2.z);
    }
    
    strokeWeight(2);
    
    line(point1.x, point1.y, point1.z, point2.x, point2.y, point2.z);
  }

  PVector pos = calculateSpline(segment, t);
  PVector tang = calculateTangent(segment, t).mult(0.5);

  PVector axis = new PVector(-tang.y, tang.x, 0).normalize();

  float angle = acos(tang.z / tang.mag());

  translate(pos.x, pos.y, pos.z);

  stroke(#00ffff);
  strokeWeight(3);
  line(0, 0, 0, tang.x, tang.y, tang.z);
  stroke(#ffff00);
  line(0, 0, 0, axis.x, axis.y, axis.z);
  
  rotateAroundAxis(angle, axis.x, axis.y, axis.z);

  shape(s, 0, 0);
}