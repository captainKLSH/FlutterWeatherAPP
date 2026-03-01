import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/provider/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});
  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  void _fetchWeather() {
    ref.read(weatherProvider.notifier).fetchWeather(_cityController.text);
    // Implement weather fetching logic here
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    // screen dimensions
    final screenWidth= MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth>600;
    final bool isDesktop= screenWidth>1200;

    // responsive padding


    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          'Weather APP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 28: (isTablet? 26: 24)),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
        toolbarHeight: isDesktop? 70 :(isTablet? 65:56),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop? 1200 : double.infinity
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ), // Container decoration
                  child: Column(
                    children: [
                      Text(
                        'Enter City Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.blue[500]!,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.blue[600]!,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          hintText: 'Pittsburgh, New York, San Francisco, etc',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _fetchWeather,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                if (weatherState.isLoading)
                  CircularProgressIndicator()
                else if (weatherState.errorMessage!.isNotEmpty)
                  Text(
                    weatherState.errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (weatherState.weather != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width * 0.98,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 119, 164, 244),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _cityController.text.toUpperCase(),
                          
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Temp: ${weatherState.weather!.main.temp} °C || Feels like: ${weatherState.weather!.main.feelsLike}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:  Colors.white,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          '${weatherState.weather!.condition.main} - ${weatherState.weather!.condition.description}',
                          style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 42, 104, 135)),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 24),
                if(weatherState.weather != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 254, 251),
                      borderRadius: BorderRadius.circular(17), 
                      boxShadow: [ BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                    ),]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weather Details:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 99, 64)),),
                      Text('City: ${_cityController.text}, ${weatherState.weather!.country}',),
                      SizedBox(height: 12,),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _buildCard(
                            icon: Icons.thermostat,
                            title: 'Min Temp',
                            value: '${weatherState.weather!.main.tempMin}',
                            color: const Color.fromARGB(255, 150, 185, 236)
                          ),
                          _buildCard(icon: Icons.thermostat_outlined, title: 'Max Temp', value: '${weatherState.weather!.main.tempMax}', color: const Color.fromARGB(255, 252, 160, 160)),
                          _buildCard(icon: Icons.speed, title: 'Pressure', value: '${weatherState.weather!.main.pressure}', color: const Color.fromARGB(255, 236, 145, 242)),
                          _buildCard(icon: Icons.water_drop, title: 'Humidity', value: '${weatherState.weather!.main.humidity}', color: const Color.fromARGB(255, 134, 209, 224)),
                          _buildCard(icon: Icons.cloud, title: 'Condition', value: '${weatherState.weather!.condition.main}', color: const Color.fromARGB(255, 194, 230, 102)),
                          _buildCard(icon: Icons.favorite, title: 'Feels Like', value: '${weatherState.weather!.main.feelsLike}', color: const Color.fromARGB(255, 211, 107, 255))
                        ],),
                    ],
          
          
                  ),),
                  
              ]
            ),
          ),
        ),
      ),
    ); 
  }
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }){
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color,size: 20,),
          SizedBox(height: 4,),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4,),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),

    );
  }
}
