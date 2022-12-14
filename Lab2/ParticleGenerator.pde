public abstract class ParticleGenerator {
    PVector position;

    public ParticleGenerator(PVector position) {
        this.position = position;
    }

    abstract void update();
    abstract void show(PVector cameraRotation);

}