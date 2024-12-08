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

    static Guard guard;

    static Position placedObstruction;

    public static int board_width = 130;
    public static int board_height = 130;
    //static List<Position> obstaclePositions = new ArrayList<Position>();
    static boolean[][] obstaclePositions = new boolean[board_height][board_width];

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
                            obstaclePositions[current_line][current_column] = true;
                            break;
                        case '^':
                            guard = new Guard(current_column, current_line);
                            break;
                    }

                    current_column += 1;
                }
                current_line += 1;
                current_column = 0;
            }

            // Part 1
            while (guard.move(obstaclePositions, true) == GuardStatus.Patrol) { }
            System.out.println(guard.getHistoryLength());

            //Part 2
            List<Position> usefulPositions = new ArrayList<Position>(guard.positionHistory);
            int loops = 0;
            for (Position pos : usefulPositions) {
                if (pos.compare(guard.initialPosition)) {
                    continue;
                }
                obstaclePositions[pos.y][pos.x] = true;
                guard.reset();
                GuardStatus guardStatus = GuardStatus.Patrol;
                while (guardStatus == GuardStatus.Patrol) {
                    guardStatus = guard.move(obstaclePositions, false);
                    if (guardStatus != GuardStatus.Patrol) {break;}
                }
                if (guardStatus == GuardStatus.IsInLoop) {
                    loops += 1;
                }
                obstaclePositions[pos.y][pos.x] = false;
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
    }

    private static class Guard {
        private Direction direction = Direction.UP;

        private Position position;
        private List<Position> positionHistory = new ArrayList<Position>();
        private List<Position> turns = new ArrayList<Position>();

        private Position initialPosition;

        public Guard(int x, int y) {
            this.position = new Position(x, y);
            this.initialPosition = position;
        }

        public void reset() {
            position = initialPosition;
            direction = Direction.UP;
            positionHistory.clear();
            turns.clear();
        }

        public void addToHistory() {
            for (Position other : positionHistory) {
                if (position.compare(other)) {
                    return;
                }
            }
            positionHistory.add(new Position(position.x, position.y));
        }

        public boolean isInLoop() {
            for (Position other : turns) {
                if (position.compare(other)) {
                    return direction == other.direction;
                }
            }
            return false;
        }

        public int getHistoryLength() {
            return positionHistory.size();
        }

        public GuardStatus move(boolean[][] obstacles, boolean history) {
            if (history)
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
            new_position = new Position(position.x + xOff, position.y + yOff, direction);

            boolean turned = false;

            boolean out_of_bounds = new_position.x < 0 || new_position.y < 0 || new_position.x >= day06.board_width
                || new_position.y >= day06.board_height;
            if (out_of_bounds) {
                return GuardStatus.Left;
            }
            if (obstacles[new_position.y][new_position.x]) {
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
            if (!turned) {
                position = new_position;
            } else {
                if (isInLoop()) {
                    return GuardStatus.IsInLoop;
                }
                turns.add(new Position(position.x, position.y, direction));
            }

            return GuardStatus.Patrol;
        }
    }
}
