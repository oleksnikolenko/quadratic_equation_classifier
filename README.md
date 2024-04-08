# Handwritten Quadratic Equations Recognizer

The goal of this project is to build an end-to-end simplified version of quadratic equations recognizer. It includes generating and labeling data, data preprocessing, and building a custom model.

## Overview

This project focuses on creating a model that can accurately identify and interpret quadratic equations written by hand.
My motivation was to create a project that includes all the steps for machine learning model, from collecting data to deployment.

## Dataset
To collect data, I generated random equations, and did the handwriting myself. The dataset comprises 721 images of handwritten quadratic equations, written by hand and annotated myself with their corresponding coefficients.

<img width="298" alt="Picture2" src="https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/75e5b4cb-07aa-4495-b11f-c9706ca8586d">
<img width="251" alt="Picture1" src="https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/9827e5dc-4e53-4b88-85d5-75d444cc4c0a">
<br/><br/>
Each image is mapped to its quadratic, linear, and constant coefficients in a structured CSV file. It looks like this:

![Screenshot 2024-04-06 at 11 18 23 AM](https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/c43c6a1c-86ad-45f6-b1c2-4d9a1b4d7f08)
![Screenshot 2024-04-06 at 11 19 04 AM](https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/c4b68f9e-1b74-443a-9df0-44288aa56cd7)


## Model Architecture

The model is based on a simplified ResNet architecture, which is a solid choice for image recognintion task while being computationally efficient. The architecture includes several residual blocks with convolutional layers, batch normalization, ReLU activations, and a global average pooling layer, ending in a dense layer for coefficient prediction.

## Mobile app
Finally, I've created an iOS app and deployed a model using TFLite:

<img width="243" alt="Picture4" src="https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/f4dc7e2b-d048-4a19-9689-5725186b9e2f">

<img width="243" alt="Picture3" src="https://github.com/oleksnikolenko/quadratic_equation_classifier/assets/48183074/e0ba8123-d7cc-4190-9e9c-757d680fa828">


## Features

- **Custom ResNet-like Architecture**: Tailored for the specific task of recognizing quadratic equations, ensuring efficient learning and accurate predictions.
- **Data Augmentation**: Implemented to enrich the dataset, enhancing the model's ability to generalize across various handwriting styles.
- **From Scratch Training**: The model is trained from the ground up, using a carefully curated dataset to learn the nuances of handwritten quadratic equations.
