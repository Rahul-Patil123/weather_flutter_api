import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/aditional_information.dart';
import 'package:weather_app/secret.dart';
import 'package:weather_app/weather_information_file.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Ahmedabad';
      final res = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openweatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Unexpected error occured.';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currTemp = currentWeatherData['main']['temp'];
          final currSky = currentWeatherData['weather'][0]['main'];
          final currPress = currentWeatherData['main']['pressure'];
          final currHumidity = currentWeatherData['main']['humidity'];
          final currSpeed = currentWeatherData['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // height: 200,
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(23))),
                    margin: const EdgeInsets.all(8),
                    // shadowColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currTemp K',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currSky == 'Clouds' || currSky == 'Rain' ? Icons.cloud : Icons.sunny,
                                size: 80,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                '$currSky',
                                style: const TextStyle(fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final sky = data['list'][index + 1]['weather'][0]['main'];
                      final temp = data['list'][index + 1]['main']['temp'];
                      final time = DateTime.parse(data['list'][index + 1]['dt_txt']);
                      return MiniCards(
                        time: DateFormat.j().format(time),
                        icon: sky == 'Clouds' || sky == 'Rain' ? Icons.cloud : Icons.sunny,
                        temp: temp.toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currHumidity.toString(),
                    ),
                    AditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currSpeed.toString(),
                    ),
                    AditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currPress.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
