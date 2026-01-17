using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telegram.Bot;
using Telegram.Bot.Types;

namespace NeuralNetwork1
{
    class TLGBotik
    {
        public Telegram.Bot.TelegramBotClient botik = null;

        private UpdateTLGMessages formUpdater;

        private BaseNetwork perseptron = null;

        public TLGBotik(BaseNetwork net,  UpdateTLGMessages updater)
        { 
            var botKey = System.IO.File.ReadAllText("botkey.txt");
            botik = new Telegram.Bot.TelegramBotClient(botKey);
            botik.OnMessage += Botik_OnMessageAsync;
            formUpdater = updater;
            perseptron = net;
        }

        public void SetNet(BaseNetwork net)
        {
            perseptron = net;
            formUpdater("Net updated!");
        }

        private void Botik_OnMessageAsync(object sender, Telegram.Bot.Args.MessageEventArgs e)
        {
            //  Тут очень простое дело - банально отправляем назад сообщения
            var message = e.Message;
            formUpdater("Тип сообщения : " + message.Type.ToString());

            //  Получение файла (картинки)
            if (message.Type == Telegram.Bot.Types.Enums.MessageType.Photo)
            {
                formUpdater("Picture loadining started");
                var photoId = message.Photo.Last().FileId;
                File fl = botik.GetFileAsync(photoId).Result;

                var img = System.Drawing.Image.FromStream(botik.DownloadFileAsync(fl.FilePath).Result);
                
                System.Drawing.Bitmap bm = new System.Drawing.Bitmap(img);

                //  Масштабируем aforge
                AForge.Imaging.Filters.ResizeBilinear scaleFilter = new AForge.Imaging.Filters.ResizeBilinear(200,200);
                var uProcessed = scaleFilter.Apply(AForge.Imaging.UnmanagedImage.FromManagedImage(bm));

                Sample sample = GenerateImage.GenerateFigure(uProcessed);

                switch(perseptron.Predict(sample))
                {
                    case FigureType.Rectangle: botik.SendTextMessageAsync(message.Chat.Id, "Это легко, это был прямоугольник!");break;
                    case FigureType.Circle: botik.SendTextMessageAsync(message.Chat.Id, "Это легко, кружочек!"); break;
                    case FigureType.Sinusiod: botik.SendTextMessageAsync(message.Chat.Id, "Синусоида!"); break;
                    case FigureType.Triangle: botik.SendTextMessageAsync(message.Chat.Id, "Это легко, это был треугольник!"); break;
                    default: botik.SendTextMessageAsync(message.Chat.Id, "Я такого не знаю!"); break;
                }

                formUpdater("Picture recognized!");
                return;
            }

            if (message == null || message.Type != Telegram.Bot.Types.Enums.MessageType.Text) return;
            if(message.Text == "Authors")
            {
                string authors = "Гаянэ Аршакян, Луспарон Тызыхян, Дамир Казеев, Роман Хыдыров, Владимир Садовский, Анастасия Аскерова, Константин Бервинов, и Борис Трикоз (но он уже спать ушел) и молчаливый Даниил Ярошенко";
                botik.SendTextMessageAsync(message.Chat.Id, "Авторы проекта : " + authors);
            }
            botik.SendTextMessageAsync(message.Chat.Id, "Bot reply : " + message.Text);
            formUpdater(message.Text);
            return;
        }

        public bool Act()
        {
            try
            {
                botik.StartReceiving();
            }
            catch(Exception e) { 
                return false;
            }
            return true;
        }

        public void Stop()
        {
            botik.StopReceiving();
        }

    }
}
