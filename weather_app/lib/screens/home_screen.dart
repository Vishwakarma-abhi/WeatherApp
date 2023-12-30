import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.blue.withOpacity(0.5),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue.withOpacity(0.5),
          child: Column(
            children: <Widget>[
              // Search bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter City Name',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Fetch weather data when the search icon is tapped
                                _fetchWeatherData(context);
                              },
                              child: Container(
                                child: Icon(
                                  Icons.search_outlined,
                                  color: Colors.blue,
                                ),
                                margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Display weather information
              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, child) {
                    //storing the weather data
                    final weatherData =
                        provider.weatherData[_cityController.text];

                    if (weatherData != null) {
                      return Column(
                        children: [
                          // Display city and weather description
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        if (weatherData['icon'] != null)
                                          Image.network(
                                            'https://openweathermap.org/img/wn/' +
                                                weatherData['icon'] +
                                                '@2x.png',
                                            height: 50,
                                          ),
                                        Text(
                                          weatherData['weatherDescription'],
                                          // style needed
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '  ${weatherData['cityName']}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Display temperature
                          Container(
                            height: 300,
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            padding: EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  WeatherIcons.thermometer,
                                  size: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weatherData['temperature']
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 90,
                                      ),
                                    ),
                                    Text(
                                      "C",
                                      style: TextStyle(fontSize: 30),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Display wind speed and humidity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  padding: EdgeInsets.all(26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            WeatherIcons.day_windy,
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        weatherData['windSpeed'].toString(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("km/hr")
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 200,
                                  margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                  padding: EdgeInsets.all(26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            WeatherIcons.humidity,
                                            size: 40,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        weatherData['humidity'].toString(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Percent")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // Show a loading indicator or a message indicating no data
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchWeatherData(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.fetchWeatherData(_cityController.text);
  }
}
