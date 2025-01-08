import rl;
import std;
import std::collections;
import std::math::random;

def VecList = List(<int[<2>]>);

struct Player {
    int[<2>] pos;
    int[<2>] dir;
    VecList tail;
} 

struct Food {
    int[<2>] pos;
} 

fn void Player.init(Player* player) {
    player.pos[0] = 4;
    player.pos[1] = 4;
    player.tail.new_init();
    for (int i = 0 ; i < 3; i++) {
        player.tail.push(int[<2>]{4, 4});
    }
}

SimpleRandom rand;
fn void Food.init(Food* food) {
    food.pos.x = std::math::abs((int)(rand.next_int128())) % GRID_SIZE;
    food.pos.y = std::math::abs((int)(rand.next_int128())) % GRID_SIZE;
    std::io::printf("(%d, %d)\n", food.pos.x, food.pos.y);
}

const int WIDTH = 500;
const int GRID_SIZE = 10;
const int GS = WIDTH/GRID_SIZE;

// Compile with ../c3c compile main.c3 --lib raylib --libdir ./lib
fn int main(String[] args)
{
	rl::initWindow(WIDTH, WIDTH, "Snake");
    rl::setTargetFPS(10);

    Player player;
    player.init();
    Food food;
    food.init();

	while (!rl::windowShouldClose())
	{

        if (rl::isKeyDown(rl::KEY_RIGHT))
        {
            player.dir.x = 1;
            player.dir.y = 0;
        }
		else if (rl::isKeyDown(rl::KEY_LEFT))
        {
            player.dir.x = -1;
            player.dir.y = 0;
        } else if (rl::isKeyDown(rl::KEY_UP))
        {
            player.dir.x = 0;
            player.dir.y = -1;
        }
		else if (rl::isKeyDown(rl::KEY_DOWN))
        {
            player.dir.x = 0;
            player.dir.y = 1;
        }

        for (int i = (int)player.tail.len()-1 ; i >= 1; i--) {
            player.tail[i].x = player.tail[(usz)i-1].x;
            player.tail[i].y = player.tail[(usz)i-1].y;
        }
        player.tail[0].x = player.pos.x;
        player.tail[0].y = player.pos.y;

        player.pos += player.dir;
        if (player.pos.x < 0) player.pos.x = GRID_SIZE-1;
        if (player.pos.x >= GRID_SIZE) player.pos.x = 0;
        if (player.pos.y < 0) player.pos.y = GRID_SIZE-1;
        if (player.pos.y >= GRID_SIZE) player.pos.y = 0;

        if (player.pos.x == food.pos.x && player.pos.y == food.pos.y) {
            food.init();
            player.tail.push(int[<2>]{-1, -1});
        }

        for (int i = 0;  i < player.tail.len(); i++) {
            if (player.pos.x == player.tail[i].x && player.pos.y == player.tail[i].y) {
                player.init();
            }
        }

		rl::@drawing() {
			rl::clearBackground(rl::RAYWHITE);
            rl::drawRectangle(player.pos.x*GS, player.pos.y*GS, GS, GS, rl::GREEN);

            for (int i = 0 ; i < player.tail.len(); i++) {
                rl::drawRectangle(player.tail[i].x*GS, player.tail[i].y*GS, GS, GS, rl::GREEN);
            }

            rl::drawRectangle(food.pos.x*GS, food.pos.y*GS, GS, GS, rl::RED);
		};
	}

	rl::closeWindow();
	return 0;
}