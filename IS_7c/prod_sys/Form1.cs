using CLIPSNET;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace prod_sys
{

    public partial class Form1 : Form
    {
        public class Fact
        {
            public string id;
            public string desc;
            //public double conf;

            public Fact(string str)
            {
                var res = str.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList();
                id = res[0];
                desc = res[1];
                //conf = double.Parse(res[2], CultureInfo.InvariantCulture);
            }

            public bool Equals(Fact b)
            {
                return id.Equals(b.id);
            }

            public override bool Equals(object obj)
            {
                return obj is Fact && Equals((Fact)obj);
            }

            public override int GetHashCode()
            {
                return id.GetHashCode();
            }
        }
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();

        List<Fact> facts;
        List<Rule> rules;
        bool targetReached = false;

        HashSet<Fact> leftCheckedFacts;
        HashSet<Fact> rightCheckedFacts;

        public void InitFacts()
        {
            facts = new List<Fact>();

            using (var reader = new StreamReader("facts.txt"))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    if (line.Contains("//") || line.Length == 0)
                        continue;
                    facts.Add(new Fact(line));
                }
            }
            //facts.Sort((x, y) => x.desc.CompareTo(y.desc));
        }

        //public void InitRules()
        //{
        //    rules = new List<Rule>();

        //    using (var reader = new StreamReader("../../rules.txt"))
        //    {
        //        string line;
        //        while ((line = reader.ReadLine()) != null)
        //            if (line != "")
        //                rules.Add(new Rule(line, facts));
        //    }
        //}

        public void LoadCheckBox()
        {
            foreach (var f in facts)
            {
                var num = int.Parse(f.id.Substring(f.id.IndexOf('f') + 1));
                if (num < 300)
                    checkedListBox1.Items.Add(f.id + " " + f.desc);
                else
                    checkedListBox2.Items.Add(f.id + " " + f.desc);

            }
        }

        public void InitClips()
        {
            GenerateClipsRules("rules.txt", "generated_rules.clp");
            string clp = System.IO.File.ReadAllText("generated_rules.clp");
            clips.LoadFromString(clp);
        }

        public Form1()
        {
            InitializeComponent();
            InitFacts();
            LoadCheckBox();
            InitClips();

            button2.Enabled = false;
            leftCheckedFacts = new HashSet<Fact>();
            rightCheckedFacts = new HashSet<Fact>();
        }

        private bool NewRecognPhrases(List<FactInstance> phrases)
        {
            String CropName(FactInstance f)
            {
                var val = f.GetSlotValues()[0];
                return val.ToString().Trim(new char[] { '(', ')', '"' });
            }
            //String CropConf(FactInstance f)
            //{
            //    var val = f.GetSlotValues()[1];
            //    var str = val.ToString().Trim(new char[] { '(', ')', '"' });
            //    var d = double.Parse(str, CultureInfo.InvariantCulture);
            //    return d.ToString("0.00");
            //}

            var phrase = CropName(phrases[0]).Split(':');
            var fs = clips.GetFactList();
            //var fact_conf = fs.Where(f => f.RelationName == "item").ToList().Where(f => CropName(f).Equals(phrase[0])).First();
            //richTextBox1.Text += $"Выведен факт  {phrase[0]}: {phrase[1]}  ({CropConf(fact_conf)})\n";
            richTextBox1.Text += $"Выведен факт  {phrase[0]}: {phrase[1]} \n";
            clips.Eval("(assert (clearmessage))");
            return rightCheckedFacts.Where(f => f.id == phrase[0]).Count() == 1;
        }

        private void HandleResponse()
        {
            clips.Run();
            var fs = clips.GetFactList();
            var readyFacts = fs.Where(f => f.RelationName == "sendmessagehalt").ToList();
            bool goal= false;

            if (readyFacts.Count > 0)
                goal = NewRecognPhrases(readyFacts);
            else button2.Enabled = false;
            
            clips.Eval("(assert (clear-message))");

            if (goal)
            {
                targetReached = true;
                richTextBox1.Text += "\nЦелевой факт выведен\n\n";
            }

            if (readyFacts.Count > 0)
                HandleResponse();
            else if (!targetReached)
                richTextBox1.Text += "\nЦелевой факт не выведен\n\n";
        }

        private void Forward()
        {
            clips.Clear();
            InitClips();

            foreach (var f in leftCheckedFacts)
            {
                //string factVal = $"item (name {f.id}) (conf {f.conf.ToString(CultureInfo.InvariantCulture)})";
                string factVal = $"item (name {f.id})";
                clips.Eval($"(assert ({factVal}) )");
                richTextBox1.Text += "Добавлен факт " + f.desc + "\n";
            }

            button2.Enabled = true;
        }

        private void checkedListBox1_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            if (e.NewValue == CheckState.Checked && !leftCheckedFacts.Contains(facts[e.Index]))
                leftCheckedFacts.Add(facts[e.Index]);
            else if (e.NewValue == CheckState.Unchecked)
                leftCheckedFacts.Remove(facts[e.Index]);
        }


        private void checkedListBox2_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            if (e.NewValue == CheckState.Checked && !rightCheckedFacts.Contains(facts[e.Index]))
                rightCheckedFacts.Add(facts[e.Index]);
            else if (e.NewValue == CheckState.Unchecked)
                rightCheckedFacts.Remove(facts[e.Index]);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            richTextBox1.Clear();
            targetReached = false;
            if (leftCheckedFacts.Count > 0 && rightCheckedFacts.Count == 1)
                Forward();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            HandleResponse();
            button2.Enabled = false;
        }

        private void checkedListBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            HashSet<string> items = new HashSet<string>{ };
            if (e.KeyChar == (char)Keys.Enter)
                for (int i = 0; i < checkedListBox1.Items.Count; i++)
                    if (items.Any(id => checkedListBox1.GetItemText(checkedListBox1.Items[i]).Contains(id)))
                        checkedListBox1.SetItemChecked(i, true);
        }

        private void GenerateClipsRules(string rulesFile, string outputFile)
        {
            var sb = new StringBuilder();

            // ===========================================
            // Базовые правила и шаблоны
            // ===========================================
            sb.AppendLine("(defrule clear-message");
            sb.AppendLine("  (declare (salience 90))");
            sb.AppendLine("  ?clear-msg-flg <- (clearmessage)");
            sb.AppendLine("  ?sendmessage <- (sendmessagehalt ?msg)");
            sb.AppendLine("  =>");
            sb.AppendLine("  (retract ?clear-msg-flg)");
            sb.AppendLine("  (retract ?sendmessage)");
            sb.AppendLine(")");
            sb.AppendLine();

            sb.AppendLine("(deftemplate item");
            sb.AppendLine("  (slot name (default none))");
            //sb.AppendLine("  (slot conf (type FLOAT) (default 0.0))");
            sb.AppendLine(")");
            sb.AppendLine();

            //sb.AppendLine("(defrule combine");
            //sb.AppendLine("  (declare (salience 60))");
            //sb.AppendLine("  ?i1 <- (item (name ?f1) (conf ?conf1))");
            //sb.AppendLine("  ?i2 <- (item (name ?f2) (conf ?conf2))");
            //sb.AppendLine("  =>");
            //sb.AppendLine("  (if (and (eq ?f1 ?f2) (!= ?conf1 ?conf2)) then");
            //sb.AppendLine("    (assert (item (name ?f1) (conf (- (+ ?conf1 ?conf2) (* ?conf1 ?conf2)))) )");
            //sb.AppendLine("    (retract ?i1)");
            //sb.AppendLine("    (retract ?i2)");
            //sb.AppendLine("    (assert (sendmessagehalt (sym-cat ?f1 \": \\n=================================\\nКоэффициент уверенности пересчитан\\n=================================\")))");
            //sb.AppendLine("    (halt))");
            //sb.AppendLine(")");
            //sb.AppendLine();

            // ===========================================
            // Читаем правила из rules.txt
            // ===========================================
            foreach (var line in File.ReadLines(rulesFile, Encoding.UTF8))
            {
                if (string.IsNullOrWhiteSpace(line)) continue;

                var parts = line.Split(';').Select(p => p.Trim()).ToArray();
                if (parts.Length < 5 || parts[0].Contains("//")) continue;

                string iid = parts[0];
                var lhs = new HashSet<string>(parts[1].Split(',').Select(s => s.Trim()));
                var rhs = new HashSet<string>(parts[2].Split(',').Select(s => s.Trim()));
                string desc = parts[3];
                //string conf = parts[4];

                sb.AppendLine($"(defrule {iid}");
                sb.AppendLine("  (declare (salience 50))");

                int i = 0;
                foreach (var item in lhs.OrderBy(x => x))
                {
                    //sb.AppendLine($"  (item (name {item}) (conf ?c{i}))");
                    sb.AppendLine($"  (item (name {item}))");
                    i++;
                }

                sb.AppendLine("  =>");

                string minn = "(min " + string.Join(" ", Enumerable.Range(0, i).Select(j => $"?c{j}")) + ")";
                foreach (var item in rhs.OrderBy(x => x))
                {
                    //sb.AppendLine($"  (assert (item (name {item}) (conf (* {conf} {minn}))))");
                    sb.AppendLine($"  (assert (item (name {item})))");
                }

                // Берём один элемент RHS для sendmessagehalt
                var rhsFirst = rhs.First();
                sb.AppendLine($"  (assert (sendmessagehalt \"{rhsFirst}: {desc}\"))");
                sb.AppendLine("  (halt)");
                sb.AppendLine(")");
                sb.AppendLine();
            }

            // ===========================================
            // Записываем в файл
            // ===========================================
            File.WriteAllText(outputFile, sb.ToString(), Encoding.UTF8);
        }

    }
}
