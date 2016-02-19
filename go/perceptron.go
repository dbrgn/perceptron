package main

import (
	"fmt"
	"math/rand"
	"time"
)

const (
	// ETA is the learning rate
	ETA float64 = 0.2
	// N iterations
	N = 100
)

// TrainingDatum represents training data
type TrainingDatum struct {
	Input    [3]int8
	Expected int8
}

func dot(input [3]int8, weights []float64) float64 {
	return float64(input[0])*weights[0] +
		float64(input[1])*weights[1] +
		float64(input[2])*weights[2]
}

// heaviside step function
func heaviside(in float64) int8 {
	if in < 0 {
		return 0
	}
	return 1
}

func main() {
	trainingData := []TrainingDatum{
		TrainingDatum{Input: [3]int8{0, 0, 1}, Expected: 0},
		TrainingDatum{Input: [3]int8{0, 1, 1}, Expected: 1},
		TrainingDatum{Input: [3]int8{1, 0, 1}, Expected: 1},
		TrainingDatum{Input: [3]int8{1, 1, 1}, Expected: 1},
	}

	rand.Seed(time.Now().UnixNano())
	w := []float64{
		rand.Float64(),
		rand.Float64(),
		rand.Float64(),
	}

	fmt.Println("initial weight: ", w)

	for i := 0; i < N; i++ {
		td := trainingData[rand.Intn(len(trainingData))]
		result := dot(td.Input, w)
		errorValue := int8(td.Expected) - heaviside(result)

		w[0] += float64(errorValue*td.Input[0]) * ETA
		w[1] += float64(errorValue*td.Input[1]) * ETA
		w[2] += float64(errorValue*td.Input[2]) * ETA
	}

	for _, td := range trainingData {
		result := dot(td.Input, w)

		fmt.Printf("%v: % .7f -> %d\n",
			td.Input[0:2],
			result,
			heaviside(result))
	}
	fmt.Println("final weight: ", w)
}
