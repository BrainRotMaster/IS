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

            clips.Reset();

            var fv = GetIOProxyFAV();
            if (fv == null)
                MessageBox.Show("ioproxy не создан!");
            else
                MessageBox.Show("ioproxy готов к работе");

        }


        private void LoadFirstQuestion()
        {
            clips.Reset();
            RunEngine();
        }

        private void RunEngine()
        {
            clips.Run();

            ReadMessages();
            ShowAnswers();
        }

        private void UserAnswer_Click(object sender, EventArgs e)
        {
            string id = ((Button)sender).Tag.ToString();

            clips.Eval($@"
(do-for-fact ((?p ioproxy)) TRUE
    (modify ?p
        (reaction answered)
        (value '{id}')
    )
)");

            // Вывод факта ioproxy для отладки
            var fv = GetIOProxyFAV();
            MessageBox.Show(fv.ToString());

            clips.Run();

            ReadMessages();
            ShowAnswers();
        }




        private FactAddressValue GetIOProxyFAV()
        {
            String evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            var result = (MultifieldValue)clips.Eval(evalStr);

            if (result.Count == 0)
                return null;

            return (FactAddressValue)result[0];
        }


        private void ReadMessages()
        {
            var fv = GetIOProxyFAV();
            if (fv == null) return;

            MultifieldValue messages = (MultifieldValue)fv["messages"];

            for (int i = 0; i < messages.Count; i++)
            {
                LexemeValue msg = (LexemeValue)messages[i];

                byte[] bytes = Encoding.Default.GetBytes(msg.Value);
                string text = Encoding.UTF8.GetString(bytes);

                richTextBox1.AppendText(text + System.Environment.NewLine);
            }

            clips.Eval("(assert (clearmessage))");
        }

        private void ShowAnswers()
        {
            var fv = GetIOProxyFAV();
            if (fv == null) return;

            MultifieldValue answers = (MultifieldValue)fv["answers"];

            panelQuestions.Controls.Clear();

            for (int i = 0; i < answers.Count; i++)
            {
                SymbolValue opt = (SymbolValue)answers[i];
                string id = opt.Value;

                var fact = facts.First(f => f.id == id);

                Button b = new Button
                {
                    Text = fact.desc,
                    Tag = id,
                    AutoSize = true,
                    Margin = new Padding(5)
                };

                b.Click += UserAnswer_Click;
                panelQuestions.Controls.Add(b);
            }
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

            // Шаблоны
            sb.AppendLine("(deftemplate item (slot name))");
            sb.AppendLine("(deftemplate option (slot id) (slot label) (slot group))");
            sb.AppendLine("(deftemplate ioproxy");
            sb.AppendLine("  (slot fact-id)");
            sb.AppendLine("  (multislot answers)");
            sb.AppendLine("  (multislot messages)");
            sb.AppendLine("  (slot reaction)");
            sb.AppendLine("  (slot value)");
            sb.AppendLine("  (slot restore)");
            sb.AppendLine(")");
            sb.AppendLine("(deftemplate asked (slot id))");
            sb.AppendLine();

            // Инициализация ioproxy
            sb.AppendLine("(deffacts proxy-fact");
            sb.AppendLine("  (ioproxy");
            sb.AppendLine("    (fact-id none)");
            sb.AppendLine("    (answers)");
            sb.AppendLine("    (messages)");
            sb.AppendLine("    (reaction none)");
            sb.AppendLine("    (value none)");
            sb.AppendLine("    (restore none))");
            sb.AppendLine(")");
            sb.AppendLine();

            // Вспомогательные правила
            sb.AppendLine("(defrule clear-messages");
            sb.AppendLine("  (declare (salience 100))");
            sb.AppendLine("  ?c <- (clearmessage)");
            sb.AppendLine("  ?p <- (ioproxy)");
            sb.AppendLine("  =>");
            sb.AppendLine("  (modify ?p (messages))");
            sb.AppendLine("  (retract ?c))");
            sb.AppendLine();

            sb.AppendLine("(defrule set-output");
            sb.AppendLine("  (declare (salience 99))");
            sb.AppendLine("  ?m <- (sendmessage ?text)");
            sb.AppendLine("  ?p <- (ioproxy (messages $?msgs))");
            sb.AppendLine("  =>");
            sb.AppendLine("  (modify ?p (messages $?msgs ?text))");
            sb.AppendLine("  (retract ?m))");
            sb.AppendLine();

            // handle-user-answer
            sb.AppendLine("(defrule handle-user-answer");
            sb.AppendLine("  (declare (salience 200))");
            sb.AppendLine("  ?p <- (ioproxy (reaction answered) (value ?id))");
            sb.AppendLine("  =>");
            sb.AppendLine("  (assert (item (name ?id)))");
            sb.AppendLine("  (modify ?p");
            sb.AppendLine("     (reaction none)");
            sb.AppendLine("     (value none)");
            sb.AppendLine("     (answers)))");
            sb.AppendLine();

            // Чтение фактов из файла
            var facts = File.ReadAllLines(factsFile, Encoding.UTF8)
                .Select(l => l.Trim())
                .Where(l => !string.IsNullOrWhiteSpace(l) && !l.StartsWith("//"))
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

            // Опции
            sb.AppendLine("(deffacts options");
            foreach (var f in facts)
                sb.AppendLine($"  (option (id {f.Id}) (label \"{f.Label.Replace("\"", "\\\"")}\") (group {GroupOf(f.Id)}))");
            sb.AppendLine(")");
            sb.AppendLine();

            // Генерация ask-* правил
            var questions = new[]
            {
        ("class", "ask_class"),
        ("kingdom", "ask_kingdom"),
        ("region", "ask_region"),
        ("entity", "ask_entity"),
        ("artifact", "ask_artifact"),
        ("state", "ask_state")
    };

            for (int i = 0; i < questions.Length; i++)
            {
                var (group, askId) = questions[i];
                string prev = i == 0 ? null : questions[i - 1].Item2;

                sb.AppendLine($"(defrule ask-{group}");
                sb.AppendLine("  (declare (salience 50))");
                if (prev != null)
                    sb.AppendLine($"  (asked (id {prev}))");
                sb.AppendLine($"  (not (asked (id {askId})))");
                sb.AppendLine("  ?p <- (ioproxy)");
                sb.AppendLine("  =>");
                sb.AppendLine("  (modify ?p");
                sb.AppendLine($"     (fact-id {askId})");
                sb.AppendLine($"     (answers (find-all-facts ((?o option)) (eq ?o:group {group})))");
                sb.AppendLine("     (reaction none)");
                sb.AppendLine("     (value none)))");
                sb.AppendLine();
            }

            // Правила из rulesFile (production)
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
                sb.AppendLine($"  (assert (sendmessage \"{rhs.First()}: {desc}\"))");
                sb.AppendLine(")");
                sb.AppendLine();
            }

            File.WriteAllText(outputFile, sb.ToString(), Encoding.UTF8);
        }


    }
}
