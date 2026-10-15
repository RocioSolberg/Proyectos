from google.colab import drive
drive.mount('/content/drive')

import pandas as pd

df = pd.read_csv("/content/drive/MyDrive/BaseDeDatos/Breast_GSE45827.csv")
print (df.head())

counts_p = df['type'].value_counts()
print("")
print("pacientes según tipo de cáncer: ",counts_p)
print("forma =", df.shape)

# Separar las etiquetas
Y = df[['type']]
X = df.drop(columns=['type'])

print(Y.head())

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder, OneHotEncoder
import tensorflow as tf
from tensorflow.keras.utils import to_categorical

# Calcular la varianza de cada gen
variances = X.var(axis=0)
# Seleccionar los 1000 genes más variables
top_genes = variances.sort_values(ascending=False).head(29).index
X_reduced = X[top_genes]

print("Nueva forma de X después de reducción:", X_reduced.shape)
print(X_reduced.head())

# Normalización de datos
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_reduced)

# Codificar los nombres como números
le = LabelEncoder()
y_int = le.fit_transform(Y['type'])

# Convertir a codificación one-hot
y_onehot = to_categorical(y_int)

print("Clases detectadas:", le.classes_)
print("Ejemplo de vector one-hot:", y_onehot[0])

# División de los datos
X_train, X_temp, y_train, y_temp = train_test_split(
    X_scaled, y_onehot, test_size=0.3, stratify=y_onehot, random_state=42)

# X_temp e Y_temp son variables que temporalmente guardan el otro 30% de los
# datos
# test_size = 0.3 significa que el 70% de datos van para entrenamiento y el 30%
# para testeo. El random_state es para mantener siempre
# la misma división de datos para correr el código más veces y que de el
# mismo resultado

X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, test_size=0.5, stratify=y_temp, random_state=42)

# En este caso test_size = 0.5 es para dividir el 30% anterior en 15% para test
# y 15% para validación

# Pasamos a tensorflow
train_ds = tf.data.Dataset.from_tensor_slices((X_train, y_train)).batch(8)
val_ds = tf.data.Dataset.from_tensor_slices((X_val, y_val)).batch(8)
test_ds = tf.data.Dataset.from_tensor_slices((X_test, y_test)).batch(8)

import tensorflow as tf
from tensorflow.keras import layers, models
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

# Crear el modelo secuencial
model = models.Sequential([
    layers.Input(shape=(X_train.shape[1],)),     # número de genes
    layers.Dense(64, activation='relu'),
    layers.Dropout(0.4),
    layers.Dense(32, activation='relu'),
    layers.Dropout(0.3),
    layers.Dense(y_train.shape[1], activation='softmax')  # salida multiclase
])

# Compilar el modelo
model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

# Entrenar el modelo
history = model.fit(
    X_train,
    y_train,
    validation_data=(X_val, y_val),
    epochs=15,
    batch_size=4,
    verbose=1
)

# Evaluar el modelo
test_loss, test_acc = model.evaluate(X_test, y_test, verbose=0)
print(f"Exactitud en test: {test_acc:.3f}")

plt.figure(figsize=(8, 4))
plt.plot(history.history['accuracy'], label='Entrenamiento')
plt.plot(history.history['val_accuracy'], label='Validación')
plt.xlabel('Épocas')
plt.ylabel('Exactitud')
plt.legend()
plt.show()

# Predicciones de probabilidades
y_pred_proba = model.predict(X_test)

# Convertir probabilidades a etiquetas (clases)
y_pred = np.argmax(y_pred_proba, axis=1)
y_true = np.argmax(y_test, axis=1)

# Reporte detallado por clase
print(classification_report(y_true, y_pred))

# Matriz de confusión
cm = confusion_matrix(y_true, y_pred)
print("Matriz de confusión:")
print(cm)

plt.figure(figsize=(8,6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.title('Matriz de Confusión')
plt.xlabel('Predicho')
plt.ylabel('Real')
plt.show()