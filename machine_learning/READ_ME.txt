Breast Cancer Classification Using Gene Expression Data

Overview

This project explores the use of machine learning to classify breast cancer types based on gene expression profiles. Using labeled gene expression data, a neural network is trained to identify patterns associated with different cancer types and predict the cancer type of unseen samples.

The model is built using Python, TensorFlow, and scikit-learn, combining gene selection, data preprocessing, and multiclass classification.

Objectives

Analyze gene expression data from breast cancer patients.

Reduce the feature space by selecting the most variable genes.

Train a neural network to classify breast cancer types.

Evaluate the model's ability to predict cancer types in unseen samples.

Compare predicted labels with the actual labels using classification metrics and a confusion matrix.

Dataset

The project uses the Breast_GSE45827.csv dataset, which contains gene expression measurements and a type column indicating the breast cancer type associated with each sample.

Features: Gene expression values.

Target variable: Breast cancer type.

Task: Supervised multiclass classification.

Methodology

1. Data Loading and Exploration

The dataset is loaded using pandas. Initial exploration includes examining the dataset dimensions and checking the distribution of samples across cancer types.

2. Feature Selection

Gene expression datasets can contain a large number of features. To reduce dimensionality, gene-wise variance is calculated, and the 29 genes with the highest variance are selected for model training.

3. Data Preprocessing

Standardization: Gene expression features are standardized using StandardScaler.

Label encoding: Cancer type labels are converted into numerical values.

One-hot encoding: Labels are transformed into one-hot vectors for multiclass classification.

Dataset splitting: Samples are divided into training (70%), validation (15%), and test (15%) sets, using stratification to preserve class proportions.

4. Neural Network Architecture

A feedforward neural network is implemented using TensorFlow and Keras.

The architecture consists of:

An input layer representing the selected gene expression features.

A fully connected layer with 64 neurons and ReLU activation.

A dropout layer with a rate of 0.4.

A fully connected layer with 32 neurons and ReLU activation.

A dropout layer with a rate of 0.3.

An output layer with softmax activation to predict probabilities for each cancer type.

The model is trained using the Adam optimizer and categorical cross-entropy loss.

5. Model Training

The neural network is trained for 15 epochs, with a batch size of 4. Training and validation accuracy are monitored to observe model performance throughout training.

6. Evaluation and Predictions

The model is evaluated on the held-out test set, which is not used for training. Predicted probabilities are converted into class labels and compared with the true labels.

Evaluation includes:

Test accuracy: Overall proportion of correctly classified samples.

Classification report: Precision, recall, and F1-score for each class.

Confusion matrix: Comparison between actual and predicted cancer types.

Learning curve: Visualization of training and validation accuracy across epochs.

Technologies Used

Python

Pandas — Data loading and manipulation.

NumPy — Numerical operations.

Scikit-learn — Data preprocessing, dataset splitting, and evaluation metrics.

TensorFlow / Keras — Neural network implementation and training.

Matplotlib — Data visualization.

Seaborn — Confusion matrix visualization.

Google Colab — Development environment.

Results

The model's performance is assessed using test accuracy, class-specific precision, recall, F1-scores, and a confusion matrix.

These metrics help evaluate how well the model distinguishes between the breast cancer types represented in the dataset and identify classes that may be more difficult to classify.