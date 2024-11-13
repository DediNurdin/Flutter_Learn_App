import 'package:flutter/material.dart';
import 'package:flutter_learn/weather_app/model/weather_model.dart';
import 'package:flutter_learn/weather_app/services/weather_services.dart';
import 'package:intl/intl.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({
    super.key,
    required this.lat,
    required this.lon,
  });

  final double lat;
  final double lon;

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  myWeather() {
    isLoading = false;
    WeatherServices().fetchWeather(widget.lat, widget.lon).then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? WeatherDetail(
                weather: weatherInfo,
                formattedDate: formattedDate,
                formattedTime: formattedTime,
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          weather.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: weather.temperature.current.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 75),
                    ),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0, -30),
                        child: const Text(
                          '°C',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (weather.weather.isNotEmpty)
                Text(
                  weather.weather[0].main,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          Container(
            height: 250,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Wind",
                              value: "${weather.wind.speed}km/h"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.sunny,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Max",
                              value:
                                  "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Min",
                              value:
                                  "${weather.minTemperature.toStringAsFixed(2)}°C"),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Humidity", value: "${weather.humidity}%"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.air,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Pressure",
                              value: "${weather.pressure}hPa"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.leaderboard,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 5),
                          weatherInfoCard(
                              title: "Sea-Level",
                              value: "${weather.seaLevel}m"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
