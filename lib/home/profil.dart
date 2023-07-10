import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moj_prevoz/main.dart';

import '../widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ProfileWidget(
              defaultImagePath: 'assets/images/default-user-image.png',
              onClicked: () async {},
            ),
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(User? user) => Column(
        children: [
          Text(
            'Никола Николовски', //user?.displayName ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 14),
          Text(
            user?.email ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      );

  Widget buildAbout(User? user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.phone,
                  color: myColor,
                ),
                title: const Text(
                  "Телефонски број",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "071123456", //user?.phoneNumber ?? '',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: myColor,
                ),
                title: const Text(
                  "За мене",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Често патувам на релација Скопје-Прилеп.",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.lock_open,
                size: 25,
              ),
              label: const Text(
                'Одјави се',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      );
}
