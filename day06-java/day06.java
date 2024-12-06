import java.util.List;
import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class day06 {
    enum Direction {
        IRRELEVANT,
        UP,
        RIGHT,
        DOWN,
        LEFT,
    }

    enum GuardStatus {
        Patrol,
        Left,
        IsInLoop,
    }

    static List<Position> obstaclePositions = new ArrayList<Position>();
    static Guard guard;

    static Position placedObstruction;

    public static int board_width;
    public static int board_height;

    public static void main(String[] args) {
        try {
            Scanner in = new Scanner(new File("input"));

            int current_column = 0;
            int current_line = 0;

            while (in.hasNextLine()) {
                String line = in.nextLine();
                for (int i = 0; i < line.length(); i++) {
                    switch (line.charAt(i)) {
                        case '#':
                            obstaclePositions.add(new Position(current_column, current_line));
                            break;
                        case '^':
                            guard = new Guard(current_column, current_line);
                            break;
                    }

                    current_column += 1;
                    if (current_column >= board_width) {
                        board_width = current_column;
                    }
                }
                current_line += 1;
                current_column = 0;
                if (current_line >= board_height) {
                    board_height = current_line;
                }
            }

            // Part 1
            while (guard.move(obstaclePositions) == GuardStatus.Patrol) { }
            System.out.println(guard.getHistoryLength());

            //Part 2
            List<Position> usefulPositions = new ArrayList<Position>(guard.positionHistory);
            int loops = 0;
            for (Position pos : usefulPositions) {
                if (pos.compare(guard.initialPosition)) {
                    continue;
                }
                List<Position> newObstacles = new ArrayList<Position>(obstaclePositions);
                newObstacles.add(pos);
                guard.reset();
                GuardStatus guardStatus = GuardStatus.Patrol;
                while (guardStatus == GuardStatus.Patrol) {
                    guardStatus = guard.move(newObstacles);
                    if (guardStatus != GuardStatus.Patrol) {break;}
                }
                if (guardStatus == GuardStatus.IsInLoop) {
                    loops += 1;
                }
            }
            System.out.println(loops);

            in.close();
        } catch (FileNotFoundException e) {
            System.out.println(":(");
        }
    }

    private static class Position {
        public int x;
        public int y;

        public Direction direction = Direction.IRRELEVANT;

        public Position(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public Position(int x, int y, Direction dir) {
            this.x = x;
            this.y = y;
            this.direction = dir;
        }

        public boolean compare(Position other) {
            return this.x == other.x && this.y == other.y;
        }

        @Override
        public String toString() {
            return String.format("[x=%d y=%d]", x, y);
        }
    }

    private static class Guard {
        private Direction direction = Direction.UP;

        private Position position;
        private List<Position> positionHistory = new ArrayList<Position>();

        private Position initialPosition;

        public Guard(int x, int y) {
            this.position = new Position(x, y);
            this.initialPosition = position;
        }

        public void reset() {
            position = initialPosition;
            direction = Direction.UP;
            positionHistory.clear();
        }

        public void addToHistory() {
            for (Position other : positionHistory) {
                if (position.compare(other)) {
                    return;
                }
            }
            positionHistory.add(new Position(position.x, position.y, direction));
        }

        public boolean isInLoop() {
            for (Position other : positionHistory) {
                if (position.compare(other)) {
                    return direction == other.direction;
                }
            }
            return false;
        }

        public int getHistoryLength() {
            return positionHistory.size();
        }

        public GuardStatus move(List<Position> obstacles) {
            addToHistory();
            Position new_position;
            int xOff = 0;
            int yOff = 0;
            switch (direction) {
                case IRRELEVANT:
                    System.out.println("This should never happen");
                case UP:
                    yOff = -1;
                    break;
                case RIGHT:
                    xOff = 1;
                    break;
                case DOWN:
                    yOff = 1;
                    break;
                case LEFT:
                    xOff = -1;
                    break;
            }
            new_position = new Position(position.x + xOff, position.y + yOff);

            boolean turned = false;
            for (Position obstacle : obstacles) {
                if (new_position.compare(obstacle)) {
                    turned = true;
                    switch (direction) {
                        case IRRELEVANT:
                            System.out.println("This should never happen");
                        case UP:
                            direction = Direction.RIGHT;
                            break;
                        case RIGHT:
                            direction = Direction.DOWN;
                            break;
                        case DOWN:
                            direction = Direction.LEFT;
                            break;
                        case LEFT:
                            direction = Direction.UP;
                            break;
                    }
                }
            }
            if (!turned) {
                position = new_position;
            }

            boolean ret_val = position.x < 0 || position.y < 0 || position.x >= day06.board_width
                    || position.y >= day06.board_height;

            if (isInLoop()) {
                return GuardStatus.IsInLoop;
            }
            if (ret_val) {
                return GuardStatus.Left;
            }
            return GuardStatus.Patrol;
        }
    }
}
