
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/home_screen.dart';

class NayaScreen extends StatelessWidget {
  NayaScreen({super.key});
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Workshop"),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: _cityController,
            decoration:const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Location',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              /* Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              )); */
              Get.to(() => HomeScreen(
                cityName: _cityController.text,
              ));
            },
            child: const Text("Check Weather"),
          ),
        ],
      )),
    );
  }
}
