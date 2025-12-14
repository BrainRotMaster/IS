using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text.RegularExpressions;


class Fact
{
    public string Id;
    public string Desc;
    public Fact(string id, string desc) { Id = id; Desc = desc; }
    public override string ToString() => $"{Id} ({Desc})";
}

class Rule
{
    public string Id;
    public List<string> Antecedents;
    public string Consequent;
    public string Desc;
    public override string ToString() => $"{Id}: {string.Join(",", Antecedents)} => {Consequent} [{Desc}]";
}

class Program
{
    static string factsPath = "facts.txt";
    static string rulesPath = "rules.txt";
    static string axiomsPath = "axioms.txt";
    static string targetPath = "target.txt";

    static Dictionary<string, Fact> AllFacts = new Dictionary<string, Fact>();
    static List<Rule> AllRules = new List<Rule>();
    static HashSet<string> TrueFacts = new HashSet<string>();
    static List<string> ForwardExplanation = new List<string>();
    static List<string> FiredRulesOrder = new List<string>();
    static string target;

    static void Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        ForwardSolution();
        BackwardSolution();
    }
    static void ForwardSolution()
    {
        LoadFacts();
        LoadRules();
        LoadAxioms();
        LoadTarget();

        // Forward chaining
        Console.WriteLine("=== Прямой вывод ===");
        Console.WriteLine(">>> axioms:");
        foreach (var f in TrueFacts) Console.WriteLine($"  {f} - {FactDesc(f)}");
        Console.WriteLine();
        ForwardChainTarget();
        

        Console.WriteLine("\n=== Множество истинных фактов после прямого вывода ===");
        foreach (var f in TrueFacts.OrderBy(x => x))
        {
            Console.WriteLine($"  {f} - {FactDesc(f)}");
        }

        Console.WriteLine("\n=== Примененнные правила ===");
        foreach (var line in ForwardExplanation) Console.WriteLine(line);
    }

    static void BackwardSolution()
    {
        LoadFacts();
        LoadRules();
        LoadAxioms();
        LoadTarget();

        Console.WriteLine("\n=== Обратный вывод ===");
        Console.WriteLine($"\n--- Цель: {target} - {FactDesc(target)} ---");
        Console.WriteLine(">>> axioms:");
        foreach (var f in TrueFacts) Console.WriteLine($"  {f} - {FactDesc(f)}");
        Console.WriteLine();

        FactNode tree = BuildAndOrTree(target);

        Console.WriteLine();
        PrintTree(tree);

        PrintDerivedRuleChain(tree);
    }

    static void LoadFacts()
    {
        AllFacts.Clear();
        if (!File.Exists(factsPath))
        {
            Console.WriteLine($"Нет файла {factsPath}");
            Environment.Exit(1);
        }
        var lines = File.ReadAllLines(factsPath);
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (string.IsNullOrWhiteSpace(line)) continue;
            if (line.StartsWith("//")) continue;
            var parts = line.Split(';');
            if (parts.Length >= 2)
            {
                var id = parts[0].Trim();
                var desc = parts[1].Trim();
                if (!AllFacts.ContainsKey(id)) AllFacts[id] = new Fact(id, desc);
            }
        }
    }

    static void LoadRules()
    {
        AllRules.Clear();
        if (!File.Exists(rulesPath))
        {
            Console.WriteLine($"Нет файла {rulesPath}.");
            Environment.Exit(1);
        }
        var lines = File.ReadAllLines(rulesPath);
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (line.Length == 0) continue;
            if (line.StartsWith("//")) continue;
            // pattern: id;antecedents;consequent;description;
            var parts = line.Split(';');
            if (parts.Length >= 4)
            {
                var id = parts[0].Trim();
                var antecedents = parts[1].Trim();
                var consequent = parts[2].Trim();
                var desc = parts[3].Trim();
                List<string> ants = new List<string>();
                if (!string.IsNullOrWhiteSpace(antecedents))
                {
                    ants = antecedents.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).Where(s => s.Length > 0).ToList();
                }
                var r = new Rule() { Id = id, Antecedents = ants, Consequent = consequent, Desc = desc };
                AllRules.Add(r);
                // Register consequent fact if missing
                if (!AllFacts.ContainsKey(consequent)) AllFacts[consequent] = new Fact(consequent, "(auto-generated fact)");
            }
        }
    }

    static void LoadAxioms()
    {
        TrueFacts.Clear();
        if (!File.Exists(axiomsPath))
        {
            Console.WriteLine($"Нет файла {axiomsPath}.");
            Environment.Exit(1);
        }
        var lines = File.ReadAllLines(axiomsPath);
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (line.Length == 0) continue;
            if (line.StartsWith("//")) continue;
            // each line is an id
            var id = line;
            // clean trailing semicolon if present
            if (id.EndsWith(";")) id = id.Substring(0, id.Length - 1);
            id = id.Trim();
            if (id.Length == 0) continue;
            if (!AllFacts.ContainsKey(id))
            {
                // create placeholder fact
                AllFacts[id] = new Fact(id, "(axiom - description missing)");
            }
            TrueFacts.Add(id);
        }
    }

    static void LoadTarget()
    {
        string tgt = "";
        if (!File.Exists(targetPath))
        {
            Console.WriteLine($"Нет файла {targetPath}.");
            Environment.Exit(1);
        }
        var lines = File.ReadAllLines(targetPath);
        foreach (var raw in lines)
        {
            var line = raw.Trim();
            if (line.Length == 0) continue;
            if (line.StartsWith("//")) continue;
            var id = line;
            if (id.EndsWith(";")) id = id.Substring(0, id.Length - 1);
            id = id.Trim();
            if (id.Length == 0) continue;
            tgt = id;
        }
        target = tgt;
    }

    static string FactDesc(string id)
    {
        if (AllFacts.TryGetValue(id, out var f)) return f.Desc;
        return "(описание отсутствует)";
    }

    static void ForwardChainTarget()
    {
        ForwardExplanation.Clear();
        FiredRulesOrder.Clear();
        bool addedAny = true;
        bool targetNotProved = true;
        int iteration = 0;
        var firedRules = new HashSet<string>();
        int provedFacts = 0;
        while (addedAny && targetNotProved)
        {
            iteration++;
            addedAny = false;
            // пробуем все правила которые еще не сработали
            foreach (var r in AllRules)
            {
                if (firedRules.Contains(r.Id)) continue;
                bool allAntsTrue = true;
                foreach (var ant in r.Antecedents)
                {
                    if (!TrueFacts.Contains(ant)) { allAntsTrue = false; break; }
                }
                if (allAntsTrue)
                {
                    // правило сработало
                    firedRules.Add(r.Id);
                    FiredRulesOrder.Add(r.Id);//
                    var addedConsequent = false;
                    if (!TrueFacts.Contains(r.Consequent))
                    {
                        TrueFacts.Add(r.Consequent);
                        addedConsequent = true;
                        addedAny = true;
                        provedFacts++;
                    }

                    string line = $"{provedFacts}. {r.Id} ({string.Join(", ", r.Antecedents)}) => {r.Consequent}         {r.Desc}";
                    ForwardExplanation.Add(line);

                    if (TrueFacts.Contains(target))
                    {
                        targetNotProved = false;
                        break;
                    }
                }
            }
            if (iteration > 1000)
            {
                ForwardExplanation.Add("Прерывание: слишком много итераций.");
                break;
            }
        }
        Console.WriteLine($"Proved facts: {provedFacts}, used rules: {ForwardExplanation.Count}");
    }


    // BACKWARD CHAINING
    // Тип узла AND/OR-дерева
    public abstract class Node
    {
        public string Name;
        public List<Node> Children = new List<Node>();
    }

    public class FactNode : Node           // OR-узел
    {
        public bool IsProved;
        public bool IsCycle;
        public bool Expanded;
    }

    public class RuleNode : Node           // AND-узел
    {
        public Rule Rule;
    }

    static FactNode BuildAndOrTree(string goal)
    {
        // Индекс: факт -> правила, выводящие факт
        var rulesByConsequent = AllRules
            .GroupBy(r => r.Consequent)
            .ToDictionary(g => g.Key, g => g.ToList());

        Dictionary<string, FactNode> factNodes = new Dictionary<string, FactNode>();

        // стек (fact, путь фактов)
        Stack<(string fact, List<string> path)> work = new Stack<(string fact, List<string> path)>();
        work.Push((goal, new List<string>()));

        while (work.Count > 0)
        {
            var (fact, path) = work.Pop();

            // Если факт уже создан – продолжаем заполнение
            FactNode fNode;
            if (!factNodes.ContainsKey(fact))
            {
                fNode = new FactNode { Name = fact };
                factNodes[fact] = fNode;
            }
            else
            {
                fNode = factNodes[fact];

                // полная защита от OR-взрыва
                if (fNode.Expanded)
                    continue;
            }

            fNode.Expanded = true;

            // Цикл
            if (path.Contains(fact))
            {
                fNode.IsCycle = true;
                continue;
            }

            // Аксиома
            if (TrueFacts.Contains(fact))
            {
                fNode.IsProved = true;
                continue;
            }

            // Нет продукций – факт НЕ доказан
            if (!rulesByConsequent.ContainsKey(fact))
            {
                fNode.IsProved = false;
                continue;
            }

            // OR-ветки — все правила для вывода факта
            foreach (var r in rulesByConsequent[fact])
            {
                RuleNode rNode = new RuleNode
                {
                    Name = r.Id,
                    Rule = r
                };
                fNode.Children.Add(rNode);

                var newPath = new List<string>(path) { fact };

                // AND-ветки
                foreach (var ant in r.Antecedents)
                {
                    FactNode antNode;

                    if (!factNodes.ContainsKey(ant))
                    {
                        antNode = new FactNode { Name = ant };
                        factNodes[ant] = antNode;
                        work.Push((ant, newPath));
                    }
                    else
                    {
                        antNode = factNodes[ant];
                    }

                    rNode.Children.Add(antNode);
                }
            }
        }

        return factNodes[goal];
    }

    static void PrintTree(Node node, string indent = "", bool last = true)
    {
        Console.Write(indent);
        Console.Write(last ? "└─" : "├─");

        if (node is FactNode f)
        {
            if (f.IsCycle) Console.WriteLine($"[FACT {f.Name}] (CYCLE)");
            else if (f.IsProved) Console.WriteLine($"[FACT {f.Name}] (TRUE)");
            else Console.WriteLine($"[FACT {f.Name}]");
        }
        else if (node is RuleNode r)
        {
            Console.WriteLine($"[RULE {r.Name}: {string.Join(",", r.Rule.Antecedents)} => {r.Rule.Consequent}]");
        }

        indent += last ? "  " : "│ ";

        for (int i = 0; i < node.Children.Count; i++)
            PrintTree(node.Children[i], indent, i == node.Children.Count - 1);
    }

    static void PrintDerivedRuleChain(FactNode root)
    {
        var chain = new List<Rule>();
        var visitedFacts = new HashSet<string>();
        var visitedRules = new HashSet<string>();

        if (!CollectCleanChain(root, chain, visitedFacts, visitedRules))
        {
            Console.WriteLine("Цель не может быть выведена.");
            return;
        }

        //chain.Reverse(); // прямой порядок
        var Schain = chain;
        //var Schain = chain
        //.OrderBy(r => int.Parse(r.Id.Substring(1)))
        //.ToList();

        for (int i = 0; i < Schain.Count; i++)
        {
            var r = Schain[i];
            Console.WriteLine($"{i + 1}. {r.Id}: ({string.Join(", ", r.Antecedents)}) => {r.Consequent}            {r.Desc}");
        }
    }

    static bool CollectCleanChain(Node node, List<Rule> chain, HashSet<string> visitedFacts, HashSet<string> visitedRules)
    {
        //FACT node
        if (node is FactNode f)
        {
            if (f.IsCycle) return false;

            if (f.IsProved && f.Children.Count == 0)
                return true;

            if (visitedFacts.Contains(f.Name))
                return true;

            visitedFacts.Add(f.Name);

            // OR: ищем первую успешную ветку
            foreach (var ch in f.Children)
            {
                if (CollectCleanChain(ch, chain, visitedFacts, visitedRules))
                    return true;
            }

            return false;
        }

        //RULE node
        else if (node is RuleNode r)
        {
            // если правило уже было использовано
            bool alreadyUsed = visitedRules.Contains(r.Name);

            // Сначала ВСЕ посылки
            foreach (var ant in r.Children)
            {
                if (!CollectCleanChain(ant, chain, visitedFacts, visitedRules))
                    return false;
            }

            // само правило
            if (!alreadyUsed)
            {
                visitedRules.Add(r.Name);
                chain.Add(r.Rule);  
            }

            return true;
        }

        return false;
    }


}
