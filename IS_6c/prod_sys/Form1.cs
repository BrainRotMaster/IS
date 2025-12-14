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

namespace prod_sys
{

    public partial class Form1 : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();

        private List<Fact> facts;
        private HashSet<Fact> destinationFacts; // целевые факты
        private HashSet<String> destinationApprovedFacts; // выведенные целевые

        private FlowLayoutPanel panelQuestions;
        private RichTextBox richTextBox1;
        private Button buttonForward;
        private Button buttonRun;

        private bool targetReached = false;

        public class Fact
        {
            public string id;
            public string desc;

            public Fact(string str)
            {
                var res = str.Split(';').Select(s => s.Trim()).ToList();
                id = res[0];
                desc = res[1];
            }
        }

        public Form1()
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
            destinationFacts = new HashSet<Fact>();
            foreach (var f in facts)
            {
                var num = int.Parse(f.id.Substring(f.id.IndexOf('f') + 1));
                if (num >= 300)
                    destinationFacts.Add(f);
            }
            destinationApprovedFacts = new HashSet<String>();

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

            // Ассерт выбранного факта
            clips.Eval($"(assert (item (name {id})))");
            richTextBox1.Text += $"Выбран факт: {id}\n";

            // Запускаем inference engine
            clips.Run();
            HandleResponse();

