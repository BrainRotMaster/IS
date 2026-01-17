using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace AForge.WindowsForms
{
    public class StudentNetwork : BaseNetwork
    {
        public Stopwatch stopWatch = new Stopwatch();

        bool paralell = false;
        public double learn = 0.1;

        private double[][] layers;
        private double[][,] weights;
        private double[][] errors;

        public StudentNetwork(int[] structure)
        {
            layers = new double[structure.Length][];
            layers[0] = new double[structure[0] + 1];
            layers[0][structure[0]] = 1;
            errors = new double[structure.Length][];
            weights = new double[structure.Length - 1][,];

            for (int i = 1; i < structure.Length; i++)
            {
                if (i == structure.Length - 1)
                    layers[i] = new double[structure[i]];
                else
                {
                    layers[i] = new double[structure[i] + 1];
                    layers[i][structure[i]] = 1;
                }
                errors[i] = new double[structure[i]];
                if (i != structure.Length - 1)
                    layers[i][structure[i]] = 1;
                weights[i - 1] = new double[structure[i - 1] + 1, structure[i]];
            }
            InitRandomWeights();
        }

        private double Sigmoid(double x)
        {
            return 1f / (1f + System.Math.Exp(-x));
        }

        private double SigmoidDerivative(double x)
        {
            return x * (1f - x);
        }

        private void InitRandomWeights()
        {
            var rnd = new Random();

            foreach (var w in weights)
                for (int i = 0; i < w.GetLength(0); i++)
                    for (int j = 0; j < w.GetLength(1); j++)
                        w[i, j] = rnd.NextDouble() * 2 - 1;
        }

        private void ForwardPass()
        {
            if (paralell)
            {
                for (int k = 1; k < layers.Length; k++)
                    Parallel.For(0, weights[k - 1].GetLength(1), j =>
                    {
                        double sum = 0;
                        for (int i = 0; i < weights[k - 1].GetLength(0); i++)
                            sum += weights[k - 1][i, j] * layers[k - 1][i];
                        layers[k][j] = Sigmoid(sum);
                    });
            }
            else
            {
                for (int k = 1; k < layers.Length; k++)
                    for (int j = 0; j < weights[k - 1].GetLength(1); j++)
                    {
                        double sum = 0;
                        for (int i = 0; i < weights[k - 1].GetLength(0); i++)
                            sum += weights[k - 1][i, j] * layers[k - 1][i];
                        layers[k][j] = Sigmoid(sum);
                    }
            }
        }

        private void BackPropagation(int ans_idx)
        {
            if (paralell)
            {
                int k = layers.Length - 1;
                Parallel.For(0, layers[k].Length, j =>
                {
                    double n = layers[k][j];
                    errors[k][j] = -SigmoidDerivative(n) * ((j == ans_idx ? 1f : 0f) - n);
                });

                for (k = layers.Length - 2; k > 0; k--)
                    Parallel.For(0, layers[k].Length - 1, i =>
                    {
                        errors[k][i] = 0;
                        for (int j = 0; j < weights[k].GetLength(1); j++)
                            errors[k][i] += weights[k][i, j] * errors[k + 1][j];
                        errors[k][i] *= SigmoidDerivative(layers[k][i]);
                    });

                for (k = 0; k < weights.Length; k++)
                    Parallel.For(0, weights[k].GetLength(0), i =>
                    {
                        for (int j = 0; j < weights[k].GetLength(1); j++)
                            weights[k][i, j] += -learn * errors[k + 1][j] * layers[k][i];
                    });
            }
            else
            {
                int k = layers.Length - 1;
                for (int j = 0; j < layers[k].Length; j++)
                {
                    double n = layers[k][j];
                    errors[k][j] = -SigmoidDerivative(n) * ((j == ans_idx ? 1f : 0f) - n);
                }

                for (k = layers.Length - 2; k > 0; k--)
                    for (int i = 0; i < layers[k].Length - 1; i++)
                    {
                        errors[k][i] = 0;
                        for (int j = 0; j < weights[k].GetLength(1); j++)
                            errors[k][i] += weights[k][i, j] * errors[k + 1][j];
                        errors[k][i] *= SigmoidDerivative(layers[k][i]);
                    }

                for (k = 0; k < weights.Length; k++)
                    for (int i = 0; i < weights[k].GetLength(0); i++)
                        for (int j = 0; j < weights[k].GetLength(1); j++)
                            weights[k][i, j] += -learn * errors[k + 1][j] * layers[k][i];
            }
        }

        public override int Train(Sample sample, double acceptableError, bool parallel)
        {
            paralell = parallel;
            int iters = 0;

            while (Predict(sample) != sample.actualClass && sample.EstimatedError() > acceptableError)
            {
                iters++;
                BackPropagation((int)sample.actualClass);
            }
            return iters;
        }

        public override double TrainOnDataSet(SamplesSet samplesSet, int epochsCount, double acceptableError, bool parallel)
        {
            paralell = parallel;
            double error = double.PositiveInfinity;
            int epoch_to_run = 0;
            stopWatch.Restart();

            while (epoch_to_run < epochsCount && error > acceptableError / samplesSet.Count)
            {
                epoch_to_run++;
                error = 0;
                foreach (var sample in samplesSet.samples)
                {
                    Predict(sample);
                    error += sample.EstimatedError();
                    BackPropagation((int)sample.actualClass);
                }

                OnTrainProgress((epoch_to_run * 1.0) / epochsCount, error / samplesSet.Count, stopWatch.Elapsed);

                //можно выйти при достежинии нужной ошибки
                //if (error / samplesSet.Count < acceptableError / samplesSet.Count)
                //{
                //    OnTrainProgress(1.0, error / samplesSet.Count, stopWatch.Elapsed);
                //    stopWatch.Stop();
                //    return error / samplesSet.Count;
                //}
            }

            OnTrainProgress(1.0, error / samplesSet.Count, stopWatch.Elapsed);
            stopWatch.Stop();
            return error / samplesSet.Count;
        }

        protected override double[] Compute(double[] input)
        {
            for (int i = 0; i < input.Length; i++)
                layers[0][i] = input[i];

            ForwardPass();
            return layers[layers.Length - 1];
        }
    }
}
