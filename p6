using System;

class Program
{
    static void Main(string[] args)
    {
        const int iterations = 1000000;
        const int bucketSize = 10;

        Console.WriteLine("Please input estimates for three tasks (best case, worst case, and average case) separated by commas:");
        Console.WriteLine("For example: 1,5,3");

        string[,] tasks = new string[3, 3];

        for (int i = 0; i < 3; i++)
        {
            Console.Write($"Task {i + 1}: ");
            string[] input = Console.ReadLine().Split(',');

            if (input.Length != 3)
            {
                Console.WriteLine("Invalid input. Please try again.");
                return;
            }

            tasks[i, 0] = input[0];
            tasks[i, 1] = input[1];
            tasks[i, 2] = input[2];
        }

        double bestCase = 0;
        double worstCase = 0;
        double averageCase = 0;

        for (int i = 0; i < 3; i++)
        {
            double best = double.Parse(tasks[i, 0]);
            double worst = double.Parse(tasks[i, 1]);
            double average = double.Parse(tasks[i, 2]);

            bestCase += best;
            worstCase += worst;
            averageCase += average;
        }

        Console.WriteLine($"Best case completion time: {bestCase} days");
        Console.WriteLine($"Worst case completion time: {worstCase} days");
        Console.WriteLine($"Average case completion time: {averageCase} days");

        double[] bucketCount = new double[(int)Math.Ceiling(worstCase / (double)bucketSize)];
        int totalBuckets = bucketCount.Length;
        bucketCount[totalBuckets - 1] = iterations - ((totalBuckets - 1) * iterations / bucketCount.Length);

        for (int i = 0; i < totalBuckets - 1; i++)
        {
            bucketCount[i] = iterations / bucketCount.Length;
        }

        for (int i = 0; i < iterations; i++)
        {
            double completionTime = 0;

            for (int j = 0; j < 3; j++)
            {
                double best = double.Parse(tasks[j, 0]);
                double worst = double.Parse(tasks[j, 1]);

                completionTime += new Random().NextDouble() * (worst - best) + best;
            }

            int bucketIndex = (int)Math.Floor(completionTime / bucketSize);

            if (bucketIndex >= bucketCount.Length)
            {
                bucketIndex = bucketCount.Length - 1;
            }

            bucketCount[bucketIndex]++;
        }

        double[] bucketProbabilities = new double[bucketCount.Length];
        double totalProbability = 0;

        for (int i = 0; i < bucketCount.Length; i++)
        {
            double probability = (double)bucketCount[i] / iterations;
            totalProbability += probability;

            Console.WriteLine($"Probability of finishing in {i * bucketSize} to {(i + 1) * bucketSize} days: {probability:P2}");
            bucketProbabilities[i] = totalProbability;
        }

        Console.WriteLine();
        Console.WriteLine("Accumulated probabilities:");

        for (int i = 0; i < bucketProbabilities.Length; i++)
        {
            Console.WriteLine($"Probability of finishing in {i * bucketSize} days or less: {bucketProbabilities[i]:P2}");
        }

        Console.ReadLine();
    }
}

