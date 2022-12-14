public abstract class Particle {
    PVector position;
    PVector velocity;
    PVector acceleration;

    boolean alive;

    public Particle(PVector position, PVector velocity, PVector acceleration, boolean alive) {
        this.position = position;
        this.velocity = velocity;
        this.acceleration = acceleration;
        this.alive = alive;
    }

    abstract void show(PVector cameraRotation);
    abstract void update();
}