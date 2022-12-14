import peasy.*;

PeasyCam cam;

SnowParticleGenerator spg;
SnowParticleGenerator spg2;

PVector spgMoveVector;
boolean spgMoves;
float spgMoveSpeed = 0.05;

void setup() {
    size(800, 800, P3D);

    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(1);
    cam.setMaximumDistance(10);

    spg = new SnowParticleGenerator(new PVector(0, -5, 0), 200);   
    spg2 = new SnowParticleGenerator(new PVector(-2, -5, -2), 200);
    imageMode(CENTER);
    spgMoves = false;
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


void draw() {
    background(#87ceeb);
    perspective(PI/3.0,(float)width/height,1,100000);
    lights();
    drawCoordinateAxes();

    PVector camLookAt = new PVector(cam.getLookAt()[0], cam.getLookAt()[1], cam.getLookAt()[2]);
    PVector camPosition = new PVector(cam.getPosition()[0], cam.getPosition()[1], cam.getPosition()[2]);

    PVector cameraDirection = PVector.sub(camPosition, camLookAt);

    spg.show(cameraDirection);
    spg.update();

    spg2.show(cameraDirection);
    spg2.update();

    if(spgMoves) {
        spg.move(spgMoveVector);
        spg2.move(spgMoveVector);
    }
}

void keyPressed() {
    if(key == CODED) {
        if(keyCode == LEFT) {
            spgMoves = true;
            spgMoveVector = new PVector(-spgMoveSpeed, 0, 0);
        }else if(keyCode == RIGHT) {
            spgMoves = true;
            spgMoveVector = new PVector(spgMoveSpeed, 0, 0);
        }else if(keyCode == UP) {
            spgMoves = true;
            spgMoveVector = new PVector(0, 0, spgMoveSpeed);
        }else if(keyCode == DOWN) {
            spgMoves = true;
            spgMoveVector = new PVector(0, 0, -spgMoveSpeed);
        } 
    }
}

void keyReleased() {
    spgMoves = false;   
}
