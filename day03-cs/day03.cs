using System.IO;
using System.Text.RegularExpressions;

String input = File.ReadAllText("./input");

Regex op_match = new Regex(@"(mul\([0-9]{1,3},[0-9]{1,3}\))|(do\(\))|(don't\(\))");
Regex num_match = new Regex(@"[0-9]{1,3}");
MatchCollection ops = op_match.Matches(input);

int result = 0;
int conditional_result = 0;
bool enabled = true;

foreach (Match op in ops) {
    if (op.Value == "do()") {
        enabled = true;
    } else if (op.Value == "don't()") {
        enabled = false;
    } else {
        var m = num_match.Match(op.Value);
        int num_1 = int.Parse(m.Value);
        int num_2 = int.Parse(m.NextMatch().Value);

        result += num_1 * num_2;
        conditional_result += enabled ? num_1 * num_2 : 0;
    }
}

Console.WriteLine(result);
Console.WriteLine(conditional_result);
