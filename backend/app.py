from flask import Flask, request, jsonify, render_template
import pandas as pd
import joblib
import numpy as np

app = Flask(__name__)

mlp_model = joblib.load("mlp_model.pkl")
linear_model = joblib.load("lr_model.pkl")
rf_model = joblib.load("rf_model.pkl")
columns = joblib.load("columns.pkl")

def transform(features):
    features['rainfall'] = np.log1p(features['rainfall'])

    rainMin = 4.626343793411346
    rainMax = 8.358903359291658
    tempMean = 24.453335060827776
    tempStd = 6.847276919397958

    features['rainfall'] = (features['rainfall'] - rainMin) / (rainMax - rainMin) 
    features["temperature"] = (features["temperature"] - tempMean) / tempStd

    return features

def inverse(prediction):
    yieldMin = 0.00
    yieldMax = 7.986448277905101

    prediction = prediction * (yieldMax - yieldMin) + yieldMin

    prediction = np.expm1(prediction)

    return prediction


@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    model_type = data.get('model', 'linear')
    input_df = pd.DataFrame([data['features']])

    input_encoded = pd.get_dummies(input_df)

    input_encoded = input_encoded.reindex(columns=columns, fill_value=0)

    # print(features_scaled)
    features_scaled = transform(input_encoded)

    if model_type == 'mlp':
        prediction = mlp_model.predict(features_scaled)[0]
    elif model_type == 'rf':
        prediction = rf_model.predict(features_scaled)[0]
    else:
        prediction = linear_model.predict(features_scaled)[0]

    prediction = inverse(prediction)

    return jsonify({'prediction': float(prediction)})

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
