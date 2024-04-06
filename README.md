# Handwritten Quadratic Equations Recognizer

The goal of this project is to build an end-to-end simplified version of quadratic equations recognizer. It includes generating and labeling data, data preprocessing, and building a custom model.

## Overview

This project focuses on creating a model that can accurately identify and interpret quadratic equations written by hand.

## Dataset

The dataset comprises 721 images of handwritten quadratic equations, written by hand and annotated myself their corresponding coefficients. Each image is mapped to its quadratic, linear, and constant coefficients in a structured CSV file. It looks like this:

![Screenshot 2024-04-06 at 11 18 23 AM](https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/c43c6a1c-86ad-45f6-b1c2-4d9a1b4d7f08)
![Screenshot 2024-04-06 at 11 19 04 AM](https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/c4b68f9e-1b74-443a-9df0-44288aa56cd7)

## Model Architecture

The model is based on a simplified ResNet architecture, which is a solid choice for image recognintion task while being computationally efficient. The architecture includes several residual blocks with convolutional layers, batch normalization, ReLU activations, and a global average pooling layer, ending in a dense layer for coefficient prediction.

## Features

- **Custom ResNet-like Architecture**: Tailored for the specific task of recognizing quadratic equations, ensuring efficient learning and accurate predictions.
- **Data Augmentation**: Implemented to enrich the dataset, enhancing the model's ability to generalize across various handwriting styles.
- **From Scratch Training**: The model is trained from the ground up, using a carefully curated dataset to learn the nuances of handwritten quadratic equations.

