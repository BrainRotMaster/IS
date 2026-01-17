using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AForge.WindowsForms
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            //Application.EnableVisualStyles();
            //Application.SetCompatibleTextRenderingDefault(false);

            // Запускаем бот
            AIMLbot bot = null;
            try
            {
                bot = new AIMLbot();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка запуска бота: " + ex.Message);
            }
            //Application.Run(new NeuralNetworksStand(new Dictionary<string, Func<int[], BaseNetwork>>
            //{
            //    // Тут можно добавить свои нейросети
            //    {"Accord.Net Perseptron", structure => new AccordNet(structure)},
            //    {"Студентческий персептрон", structure => new StudentNetwork(structure)},
            //}));

            //// Останавливаем бота при закрытии формы
            //bot?.Stop();
        }
    }
}
