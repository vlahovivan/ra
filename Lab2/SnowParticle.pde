public class SnowParticle extends Particle {
    PImage snowImage;
    float imageSize;


    SnowParticle(PVector position, boolean alive) {
        super(position, new PVector(0, 0, 0), new PVector(0, 0.81, 0), alive);
        this.snowImage = loadImage("snow-particle.png");
        this.imageSize = random(0.1, 0.25);
    }

    private void rotateAroundAxis(float angle, float x, float y, float z) {
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

    void show(PVector cameraDirection) {
        pushMatrix();

        translate(this.position.x, this.position.y, this.position.z);

        cameraDirection.mult(1 / cameraDirection.mag());
        
        PVector rotationAxis = new PVector(-cameraDirection.y, cameraDirection.x, 0);
        rotateAroundAxis(cameraDirection.z / (cameraDirection.mag()), rotationAxis.x, rotationAxis.y, rotationAxis.z);

        noStroke();
        beginShape();
        texture(snowImage);
        vertex(-this.imageSize/2.0, -this.imageSize/2.0, 0, 0);
        vertex(-this.imageSize/2.0, this.imageSize/2.0, 0, 255);
        vertex(this.imageSize/2.0, this.imageSize/2.0, 255, 255);
        vertex(this.imageSize/2.0, -this.imageSize/2.0, 255, 0);
        endShape();

        // stroke(#ffffff);
        // strokeWeight(4);
        
        // point(0, 0, 0);
        noStroke();

        popMatrix();
    }

    void update() {
        if(this.alive) {
            this.position = PVector.add(this.position, PVector.mult(this.velocity, (1.0 / frameRate)));
            this.velocity = PVector.add(this.velocity, PVector.mult(this.acceleration, (1.0 / frameRate)));
        }
    }

    void revive(PVector position) {
        this.position = position;
        this.velocity = new PVector(0, 0, 0);
        this.alive = true;
        this.imageSize = random(0.1, 0.25);
    }

    void kill() {
        this.alive = false;
    }

    PVector getPosition() {
        return this.position;
    }
}