using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AForge.WindowsForms
{
    public class AIMLbot : IDisposable
    {
        private readonly TelegramService _telegramService;

        public AIMLbot()
        {
            var token = System.IO.File.ReadAllText("TGToken.txt");

            if (token == "FILL_ME")
                throw new Exception("Укажите реальный токен в TGToken.txt");

            _telegramService = new TelegramService(token, new AIMLService());
            MessageBox.Show("AIMLBOT " + _telegramService.Username);
        }

        public void Stop()
        {
            _telegramService?.Dispose();
            MessageBox.Show("AIMLBOT STOP");
        }

        public void Dispose()
        {
            Stop();           
        }
    }

}
