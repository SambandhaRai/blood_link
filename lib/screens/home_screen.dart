import 'package:blood_link/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // allow card to overflow
              children: [
                // Header
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA72636),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Stack(
                              children: const [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    'S',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.lightGreenAccent,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Hi, Sambandha",
                              style: TextStyle(
                                fontFamily: 'Bricolage Grotesque',
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.access_time,
                                size: 36,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                size: 36,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlapping StatusCard
                const Positioned(
                  top: 170,
                  left: 10,
                  right: 10,
                  child: StatusCard(),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Red container below everything
            // Functionalities
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/find_donor_icon.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Find Donors",
                                    style: TextStyle(
                                      fontFamily: 'Bricolage Grotesque',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(), // pushes arrow close to text instead of far right
                                  const Icon(Icons.arrow_forward_ios, size: 15),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/donate_blood_icon.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Donate Blood",
                                    style: TextStyle(
                                      fontFamily: 'Bricolage Grotesque',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios, size: 15),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Gap
                        SizedBox(width: 10),
                        // Optional logo
                        Image.asset(
                          'assets/images/small_logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Requests
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Requests",
                              style: TextStyle(
                                fontFamily: 'Bricolage Grotesque',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
