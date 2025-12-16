import 'package:blood_link/common/request_card.dart';
import 'package:blood_link/models/request_model.dart';
import 'package:blood_link/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<BloodRequest> requests = const [
    BloodRequest(
      name: "Kim Chaewon",
      donorId: "230233",
      location: "OM Hospital",
      distance: "800m",
      image: "assets/images/pfp.png",
    ),
    BloodRequest(
      name: "Arpana Thapa Magar",
      donorId: "134559",
      location: "Himal Hospital",
      distance: "2.0km",
      image: "assets/images/pfp2.png",
    ),
    BloodRequest(
      name: "Rabi Gurung",
      donorId: "126368",
      location: "HAMS Hospital",
      distance: "2.3km",
      image: "assets/images/pfp3.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, // allow card to overflow
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFA72636),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),

              const Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: StatusCard(),
              ),
            ],
          ),

          const SizedBox(height: 20),

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
                                  const Icon(Icons.arrow_forward_ios, size: 15),
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
                                  const Icon(Icons.arrow_forward_ios, size: 15),
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

                    // Requests List View
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return RequestCard(
                          name: request.name,
                          donorId: request.donorId,
                          location: request.location,
                          distance: request.distance,
                          image: request.image,
                          onAccept: () {},
                          onDecline: () {},
                          onViewDetails: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
