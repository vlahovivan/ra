public class SnowParticleGenerator extends ParticleGenerator {
    float generatorWidth = 3.0;
    float generatorHeight = 3.0;

    float revivalProbability = 0.025;

    ArrayList<SnowParticle> particlesPool;

    public SnowParticleGenerator(PVector position, int maxNumOfParticles) {
        super(position);
        this.particlesPool = new ArrayList<SnowParticle>();

        for(int i=0; i<maxNumOfParticles; i++) {
            float posX = random(-generatorWidth / 2.0, generatorWidth / 2.0);
            float posZ = random(-generatorHeight / 2.0, generatorHeight / 2.0);
            this.particlesPool.add(new SnowParticle(PVector.add(this.position, new PVector(posX, 0, posZ)), false));
        }
    }

    public void show(PVector cameraDirection) {
        pushMatrix();
        translate(this.position.x, this.position.y, this.position.z);
        fill(#ffffff);
        box(3, 0.25, 3);
        popMatrix();
        for(SnowParticle sp : this.particlesPool) {
            if(sp.alive) sp.show(cameraDirection);
        }
    }

    public void update() {
        for(SnowParticle sp : this.particlesPool) {
            if(sp.alive) {
                sp.update();
                PVector particlePosition = sp.getPosition();
                
                if(particlePosition.y > 0) {
                    sp.kill();
                }
            } else {
                if(random(1.0) < revivalProbability) {
                    float posX = random(-generatorWidth / 2.0, generatorWidth / 2.0);
                    float posZ = random(-generatorHeight / 2.0, generatorHeight / 2.0);
                    sp.revive(PVector.add(this.position, new PVector(posX, 0, posZ)));
                }
            }
        }
    }

    void move(PVector delta) {
        this.position = PVector.add(this.position, delta);
    }
}