            // Переходим к следующему вопросу
            string nextGroup = NextGroup(id);
            if (nextGroup != null)
            {
                ShowQuestion(nextGroup, $"Выберите {nextGroup}:");
            }
            else
            {
                panelQuestions.Controls.Clear();
                richTextBox1.Text += "\nВопросы завершены.\n";
                if (destinationApprovedFacts.Count > 0)
                {
                    richTextBox1.Text += "Достижимые финальные квесты: \n";

                    foreach (var f in destinationApprovedFacts)
                    {
                        richTextBox1.Text += f + "\n";
                    }
                }
                else
                {
                    richTextBox1.Text += "Из данной конфигурации не выйти на финальный квест( \n";
                }
            }
        }

        private string NextGroup(string lastId)
        {
            // возвращает следующую группу по логике GroupOf
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

        private string GroupOf(string id)
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

        private bool NewRecognPhrases(List<FactInstance> phrases)
        {
            string CropName(FactInstance f)
            {
                var val = f.GetSlotValues()[0];
                return val.ToString().Trim(new char[] { '(', ')', '"' });
            }

            var phrase = CropName(phrases[0]).Split(':');
            richTextBox1.Text += $"Выведен факт  {phrase[0]}: {phrase[1]} \n";
            clips.Eval("(assert (clearmessage))");

            bool reached = destinationFacts.Any(f => f.id == phrase[0]);
            if(reached) destinationApprovedFacts.Add($"{phrase[0]}: {phrase[1].Split('>')[1]}");
            return reached;           
        }

        private void HandleResponse()
        {
            var fs = clips.GetFactList();
            var readyFacts = fs.Where(f => f.RelationName == "sendmessagehalt").ToList();
            bool goal = false;

            if (readyFacts.Count > 0)
            {
                goal = NewRecognPhrases(readyFacts);
                clips.Eval("(assert (clear-message))");
                clips.Run();
            }

            if (goal)
            {
                targetReached = true;
                //richTextBox1.Text += "\nЦелевой факт выведен\n\n";
            }

            if (readyFacts.Count > 0)
                HandleResponse();
        }

        private void buttonForward_Click(object sender, EventArgs e)
        {
            // Сброс и первый вопрос
            clips.Clear();
            targetReached = false;
            destinationFacts.Clear();
            destinationApprovedFacts.Clear();
            richTextBox1.Clear();
            InitClips();
            InitFacts();
            LoadFirstQuestion();
            richTextBox1.Clear();
        }

        private void GenerateClipsRules(string factsFile, string rulesFile, string outputFile)
        {
            var sb = new StringBuilder();

            // =====================================================
            // ШАБЛОНЫ
            // =====================================================

            sb.AppendLine("(deftemplate item (slot name))");
            sb.AppendLine("(deftemplate option (slot id) (slot label) (slot group))");
            sb.AppendLine("(deftemplate ioproxy (slot id) (slot text) (multislot options))");
            sb.AppendLine("(deftemplate answer (slot id) (slot value))");
            sb.AppendLine("(deftemplate asked (slot id))");
            sb.AppendLine();

            // =====================================================
            // СЛУЖЕБНЫЕ ПРАВИЛА СИНХРОНИЗАЦИИ
            // =====================================================

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

            // =====================================================
            // ЧТЕНИЕ ФАКТОВ
            // =====================================================

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

            // =====================================================
            // ОПЦИИ (НЕ item!)
            // =====================================================

            sb.AppendLine("(deffacts options");
            foreach (var f in facts)
                sb.AppendLine($"  (option (id {f.Id}) (label \"{f.Label.Replace("\"", "\\\"")}\") (group {GroupOf(f.Id)}))");
            sb.AppendLine(")");
            sb.AppendLine();

            // =====================================================
            // ВОПРОСЫ (СТРОГО ПО ПОРЯДКУ)
            // =====================================================

            var questions = new[]
            {
        ("class",    "ask_class",    "Выберите класс:"),
        ("kingdom",  "ask_kingdom",  "Выберите королевство:"),
        ("region",   "ask_region",   "Выберите регион:"),
        ("entity",   "ask_entity",   "Выберите сущность:"),
        ("artifact", "ask_artifact", "Выберите артефакт:"),
        ("state",    "ask_state",    "Выберите событие:")
    };

            for (int i = 0; i < questions.Length; i++)
            {
                var (group, askId, text) = questions[i];
                string prev = i == 0 ? null : questions[i - 1].Item2;

                // ---------- вопрос ----------
                sb.AppendLine($"(defrule ask-{group}");
                sb.AppendLine("  (declare (salience 50))");
                if (prev != null)
                    sb.AppendLine($"  (asked (id {prev}))");
                sb.AppendLine($"  (not (asked (id {askId})))");
                sb.AppendLine("  =>");
                sb.Append($"  (assert (ioproxy (id {askId}) (text \"{text}\") (options");
                sb.Append($" (find-all-facts ((?o option)) (eq ?o:group {group}))");
                sb.AppendLine(")))");
                sb.AppendLine(")");
                sb.AppendLine();

                // ---------- ответ ----------
                sb.AppendLine($"(defrule handle-{group}");
                sb.AppendLine($"  ?a <- (answer (id {askId}) (value ?v))");
                sb.AppendLine($"  ?p <- (ioproxy (id {askId}))");
                sb.AppendLine("  =>");
                sb.AppendLine("  (retract ?a)");
                sb.AppendLine("  (retract ?p)");
                sb.AppendLine("  (assert (item (name ?v)))");
                sb.AppendLine($"  (assert (asked (id {askId})))");
                sb.AppendLine(")");
                sb.AppendLine();
            }

            // =====================================================
            // ПРОДУКЦИОННЫЕ ПРАВИЛА
            // =====================================================

            foreach (var line in File.ReadLines(rulesFile, Encoding.UTF8))
            {
                if (string.IsNullOrWhiteSpace(line) || line.StartsWith("//")) continue;

                var p = line.Split(';').Select(x => x.Trim()).ToArray();
                if (p.Length < 4) continue;

                var id = p[0];
                var lhs = p[1].Split(',').Select(x => x.Trim());
                var rhs = p[2].Split(',').Select(x => x.Trim());
                var desc = p[3].Replace("\"", "\\\"");

                sb.AppendLine($"(defrule {id}");
                sb.AppendLine("  (declare (salience 10))");
                foreach (var l in lhs)
                    sb.AppendLine($"  (item (name {l}))");
                sb.AppendLine("  =>");
                foreach (var r in rhs)
                    sb.AppendLine($"  (assert (item (name {r})))");
                sb.AppendLine($"  (assert (sendmessagehalt \"{rhs.First()}: {desc}\"))");
                sb.AppendLine("  (halt)");
                sb.AppendLine(")");
                sb.AppendLine();
            }

            File.WriteAllText(outputFile, sb.ToString(), Encoding.UTF8);
        }

    }
}