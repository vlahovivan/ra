public class BallGame {
    public PVector ballPosition;
    public PVector ballVelocity;
    public PVector ballAcceleration;

    private float BALL_RADIUS = 5;
    private float BALL_SPEED = 250;
    private float BALL_DECELERATION = 20;

    public ArrayList<Wall> walls;
    private int NUMBER_OF_WALLS = 5;
    private int WALL_WIDTH = 20;
    private int WALL_HEIGHT = 200;

    private float HOLE_RADIUS = 10;
    private PVector HOLE_POSITION = new PVector(6*width/7, height/2);


    private boolean shootingStarted = false;
    private boolean isBallMoving = false;
    private PVector shootingDirection;
    private PVector shootingStart;

    private boolean gameWon = false;
    private boolean restartStarted = false;

    private int attempts = 0;
    
    public BallGame() {
        this.ballPosition = new PVector(width/7, height/2);
        this.ballVelocity = new PVector(0, 0);
        this.ballAcceleration = new PVector(0, 0);

        this.walls = new ArrayList<>();
    
        for(int i=0; i<NUMBER_OF_WALLS; i++) {
            float x1 = 2*width/7 + i * (3*width/7) / NUMBER_OF_WALLS;
            float y1 = random(height-WALL_HEIGHT);
            float x2 = x1 + WALL_WIDTH;
            float y2 = y1 + WALL_HEIGHT;
            this.walls.add(new Wall(x1, y1, x2, y2));
        }
    }

    public void update() {
        background(0);
        noStroke();

        if(ballVelocity.mag() < 5) {
            ballVelocity = new PVector(0, 0);
            isBallMoving = false;
        }

        if(gameWon) {
            if(mousePressed) {
                restartStarted = true;
            } else {
                if(restartStarted) {
                    ballAcceleration.set(0, 0);
                    ballVelocity.set(0, 0);
                    ballPosition.set(width/7, height/2);

                    walls.clear();

                    for(int i=0; i<NUMBER_OF_WALLS; i++) {
                        float x1 = 2*width/7 + i * (3*width/7) / NUMBER_OF_WALLS;
                        float y1 = random(height-WALL_HEIGHT);
                        float x2 = x1 + WALL_WIDTH;
                        float y2 = y1 + WALL_HEIGHT;
                        this.walls.add(new Wall(x1, y1, x2, y2));
                    }

                    isBallMoving = false;
                    shootingStarted = false;
                    restartStarted = false;
                    attempts = 0;
                    gameWon = false;

                }
            }
        } else if(!isBallMoving) {
            if(mousePressed) {
                if(!shootingStarted) {
                    shootingStarted = true;
                    shootingStart = new PVector(mouseX, mouseY);
                } else {
                    shootingDirection = PVector.sub(shootingStart, new PVector(mouseX, mouseY));

                    float angle = atan2(shootingDirection.y, shootingDirection.x);
                    stroke(#ffffff);
                    strokeWeight(3);
                    line(ballPosition.x, ballPosition.y, ballPosition.x + cos(angle) * 50, ballPosition.y + sin(angle) * 50);
                    line(shootingStart.x, shootingStart.y, mouseX, mouseY);
                }

                fill(#ffffff);
                noStroke();
                ellipse(shootingStart.x, shootingStart.y, 10, 10);
            } else {
                if(shootingStarted) {
                    ballVelocity = shootingDirection.copy();
                    ballVelocity.normalize();
                    ballVelocity.mult(BALL_SPEED);

                    ballAcceleration = ballVelocity.copy().normalize().mult(-BALL_DECELERATION);

                    attempts++;

                    isBallMoving = true;
                    shootingStarted = false;
                }
            }
        } else {
            ballPosition.add(PVector.mult(ballVelocity, 1.0 / frameRate));
            ballVelocity.add(PVector.mult(ballAcceleration, 1.0 / frameRate));
        }

        // Collisions

        // Border
        if(ballPosition.x - BALL_RADIUS < 0 || ballPosition.x + BALL_RADIUS > width) {
            ballVelocity.x *= -1;
            ballAcceleration.x *= -1;
            ballPosition.x = constrain(ballPosition.x, 1, width - 1);
        }

        if(ballPosition.y - BALL_RADIUS < 0 || ballPosition.y + BALL_RADIUS > height) {
            ballVelocity.y *= -1;
            ballAcceleration.y *= -1;
            ballPosition.y = constrain(ballPosition.y, 1, height - 1);
        }

        // Walls
        for(int i=0; i<NUMBER_OF_WALLS; i++) {
            if(
                (
                    (ballPosition.x + BALL_RADIUS) >= walls.get(i).x1 && 
                    (ballPosition.x + BALL_RADIUS) <= walls.get(i).x2 &&
                    (ballPosition.y >= walls.get(i).y1) &&
                    (ballPosition.y <= walls.get(i).y2)
                ) ||
                (
                    (ballPosition.x - BALL_RADIUS) >= walls.get(i).x1 && 
                    (ballPosition.x - BALL_RADIUS) <= walls.get(i).x2 &&
                    (ballPosition.y >= walls.get(i).y1) &&
                    (ballPosition.y <= walls.get(i).y2)
                )
            ) {
                ballVelocity.x *= -1;
                ballAcceleration.x *= -1;
            }
            
            if(
                (
                    (ballPosition.y + BALL_RADIUS) >= walls.get(i).y1 && 
                    (ballPosition.y + BALL_RADIUS) <= walls.get(i).y2 &&
                    (ballPosition.x >= walls.get(i).x1) &&
                    (ballPosition.x <= walls.get(i).x2)
                ) ||
                (
                    (ballPosition.y - BALL_RADIUS) >= walls.get(i).y1 && 
                    (ballPosition.y - BALL_RADIUS) <= walls.get(i).y2 && 
                    (ballPosition.x >= walls.get(i).x1) &&
                    (ballPosition.x <= walls.get(i).x2)
                )
            ) {
                ballVelocity.y *= -1;
                ballAcceleration.y *= -1;
            }
        }

        // Hole
        if(PVector.dist(ballPosition, HOLE_POSITION) < HOLE_RADIUS + BALL_RADIUS) {
            gameWon = true;
        }



        // Walls
        rectMode(CORNERS);
        fill(#ffffff);
        noStroke();
        for(int i=0; i<NUMBER_OF_WALLS; i++) {
            rect(walls.get(i).x1, walls.get(i).y1, walls.get(i).x2, walls.get(i).y2);
        }

        // Hole
        fill(#ff6767);
        noStroke();
        ellipse(HOLE_POSITION.x, HOLE_POSITION.y, HOLE_RADIUS*2, HOLE_RADIUS*2);

        // Ball
        fill(#67ff67);
        noStroke();
        ellipse(ballPosition.x, ballPosition.y, BALL_RADIUS*2, BALL_RADIUS*2);

        fill(#ffffff);
        textSize(24);
        textAlign(RIGHT);
        text("Attempts: " + attempts, width - 20, height - 24);

        fill(#67ff67);
        if(gameWon) {
            rectMode(CENTER);
            textSize(128);
            textAlign(CENTER);
            text("You won!", width/2, height/2); 
            textSize(32);
            text("Click on the screen to restart", width/2, height/2 + 40);
        }

    }
}