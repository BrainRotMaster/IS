using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;

namespace AForge.WindowsForms
{
    using System.Drawing.Imaging;

    public enum FigureType : byte { audi = 0, bmw, kia, lexus, mercedes, mitsubishi, opel, shevrolet, suzuki, volkswagen, Undef };
    public class DatasetProcessor
    {
        public static string LetterTypeToString(FigureType type)
        {
            switch (type)
            {
                case FigureType.audi:
                    return "audi";
                case FigureType.bmw:
                    return "bmw";
                case FigureType.kia:
                    return "kia";
                case FigureType.lexus:
                    return "lexus";
                case FigureType.mercedes:
                    return "mercedes";
                case FigureType.mitsubishi:
                    return "mitsubishi";
                case FigureType.opel:
                    return "opel";
                case FigureType.shevrolet:
                    return "shevrolet";
                case FigureType.suzuki:
                    return "suzuki";
                case FigureType.volkswagen:
                    return "volkswagen";
                case FigureType.Undef:
                    return "Неизвестно";
                default:
                    throw new ArgumentOutOfRangeException(nameof(type), type, null);
            }
        }

        private const string databaseLocation = "..\\..\\dataset";
        private Random random;
        public int ClassCount { get; set; }

        private Dictionary<FigureType, List<string>> structure;
        public DatasetProcessor()
        {
            random = new Random();
            structure = new Dictionary<FigureType, List<string>>();
            structure[FigureType.audi] = new List<string>();
            structure[FigureType.bmw] = new List<string>();
            structure[FigureType.kia] = new List<string>();
            structure[FigureType.lexus] = new List<string>();
            structure[FigureType.mercedes] = new List<string>();
            structure[FigureType.mitsubishi] = new List<string>();
            structure[FigureType.opel] = new List<string>();
            structure[FigureType.shevrolet] = new List<string>();
            structure[FigureType.suzuki] = new List<string>();
            structure[FigureType.volkswagen] = new List<string>();

            foreach (var letter in structure)
            {
                DirectoryInfo d = new DirectoryInfo(databaseLocation + $"\\{LetterTypeToString(letter.Key)}");
                letter.Value.AddRange(d.GetFiles("*.png").Select(f => f.FullName));
            }
        }

        private double[] ExtractFeatures(Bitmap bitmap)
        {
            const int size = 100;
            double[] features = new double[200];

            Rectangle rect = new Rectangle(0, 0, size, size);
            BitmapData data = bitmap.LockBits(
                rect,
                ImageLockMode.ReadOnly,
                PixelFormat.Format24bppRgb);

            try
            {
                unsafe
                {
                    byte* ptr = (byte*)data.Scan0;
                    int stride = data.Stride;

                    bool IsBlack(int x, int y)
                    {
                        byte* pixel = ptr + y * stride + x * 3;
                        // считаем не-белым всё, что не 255,255,255
                        return !(pixel[0] == 255 && pixel[1] == 255 && pixel[2] == 255);
                    }

                    // 3. Переходы по строкам
                    for (int y = 0; y < size; y++)
                    {
                        int transitions = 0;
                        bool prevBlack = IsBlack(0, y);

                        for (int x = 1; x < size; x++)
                        {
                            bool currBlack = IsBlack(x, y);
                            if (currBlack != prevBlack)
                                transitions++;
                            prevBlack = currBlack;
                        }
                        features[y] = transitions / 100.0;
                    }

                    // 4. Переходы по столбцам
                    for (int x = 0; x < size; x++)
                    {
                        int transitions = 0;
                        bool prevBlack = IsBlack(x, 0);

                        for (int y = 1; y < size; y++)
                        {
                            bool currBlack = IsBlack(x, y);
                            if (currBlack != prevBlack)
                                transitions++;
                            prevBlack = currBlack;
                        }
                        features[100 + x] = transitions / 100.0;
                    }

                    //// 1. Плотность по столбцам (X)
                    //for (int x = 0; x < size; x++)
                    //{
                    //    int count = 0;
                    //    for (int y = 0; y < size; y++)
                    //    {
                    //        if (IsBlack(x, y))
                    //            count++;
                    //    }
                    //    features[200 + x] = count / 100.0;
                    //}

                    //// 2. Плотность по строкам (Y)
                    //for (int y = 0; y < size; y++)
                    //{
                    //    int count = 0;
                    //    for (int x = 0; x < size; x++)
                    //    {
                    //        if (IsBlack(x, y))
                    //            count++;
                    //    }
                    //    features[300 + y] = count / 100.0;
                    //}

                    
                }
            }
            finally
            {
                bitmap.UnlockBits(data);
            }

            return features;
        }


        public SamplesSet getTrainDataset(int count)
        {
            SamplesSet set = new SamplesSet();

            for (int type = 0; type < ClassCount; type++)
            {
                for (int i = 0; i < count / ClassCount; i++)
                {
                    var path = structure[(FigureType)type]
                        [random.Next(structure[(FigureType)type].Count)];

                    Bitmap bmp = new Bitmap(path);
                    double[] input = ExtractFeatures(bmp);

                    set.AddSample(new Sample(input, ClassCount, (FigureType)type));
                }
            }

            set.shuffle();
            return set;
        }

        public SamplesSet getTestDataset(int count)
        {
            SamplesSet set = new SamplesSet();

            for (int type = 0; type < ClassCount; type++)
            {
                for (int i = 0; i < count / ClassCount; i++)
                {
                    var path = structure[(FigureType)type]
                        [random.Next(structure[(FigureType)type].Count)];

                    Bitmap bmp = new Bitmap(path);
                    double[] input = ExtractFeatures(bmp);

                    set.AddSample(new Sample(input, ClassCount, (FigureType)type));
                }
            }

            set.shuffle();
            return set;
        }

        public Sample getSample(Bitmap bitmap)
        {
            double[] input = ExtractFeatures(bitmap);
            return new Sample(input, ClassCount);
        }

        public Tuple<Sample, Bitmap> getSample()
        {
            var type = (FigureType)random.Next(ClassCount);
            var path = structure[type][random.Next(structure[type].Count)];

            Bitmap bitmap = new Bitmap(path);
            double[] input = ExtractFeatures(bitmap);

            Sample sample = new Sample(input, ClassCount, type);
            return Tuple.Create(sample, bitmap);
        }

    }
}
