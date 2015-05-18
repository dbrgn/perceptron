extern crate rand;

use rand::Rng;
use rand::distributions::{Range, IndependentSample};


/// Heaviside Step Function
trait Heaviside {
    fn heaviside(&self) -> i8;
}

/// Implement heaviside() for f64
impl Heaviside for f64 {
    fn heaviside(&self) -> i8 {
        (*self >= 0.0) as i8
    }
}


/// Dot product of input and weights
fn dot(input: (i8, i8, i8), weights: (f64, f64, f64)) -> f64 {
    input.0 as f64 * weights.0
    + input.1 as f64 * weights.1
    + input.2 as f64 * weights.2
}


struct TrainingDatum {
    input: (i8, i8, i8),
    expected: i8,
}


fn main() {
    println!("Hello, perceptron!");

    let mut rng = rand::thread_rng();

    // Provide some training data
    let training_data = [
        TrainingDatum { input: (0, 0, 1), expected: 0 },
        TrainingDatum { input: (0, 1, 1), expected: 1 },
        TrainingDatum { input: (1, 0, 1), expected: 1 },
        TrainingDatum { input: (1, 1, 1), expected: 1 },
    ];

    // Initialize weight vector with random data between 0 and 1
    let range = Range::new(0.0, 1.0);
    let mut w = (
        range.ind_sample(&mut rng),
        range.ind_sample(&mut rng),
        range.ind_sample(&mut rng),
    );

    // Learning rate
    let eta = 0.2;

    // Number of iterations
    let n = 100;

    // Training
    println!("Starting training phase with {} iterations...", n);
    for _ in 0..n {

        // Choose a random training sample
        let &TrainingDatum { input: x, expected } = rng.choose(&training_data).unwrap();

        // Calculate the dot product
        let result = dot(x, w);

        // Calculate the error
        let error = expected - result.heaviside();

        // Update the weights
        w.0 += eta * error as f64 * x.0 as f64;
        w.1 += eta * error as f64 * x.1 as f64;
        w.2 += eta * error as f64 * x.2 as f64;
    }

    // Show result
    for &TrainingDatum { input, .. } in &training_data {
        let result = dot(input, w);
        println!("{} OR {}: {:.*} -> {}", input.0, input.1, 8, result, result.heaviside());
    }
}


#[cfg(test)]
mod test {
    use super::Heaviside;

    #[test]
    fn heaviside_positive() {
        assert_eq!((0.5).heaviside(), 1i8);
    }

    #[test]
    fn heaviside_zero() {
        assert_eq!((0.0).heaviside(), 1i8);
    }

    #[test]
    fn heaviside_negative() {
        assert_eq!((-0.5).heaviside(), 0i8);
    }

}
