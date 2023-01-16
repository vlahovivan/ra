BallGame game;

void setup() {
    size(1200, 600);
    game = new BallGame();
}

void draw() {
    game.update();
}
