import std.algorithm;
import std.conv;
import std.format;
import std.stdio;
import core.runtime;

void main()
{
	if (Runtime.args.length != 3)
	{
		writeln("incorrect arguments");
		return;
	}

	File file = File(Runtime.args[2], "r");
	int pos1 = readStart(&file);
	int pos2 = readStart(&file);
	writeln(format("%d, %d", pos1, pos2));

	auto res = playGame(pos1, pos2, (int rolls) => rolls % 100 + 1);
	writeln(res);
	writeln(min(res.money1, res.money2) * res.rolls);
}

int readStart(File* file)
{
	string line = file.readln();
	return line[28..line.length-1].to!int;
}

struct GameResult {
	int money1;
	int money2;
	int rolls;
}

GameResult playGame (int pos1, int pos2, int function(int) @safe dice) @safe
{
	int money1 = 0, money2 = 0;
	int rolls = 0;
	bool turn = false;
	while (money1 < 1000 && money2 < 1000)
	{
		int val = 0;
		val += dice(rolls++);
		val += dice(rolls++);
		val += dice(rolls++);

		writeln(format("%d (%d) : %d (%d) --- %d", money1, pos1, money2, pos2, val));
		if (turn)
		{
			pos2 = ((pos2 + val - 1) % 10) + 1;
			money2 += pos2;
		}
		else
		{
			pos1 = ((pos1 + val - 1) % 10) + 1;
			money1 += pos1;
		}
		turn = !turn;
	}
	writeln(format("%d (%d) : %d (%d)", money1, pos1, money2, pos2));
	return GameResult(money1, money2, rolls);
}
