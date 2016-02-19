package main

import "testing"

func TestHeaviside(t *testing.T) {
	data := map[float64]int8{
		-1000.1:             0,
		-0.0000000000000001: 0,
		0.0:                 1,
		0.00000000000000001: 1,
		133.7:               1,
	}

	for in, expected := range data {
		actual := heaviside(in)
		if actual != expected {
			t.Errorf("Expected: %d\n    Got: %d", expected, actual)
		}
	}
}
