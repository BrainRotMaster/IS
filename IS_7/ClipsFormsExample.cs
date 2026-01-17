using CLIPSNET;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml.Linq;


namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();

        private List<Fact> facts;

        private FlowLayoutPanel panelQuestions;
        private RichTextBox richTextBox1;
        private Button buttonForward;
        private Button buttonRun;

        public class Fact
        {
            public string id;
            public string desc;
            public double conf;

            public Fact(string str)
            {
                var res = str.Split(';').Select(s => s.Trim()).ToList();
                id = res[0];
                desc = res[1];
                conf = double.Parse(res[2], CultureInfo.InvariantCulture);
            }
        }

        public ClipsFormsExample()
        {
            InitializeComponent();
            InitFacts();
            InitClips();
            LoadFirstQuestion();
        }

        private void InitFacts()
        {
            facts = new List<Fact>();
            foreach (var line in File.ReadAllLines("facts.txt"))
            {
                if (string.IsNullOrWhiteSpace(line) || line.StartsWith("//")) continue;
                facts.Add(new Fact(line));
            }
        }

        private void InitClips()
        {
            clips.Clear();
            clips.Reset();
            GenerateClipsRules("facts.txt", "rules.txt", "generated_rules.clp");
            string clp = File.ReadAllText("generated_rules.clp");
            clips.LoadFromString(clp);
        }

        private void LoadFirstQuestion()
        {
            panelQuestions.Controls.Clear();

            ShowQuestion("class", "Выберите класс:");
        }

        private void ShowQuestion(string group, string text)
        {
            panelQuestions.Controls.Clear();

            Label lbl = new Label { Text = text, AutoSize = true };
            panelQuestions.Controls.Add(lbl);

            string GroupOf(string id)
            {
                int n = int.Parse(id.Substring(1));
                if (n <= 5) return "class";
                if (n <= 10) return "kingdom";
                if (n <= 15) return "region";
                if (n <= 20) return "boss";
                if (n <= 25) return "artifact";
                if (n <= 30) return "magic type";
                if (n <= 35) return "building";
                if (n <= 40) return "world state";
                return "other";
            }
            var options = facts.Where(f => GroupOf(f.id) == group).ToList();
            foreach (var f in options)
            {
                Button b = new Button
                {
                    Text = f.desc,
                    Tag = f.id,
                    AutoSize = true,
                    Margin = new Padding(5)
                };
                b.Click += Option_Click;
                panelQuestions.Controls.Add(b);
            }
        }

        private void Option_Click(object sender, EventArgs e)
        {
            Button btn = sender as Button;
            string id = btn.Tag.ToString();

            Fact fact = facts.First(x => x.id == id);
            // Ассерт выбранного факта
            clips.Eval($"(assert (item (name {fact.id}) (conf {fact.conf.ToString(CultureInfo.InvariantCulture)})))");
            richTextBox1.Text += $"Выбран факт {id} : {facts.Where(x => x.id == id).First().desc}\n";

            clips.Run();
            HandleResponse();

            string NextGroup(string lastId)
            {
                // возвращает следующую GroupOf
                int n = int.Parse(lastId.Substring(1));
                if (n <= 5) return "kingdom";
                if (n <= 10) return "region";
                if (n <= 15) return "boss";
                if (n <= 20) return "artifact";
                if (n <= 25) return "magic type";
                if (n <= 30) return "building";
                if (n <= 35) return "world state";
                return null;
            }
            string nextGroup = NextGroup(id);
            if (nextGroup != null)
            {
                ShowQuestion(nextGroup, $"Выберите {nextGroup}:");
            }
            else
            {
                PrintResults();
            }
        }
        private void PrintResults()
        {
            panelQuestions.Controls.Clear();
            richTextBox1.Text += "\nВопросы завершены.\n";

            var allFacts = clips.GetFactList();
            var finalFacts = allFacts.Where(f => f.RelationName == "item")
                .Select(f =>
                {
                    var name = GetFactName(f);
                    var conf = GetFactConf(f);
                    return new { Name = name, Conf = conf };
                })
                .Where(f => int.Parse(f.Name.Substring(1)) >= 300)
                .OrderByDescending(f => f.Conf)
                .ToList();
            if (finalFacts.Count > 0)
            {
                richTextBox1.Text += "\nНаиболее вероятные финальные квесты:\n";
                foreach (var f in finalFacts)
                {
                    richTextBox1.Text += $"{f.Name}: {facts.Where(x => x.id == f.Name).First().desc} ({f.Conf:0.00})\n";
                }
            }
            else
            {
                richTextBox1.Text += "Из данной конфигурации не выйти на финальный квест( \n";
            }
        }


        string GetFactName(FactInstance f)
        {
            var val = f.GetSlotValues()[0];
            return val.ToString().Trim(new char[] { '(', ')', '"' });
        }
        String GetFactConf(FactInstance f)
        {
            var val = f.GetSlotValues()[1];
            var str = val.ToString().Trim(new char[] { '(', ')', '"' });
            var d = double.Parse(str, CultureInfo.InvariantCulture);
            return d.ToString("0.00");
        }

        private void HandleResponse()
        {
            var readyFacts = clips.GetFactList().Where(f => f.RelationName == "sendmessagehalt").ToList();

            if (readyFacts.Count > 0)
            {
                var phrase = GetFactName(readyFacts[0]).Split(':');
                var fs = clips.GetFactList();//
                var fact_conf = fs.Where(f => f.RelationName == "item").ToList().Where(f => GetFactName(f).Equals(phrase[0])).First();//
                richTextBox1.Text += $"Выведен факт  {phrase[0]}: {phrase[1]}  ({GetFactConf(fact_conf)})\n";//
                clips.Eval("(assert (clearmessage))");
                clips.Eval("(assert (clear-message))");
                clips.Run();

                HandleResponse();
            }
        }

        private void btnRestart_Click(object sender, EventArgs e)
        {
            // Сброс и первый вопрос
            clips.Clear();
            richTextBox1.Clear();
            InitClips();
            InitFacts();
            LoadFirstQuestion();
        }

        private void GenerateClipsRules(string factsFile, string rulesFile, string outputFile)
        {
            var sb = new StringBuilder();

            //шаблоны
            sb.AppendLine("(deftemplate item (slot name) (slot conf (type FLOAT) (default 0.0)))");//
            sb.AppendLine("(deftemplate option (slot id) (slot label) (slot group))");
            sb.AppendLine("(deftemplate ioproxy (slot id) (slot text) (multislot options))");
            sb.AppendLine("(deftemplate answer (slot id) (slot value))");
            sb.AppendLine("(deftemplate asked (slot id))");
            sb.AppendLine();

            //вспомогательные
            sb.AppendLine("(defrule clear-message");
            sb.AppendLine("  (declare (salience 100))");
            sb.AppendLine("  ?c <- (clearmessage)");
            sb.AppendLine("  ?m <- (sendmessagehalt ?)");
            sb.AppendLine("  =>");
            sb.AppendLine("  (retract ?c)");
            sb.AppendLine("  (retract ?m)");
            sb.AppendLine(")");
            sb.AppendLine();

            sb.AppendLine("(defrule clear-ioproxy");
            sb.AppendLine("  (declare (salience 100))");
            sb.AppendLine("  ?c <- (clearquestion)");
            sb.AppendLine("  ?p <- (ioproxy)");
            sb.AppendLine("  =>");
            sb.AppendLine("  (retract ?c)");
            sb.AppendLine("  (retract ?p)");
            sb.AppendLine(")");
            sb.AppendLine();

            sb.AppendLine("(defrule combine");
            sb.AppendLine("  (declare (salience 60))");
            sb.AppendLine("  ?i1 <- (item (name ?f1) (conf ?conf1))");
            sb.AppendLine("  ?i2 <- (item (name ?f2) (conf ?conf2))");
            sb.AppendLine("  =>");
            sb.AppendLine("  (if (and (eq ?f1 ?f2) (!= ?conf1 ?conf2)) then");
            sb.AppendLine("    (assert (item (name ?f1) (conf (- (+ ?conf1 ?conf2) (* ?conf1 ?conf2)))) )");
            sb.AppendLine("    (retract ?i1)");
            sb.AppendLine("    (retract ?i2)");      
            sb.AppendLine("    (assert (sendmessagehalt (sym-cat ?f1 \": ===Коэффициент уверенности пересчитан===\")))");
            sb.AppendLine("    (halt))");
            sb.AppendLine(")");
            sb.AppendLine();

            //facts
            var facts = File.ReadAllLines(factsFile, Encoding.UTF8)
                .Select(l => l.Trim())
                .Where(l => l.Length > 0 && !l.StartsWith("//"))
                .Select(l => l.Split(';'))
                .Where(p => p.Length >= 2)
                .Select(p => new { Id = p[0].Trim(), Label = p[1].Trim() })
                .ToList();

            string GroupOf(string id)
            {
                int n = int.Parse(id.Substring(1));
                if (n <= 5) return "class";
                if (n <= 10) return "kingdom";
                if (n <= 15) return "region";
                if (n <= 20) return "entity";
                if (n <= 25) return "artifact";
                if (n <= 40) return "state";
                return "other";
            }

            //options
            sb.AppendLine("(deffacts options");
            foreach (var f in facts)
                sb.AppendLine($"  (option (id {f.Id}) (label \"{f.Label.Replace("\"", "\\\"")}\") (group {GroupOf(f.Id)}))");
            sb.AppendLine(")");
            sb.AppendLine();

            //продукции
            foreach (var line in File.ReadLines(rulesFile, Encoding.UTF8))
            {
                if (string.IsNullOrWhiteSpace(line) || line.StartsWith("//")) continue;

                var p = line.Split(';').Select(x => x.Trim()).ToArray();
                if (p.Length < 4) continue;

                var id = p[0];
                var lhs = p[1].Split(',').Select(x => x.Trim());
                var rhs = p[2].Split(',').Select(x => x.Trim());
                var desc = p[3].Replace("\"", "\\\"");
                string conf = p[4];//

                sb.AppendLine($"(defrule {id}");
                sb.AppendLine("  (declare (salience 10))");
                int i = 0;
                foreach (var l in lhs)
                {
                    sb.AppendLine($"  (item (name {l}) (conf ?c{i}))");//
                    i++;
                }
                sb.AppendLine("  =>");
                string minn = "(min " + string.Join(" ", Enumerable.Range(0, i).Select(j => $"?c{j}")) + ")";//
                foreach (var r in rhs)
                {
                    sb.AppendLine($"  (assert (item (name {r}) (conf (* {conf} {minn}))))");//
                }
                sb.AppendLine($"  (assert (sendmessagehalt \"{rhs.First()}: {desc}\"))");
                sb.AppendLine("  (halt)");
                sb.AppendLine(")");
                sb.AppendLine();
            }

            File.WriteAllText(outputFile, sb.ToString(), Encoding.UTF8);
        }

    }
}
