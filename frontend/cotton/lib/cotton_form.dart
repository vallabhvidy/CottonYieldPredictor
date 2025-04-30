import 'package:cotton/prediction_page.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final List<String> models = [
  'Linear Regression',
  'Neural Networks',
  'Random Forest'
];
final List<String> soilTypes = ['Clay', 'Loam', 'Peaty', 'Sandy', 'Silt'];
final List<String> states = [
    "Punjab",
    "Haryana",
    "Rajasthan",
    "Gujarat",
    "Maharashtra",
    "Madhya Pradesh",
    "Telangana",
    "Andhra Pradesh",
    "Karnataka",
    "Tamil Nadu",
    "Odisha",
];

final List<String> weatherTypes = ['Rainy', 'Sunny'];
final List<String> seasons = ['Kharif', 'Rabi', 'Summer', 'Whole Year'];

class CottonForm extends StatefulWidget {
  const CottonForm({super.key});

  @override
  State<CottonForm> createState() => _CottonFormState();
}

class _CottonFormState extends State<CottonForm> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String model = "";
  double area = 0.0;
  double pH = 0.0;
  double moisture = 0.0;
  double temp = 0.0;
  double rain = 0.0;
  double humidity = 0.0;
  bool fertilizer = false;
  bool irrigation = false;
  String state = "";
  String season = "";
  String weather = "";
  String soil = "";

  void submitForm() {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => PredictionPage(
        area: area, 
        soil: soil, 
        weather: weather, 
        temp: temp, rain: rain, 
        irrigation: irrigation,
        fertilizer: fertilizer,
        state: state,
        season: season, 
        model: model
        ))
      );
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            ShadSelectFormField(
              id: 'model',
              initialValue: 'Linear Regression',
              minWidth: 350,
              options: models.map((model) => ShadOption(value: model, child: Text(model))).toList(),
              selectedOptionBuilder: (context, value) => value == 'Select Model'
                ? const Text('Please select a model')
                : Text(value.toString()),
              placeholder: const Text('Select Model'),
              validator: (value) {
                print(value.toString());
                if (value == null) {
                  return 'Please select a model';
                }
                return null;
              },
              onSaved: (value) {
                model = value.toString();
              },
            ),
            const SizedBox(height: 20,),
            ShadInputFormField(
              id: 'rainfall',
              label: Text('Rainfall'),
              placeholder: Text('in mm'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter average rainfall';
                }
                if (double.tryParse(value) == null) {
                  return 'rainfall cannot contain alphabets';
                }
                return null;
              },
              onSaved: (value) {
                rain = double.tryParse(value ?? '0.0') ?? 0.0;
              },
            ),
            const SizedBox(height: 20,),
            ShadInputFormField(
              id: 'temp',
              label: Text('Temperature'),
              placeholder: Text('in °C'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter average temperature';
                }
                if (double.tryParse(value) == null) {
                  return 'Temperature cannot contain alphabets';
                }
                return null;
              },
              onSaved: (value) {
                temp = double.tryParse(value ?? '0.0') ?? 0.0;
              },
            ),
            const SizedBox(height: 20,),
            ShadSelectFormField(
              id: 'state',
              initialValue: 'Select state',
              minWidth: 350,
              options: states.map((state) => ShadOption(value: state, child: Text(state))).toList(),
              selectedOptionBuilder: (context, value) => value == 'Select state'
                ? const Text('Please select a state')
                : Text(value.toString()),
              placeholder: const Text('Select state'),
              validator: (value) {
                print(value.toString());
                if (value == null) {
                  return 'Please select a state';
                }
                return null;
              },
              onSaved: (value) {
                state = value.toString();
              },
            ),
            const SizedBox(height: 20,),
            ShadSelectFormField(
              id: 'season',
              initialValue: 'Select Season',
              minWidth: 350,
              options: seasons.map((season) => ShadOption(value: season, child: Text(season))).toList(),
              selectedOptionBuilder: (context, value) => value == 'Select Season'
                ? const Text('Please select a season')
                : Text(value.toString()),
              placeholder: const Text('Select Season'),
              validator: (value) {
                print(value.toString());
                if (value == null) {
                  return 'Please select a season';
                }
                return null;
              },
              onSaved: (value) {
                season = value.toString();
              },
            ),
            const SizedBox(height: 20,),
            ShadSelectFormField(
              id: 'soilType',
              initialValue: 'Select Soil Type',
              minWidth: 350,
              options: soilTypes.map((soilType) => ShadOption(value: soilType, child: Text(soilType))).toList(),
              selectedOptionBuilder: (context, value) => value == 'Select Soil Type'
                ? const Text('Please select a soil type')
                : Text(value.toString()),
              placeholder: const Text('Select Soil Type'),
              validator: (value) {
                print(value.toString());
                if (value == null) {
                  return 'Please select a Soil Type';
                }
                return null;
              },
              onSaved: (value) {
                soil = value.toString();
              },
            ),
            const SizedBox(height: 20,),
            ShadSelectFormField(
              id: 'weather',
              initialValue: 'Select Weather',
              minWidth: 350,
              options: weatherTypes.map((weather) => ShadOption(value: weather, child: Text(weather))).toList(),
              selectedOptionBuilder: (context, value) => value == 'Select Weather'
                ? const Text('Please select a weather')
                : Text(value.toString()),
              placeholder: const Text('Select Weather'),
              validator: (value) {
                print(value.toString());
                if (value == null) {
                  return 'Please select a weather';
                }
                return null;
              },
              onSaved: (value) {
                weather = value.toString();
              },
            ),
            const SizedBox(height: 20,),
            ShadSwitchFormField(
              id: 'fertilizer',
              initialValue: false,
              inputLabel:
                  const Text('Fertilizer'),
              onChanged: (v) {
                  if (!v) {fertilizer = false;}
                  else {fertilizer = true;}
              },
              inputSublabel:
                  const Text('Were Fertilizers used ?'),
              validator: (v) {
                return null;
              },
            ),
            const SizedBox(height: 20,),
            ShadSwitchFormField(
              id: 'irrigation',
              initialValue: false,
              inputLabel:
                  const Text('Irrigation'),
              onChanged: (v) {
                  if (!v) {irrigation = false;}
                  else {irrigation = true;}
              },
              inputSublabel:
                  const Text('Was Irrigation used ?'),
              validator: (v) {
                return null;
              },
            ),
            const SizedBox(height: 24,),
            ShadButton(
              onPressed: submitForm,
              child: Text('Predict Yield')),
          ],
        ),
      ),
    );
  }
}