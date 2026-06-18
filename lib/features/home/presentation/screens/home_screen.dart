import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/core/constants/app_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 175, 51, 6),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
      ),
      body:GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  // 1. خلى العدد الإجمالي بيساوي طول القائمة بالظبط
  itemCount:AppImages.perfumeImages.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // صورتين في السطر
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.8,
  ),
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          // 2. السحر هنا: كل كارت هياخد الصورة اللي عليها الدور في الـ index
          image: AssetImage(AppImages.perfumeImages[index]), 
        ),
      ),
    );
  },
)
    );
  }
}
