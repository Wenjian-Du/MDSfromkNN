# Multidimensional scaling from $K$-nearest neighborhood distacnes

## Overview
This repository contains the implementation of the algorithms presented in our paper. It includes a comprehensive codebase for reconstructing geometries from noisy and incomplete distance measurements.

## Main Functions
- `GlobalReconstruction_kNN`: This is the main function of the project, which orchestrates the global reconstruction process based on the k-Nearest Neighbors (kNN) approach.
- `LinearReconstruct`: Function responsible for the distance extension step, extending partial distances to estimate missing values accurately.
- `ADMMRGrad`: Implements the subsequent steps of the algorithm using the Alternating Direction Method of Multipliers (ADMM) combined with Riemannian Gradient Descent to refine the reconstruction.

## Data
The `Data` folder contains the datasets for the four different surfaces mentioned in our paper. These datasets include:
- Uniformly sampled sphere
- Non-uniformly sampled sphere
- Kitten
- Cow

