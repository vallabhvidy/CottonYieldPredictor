import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class CottonPrediction {

  final List<String> soilTypes = ['Clay', 'Loam', 'Peaty', 'Sandy', 'Silt'];
  final List<String> states = [
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'West Bengal'
  ];
  final List<String> weatherTypes = ['Rainy', 'Sunny'];
  final List<String> seasons = ['Kharif', 'Rabi', 'Summer', 'Whole Year'];

  List<double> oneHotEncode(String value, List<String> categories) {
    return categories.map((cat) => cat == value ? 1.0 : 0.0).toList();
  }

  List<double> processSample({
    required double rainfall,
    required double temperature,
    required bool fertilizer, 
    required bool irrigation, 
    required String soilType,   
    required String state,     
    required String weather,    
    required String season,    
  }) {

    double rainMin = 4.615223450544684, rainMax = 6.908588015145472;
    rainfall = log(rainfall + 1);
    if (rainfall > rainMax || rainfall < rainMin) {
      return [];
    }
    // rainfall = (rainfall - rain_min) / (rain_max - rain_min);

    if (temperature > 40) {
      return [];
    }

    double tempMean = 26.794509231782033, tempStd = 7.2427228270861;
    // temperature = (temperature - temp_mean) / temp_std;

    // rainfall = log(rainfall + 1);
    rainfall = (rainfall - rainMin) / (rainMax - rainMin);

    temperature = (temperature - tempMean) / tempStd;

    print("Processed Flutter Input: $rainfall, $temperature");

  
    double fertilizerEncoded = fertilizer ? 1.0 : 0.0;
    double irrigationEncoded = irrigation ? 1.0 : 0.0;

    
    List<double> soilEncoded = oneHotEncode(soilType, soilTypes);
    List<double> stateEncoded = oneHotEncode(state, states);
    List<double> weatherEncoded = oneHotEncode(weather, weatherTypes);
    List<double> seasonEncoded = oneHotEncode(season, seasons);

    return [
      rainfall,
      temperature,
      fertilizerEncoded,
      irrigationEncoded,
      ...soilEncoded,
      ...stateEncoded,
      ...weatherEncoded,
      ...seasonEncoded,
    ];
  }

  // Future<double> predict(
  //   String model,
  //   double temp,
  //   double rain,
  //   bool fertilizer,
  //   bool irrigation,
  //   String soil,
  //   String state,
  //   String weather,
  //   String season
  // ) async {

  //   List<double> features = processSample(
  //     rainfall: rain,
  //     temperature: temp,
  //     fertilizer: fertilizer,
  //     irrigation: irrigation,
  //     soilType: soil,
  //     state: state,
  //     weather: weather,
  //     season: season,
  //   );

  //   if (features.isEmpty) {
  //     return -1.00;
  //   }

  //   for (int i = 0; i < features.length; i++) {
  //     print("${features[i]}\n");
  //   }

  //   Interpreter inter = await Interpreter.fromAsset('assets/models/linear_regression.tflite');

  //   if (model == 'Linear Regression') {
  //     inter = await Interpreter.fromAsset('assets/models/linear_regression.tflite'); 
  //   } else if (model == 'Neural Networks') {
  //     inter = await Interpreter.fromAsset('assets/models/neural_networks.tflite');
  //   }

  //   var input = [features];

  //   print(features.length);

  //   var output = List.generate(1, (index) => List.filled(1, 0.0));

  //   inter.run(input, output);

  //   double predictedYield = output[0][0];

  //   double yieldMin = 0.00, yieldMax = 0.6322287655905282;
  //   predictedYield = predictedYield * (yieldMax - yieldMin) + yieldMin;
  //   predictedYield = exp(predictedYield) - 1;

  //   return predictedYield;

  // }

  Future<double> predict(
    String model,
    double temp,
    double rain,
    bool fertilizer,
    bool irrigation,
    String soil,
    String state,
    String weather,
    String season
  ) async {
    final String url = 'https://cottonyieldpredictor.onrender.com/predict';
    String modelType = "lr";
    if (model == "Linear Regression") {
      modelType = "lr";
    } else if (model == "Neural Networks") {
      modelType = "mlp";
    } else {
      modelType = "rf";
    }
    Map<String, dynamic> features = {
      "state": state,
      "season": season,
      "soil": soil,
      "temperature": temp,
      "fertilizer": fertilizer,
      "irrigation": irrigation,
      "weather": weather,
      "rainfall": rain,
    };

    final Map<String, dynamic> body = {
    'features': features,
    'model': modelType,  
    };

    final String jsonBody = json.encode(body);

    final response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['prediction'];
    } else {
      throw Exception('Failed to load prediction');
    }
    
  }

}

class PredictionPage extends StatelessWidget {
  final double rain, temp, area;
  final irrigation, fertilizer;
  final String model, state, season, weather, soil;

  PredictionPage({
    super.key, 
    required this.soil,
    required this.irrigation,
    required this.fertilizer,
    required this.state,
    required this.season,
    required this.weather,
    required this.area,  
    required this.temp, 
    required this.rain, 
    required this.model,
  });

  late double prediction;

  String predictText(double p) {
    if (p == -1.00) {
      return 'This is a disaster!!!!';
    }

    return '${max<double>(p, 0.0000).toStringAsFixed(3)} kg/ha';
  }

  Future<double> makePrediction() async {
    var predictor = CottonPrediction(); 

    prediction = await predictor.predict(model, temp, rain, fertilizer, irrigation, soil, state, weather, season);

    return prediction;
  }

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder(
       builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.white : Colors.black,
              ),
            ),
          );
        } else if (snapshot.hasError) {

          return Center(
            child: Text('${snapshot.error} occured'),
          );


        } else if (snapshot.hasData) {


          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/cotton_img.svg',
                          height: 240,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: 200,
                ),
                SliverList.list(
                  children: [
                    ListTile(
                      leading: Text("Predicted Yield "),
                      trailing: Text(predictText(prediction)),
                      leadingAndTrailingTextStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 22
                      ),
                    )
                  ],
                ),
              ],
            )
          );

          
        } else {
          return Placeholder();
        }
       },
       future: makePrediction(),
    );
  }
}