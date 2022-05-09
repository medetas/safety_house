import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safety_house/constants/colors.dart';
import 'package:safety_house/models/profile.dart';

class HomeScreen extends StatelessWidget {
  final ProfileModel userInfo;
  const HomeScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(43.2338916 - 0.05, 76.9541347),
            zoom: 11.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
                markers: userInfo.houses
                    .map(
                      (house) => Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                            double.parse(house.lat!), double.parse(house.let!)),
                        builder: (ctx) =>
                            Image.asset('assets/icons/home-green.png'),
                      ),
                    )
                    .toList()),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  offset: Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ...userInfo.houses.map(
                        (house) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/house.png')),
                              SizedBox(height: 10),
                              Text(
                                '${house.address}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            CircleBorder(),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 48,
                              color: Colors.white,
                            ),
                            Text(
                              'Добавить новый дом',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
