using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Speech.Synthesis;
using System.Speech.Recognition;

using CLIPSNET;
using System.IO;


namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();
        /// <summary>
        /// Синтез речи (TTS)
        /// </summary>
        private SpeechSynthesizer synth;

        /// <summary>
        /// Распознавание речи
        /// </summary>
        //private SpeechRecognitionEngine recogn;

        private HashSet<string> shownDiagnoses = new HashSet<string>();

        public ClipsFormsExample()
        {
            InitializeComponent();
            synth = new SpeechSynthesizer();
            synth.SetOutputToDefaultAudioDevice();

            var ruCulture = System.Globalization.CultureInfo.GetCultureInfo("ru-RU");
            var voices = synth.GetInstalledVoices(ruCulture);

            foreach (var v in voices)
                voicesBox.Items.Add(v.VoiceInfo.Name);

            if (voicesBox.Items.Count > 0)
            {
                voicesBox.SelectedIndex = 0;
                synth.SelectVoice(voices[0].VoiceInfo.Name);
            }


            //var recognizerInfo = SpeechRecognitionEngine.InstalledRecognizers()
    //.FirstOrDefault(ri => ri.Culture.Name == "ru-RU");

            //if (recognizerInfo != null)
            //{
                //recogn = new SpeechRecognitionEngine(recognizerInfo);
                //recogn.SpeechRecognized += Recogn_SpeechRecognized;
                //recogn.SetInputToDefaultAudioDevice();
            //}
            //else
            //{
            //    // На машине нет русской языковой модели распознавания
            //    // Можно вывести сообщение или отключить голосовой режим
            //    outputBox.Text += "Русский движок распознавания речи не найден."
            //                      + System.Environment.NewLine;
            //}
        }

        //private void NewRecognPhrases(List<string> phrases)
        //{
        //    if (recogn == null)
        //    {
        //        return;
        //    }

        //    AppendOutput("Стартуем распознавание");
        //    var choices = new Choices();
        //    choices.Add(phrases.ToArray());

        //    var gb = new GrammarBuilder();

        //    var recognizerInfo = SpeechRecognitionEngine.InstalledRecognizers()
        //        .FirstOrDefault(ri => ri.Culture.Name == "ru-RU");
        //    if (recognizerInfo != null)
        //        gb.Culture = recognizerInfo.Culture;

        //    gb.Append(choices);

        //    var gr = new Grammar(gb);
        //    recogn.UnloadAllGrammars();
        //    recogn.LoadGrammar(gr);
        //    recogn.RequestRecognizerUpdate();
        //    recogn.RecognizeAsync(RecognizeMode.Multiple);
        //}

        //private void Recogn_SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        //{
        //    recogn.RecognizeAsyncStop();
        //    recogn.RecognizeAsyncCancel();

        //    string spoken = e.Result.Text.Trim().ToLower();
            
        //    AppendOutput($"Ваш голос распознан: {spoken} (conf={e.Result.Confidence:F2})");
        //    // Маппим русское слово -> внутренний код для CLIPS
        //    string code;
        //    switch (spoken)
        //    {
        //        case "начать":
        //            code = "start";
        //            break;
        //        case "да":
        //            code = "yes";
        //            break;
        //        case "нет":
        //            code = "no";
        //            break;
        //        default:
        //            outputBox.Text += "Распознанное слово не подходит к ожидаемым вариантам."
        //                              + System.Environment.NewLine;
        //            return; // Не шлём ничего в CLIPS
        //    }

        //    clips.Eval($"(assert (answer {code}))");
        //    clips.Eval("(assert (clearmessage))");

        //    AppendOutput("Продолжаю выполнение!");
        //    clips.Run();
        //    HandleResponse();
        //}


        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
        }

        private void HandleResponse()
        {
            //  Вытаскиаваем факт из ЭС
            String evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            FactAddressValue fv = (FactAddressValue)((MultifieldValue)clips.Eval(evalStr))[0];

            MultifieldValue damf = (MultifieldValue)fv["messages"];
            MultifieldValue vamf = (MultifieldValue)fv["answers"];

            outputBox.Text += "Новая итерация : " + System.Environment.NewLine;
            for (int i = 0; i < damf.Count; i++)
            {
                LexemeValue da = (LexemeValue)damf[i];

                // КОСТЫЛЬ: CLIPSNET даёт строку в ANSI-подобной кодировке,
                // перекодируем в UTF-8, чтобы русский не был кракозябрами
                string raw = da.Value;
                byte[] bytes = Encoding.Default.GetBytes(raw);
                string message = Encoding.UTF8.GetString(bytes);

                synth.SpeakAsync(message);

                AppendOutput(message);
            }

            var phrases = new List<string>();
            if (vamf.Count > 0)
            {
                outputBox.Text += "----------------------------------------------------" + System.Environment.NewLine;
                for (int i = 0; i < vamf.Count; i++)
                {
                    LexemeValue va = (LexemeValue)vamf[i];
                    string code = va.Value;          // start / yes / no

                    // Маппинг "внутренний код -> русский текст"
                    string display;
                    switch (code)
                    {
                        case "start": display = "начать"; break;
                        case "yes": display = "да"; break;
                        case "no": display = "нет"; break;
                        default: display = code; break;
                    }

                    phrases.Add(display);

                    AppendOutput("Добавлен вариант для распознавания " + display);
                }
            }


            if (vamf.Count == 0)
                clips.Eval("(assert (clearmessage))");
            //else
                //NewRecognPhrases(phrases);

            var diagMf = (MultifieldValue)clips.Eval("(find-all-facts ((?d diagnosis)) TRUE)");

            for (int i = 0; i < diagMf.Count; i++)
            {
                var dv = (FactAddressValue)diagMf[i];
                var lex = (LexemeValue)dv["text"];

                string raw = lex.Value;

                // та же перекодировка, что и для messages
                byte[] bytes = Encoding.Default.GetBytes(raw);
                string message = Encoding.UTF8.GetString(bytes);

                // показываем каждый диагноз только один раз
                if (shownDiagnoses.Add(message))
                {
                    AppendOutput("");  // пустая строка для красоты
                    AppendOutput("=== Предварительный диагноз ===");
                    AppendOutput(message);
                    AppendOutput("================================");
                }

            }
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            // 1. Берём текущий ioproxy
            string evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            var mf = (MultifieldValue)clips.Eval(evalStr);

            if (mf.Count == 0)
                return;

            var fv = (FactAddressValue)mf[0];
            var answers = (MultifieldValue)fv["answers"];

            // Если сейчас нет вариантов ответа – просто прогоняем правила (вдруг появился диагноз)
            if (answers.Count == 0)
            {
                clips.Run();
                HandleResponse();
                return;
            }

            // --- читаем то, что ввёл пользователь ---
            string userText = (codeBox.Text ?? "").Trim().ToLower();
            string code = null;

            // маппим русский ввод -> внутренний код
            if (!string.IsNullOrEmpty(userText))
            {
                switch (userText)
                {
                    case "начать":
                        code = "start";
                        break;
                    case "да":
                        code = "yes";
                        break;
                    case "нет":
                        code = "no";
                        break;
                }
            }

            // если ничего нормального не ввёл — берём первый вариант из answers
            if (code == null)
            {
                code = ((LexemeValue)answers[0]).Value;   // start / yes / no
            }

            // для лога — красивый текст
            string display;
            switch (code)
            {
                case "start": display = "начать"; break;
                case "yes": display = "да"; break;
                case "no": display = "нет"; break;
                default: display = code; break;
            }

            AppendOutput("Выбран ответ по кнопке/вводу: " + display);

            // очищаем поле ввода
            codeBox.Text = "";

            // отправляем в CLIPS
            clips.Eval($"(assert (answer {code}))");
            clips.Eval("(assert (clearmessage))");

            // 3. Запускаем вывод и показываем новые сообщения
            clips.Run();
            HandleResponse();
        }


        private void resetBtn_Click(object sender, EventArgs e)
        {
            outputBox.Text = "";
            clips.Clear();
            shownDiagnoses.Clear();

            string baseDir = AppDomain.CurrentDomain.BaseDirectory;

            string templatesText = File.ReadAllText(Path.Combine(baseDir, "templates.clp"), Encoding.UTF8);
            string domainText = File.ReadAllText(Path.Combine(baseDir, "domain.clp"), Encoding.UTF8);
            string dialogText = File.ReadAllText(Path.Combine(baseDir, "dialog.clp"), Encoding.UTF8);
            string factsText = File.ReadAllText(Path.Combine(baseDir, "facts.clp"), Encoding.UTF8);
            
            clips.LoadFromString(factsText);
            clips.LoadFromString(templatesText);
            clips.LoadFromString(domainText);
            clips.LoadFromString(dialogText);

            clips.Reset();

            outputBox.Text += "База знаний загружена, можно жать «Дальше».\r\n";

            // СРАЗУ показываем приветствие из (deffacts start)
            HandleResponse();
        }


        private void openFile_Click(object sender, EventArgs e)
        {
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                codeBox.Text = System.IO.File.ReadAllText(clipsOpenFileDialog.FileName);
                Text = "Экспертная система \"Тиндер\" – " + clipsOpenFileDialog.FileName;
            }
        }

        private void fontSelect_Click(object sender, EventArgs e)
        {
            if (fontDialog1.ShowDialog() == DialogResult.OK)
            {
                codeBox.Font = fontDialog1.Font;
                outputBox.Font = fontDialog1.Font;
            }
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            clipsSaveFileDialog.FileName = clipsOpenFileDialog.FileName;
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text);
            }
        }
        private void AppendOutput(string text)
        {
            outputBox.AppendText(text + System.Environment.NewLine);
            outputBox.SelectionStart = outputBox.TextLength;
            outputBox.SelectionLength = 0;
            outputBox.ScrollToCaret();
        }
        private void ClipsFormsExample_Load(object sender, EventArgs e)
        {

        }

    }
}