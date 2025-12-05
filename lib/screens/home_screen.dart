import 'package:blood_link/widgets/request_card.dart';
import 'package:blood_link/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const Color _primaryRed = Color(0xFFA72636);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,

        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primaryRed,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),

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
                    color: _primaryRed,
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

            // Functionalities
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Colors.white,
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
                              GestureDetector(
                                onTap: () {
                                  // Find Donors action
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/find_donor_icon.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Find Donors",
                                      style: TextStyle(
                                        fontFamily: 'Bricolage Grotesque',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  // Donate Blood action
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/donate_blood_icon.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Donate Blood",
                                      style: TextStyle(
                                        fontFamily: 'Bricolage Grotesque',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Gap
                        const SizedBox(width: 10),
                        // Logo
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

            Image.asset('assets/images/campaign.png'),

            // Invisible Box
            const SizedBox(height: 10),

            // Requests
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: const Color.fromARGB(255, 248, 248, 248),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                      // Gap
                      const SizedBox(height: 10),

                      // Request 1
                      RequestCard(
                        name: "Kim Chaewon",
                        donorId: "230233",
                        location: "OM Hospital",
                        distance: "800m",
                        image: "assets/images/pfp.png",
                        onAccept: () {},
                        onDecline: () {},
                        onViewDetails: () {},
                      ),

                      const SizedBox(height: 10),

                      // Request 2
                      RequestCard(
                        name: "Arpana Thapa Magar",
                        donorId: "134559",
                        location: "Himal Hospital",
                        distance: "2.0km",
                        image: "assets/images/pfp2.png",
                        onAccept: () {},
                        onDecline: () {},
                        onViewDetails: () {},
                      ),

                      // Request 3
                      RequestCard(
                        name: "Rabi Gurung",
                        donorId: "126368",
                        location: "HAMS Hospital",
                        distance: "2.3km",
                        image: "assets/images/pfp3.png",
                        onAccept: () {},
                        onDecline: () {},
                        onViewDetails: () {},
                      ),
                    ],
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
