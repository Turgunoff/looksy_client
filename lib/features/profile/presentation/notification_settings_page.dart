import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:looksy_client/features/profile/bloc/settings_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notifications = true;
  bool sound = true;
  bool vibrate = true;
  bool specialOffers = true;
  bool payments = false;
  bool appUpdates = true;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF18a137);

    Widget buildTile(
      String title,
      bool value,
      ValueChanged<bool> onChanged, {
      bool enabled = true,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: enabled ? Colors.black : Colors.grey,
              ),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: mainColor,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_outline, color: Colors.white),
        ),
        title: const Text('Bildirishnoma sozlamalari'),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildTile(
                    'Notifications',
                    notifications,
                    (val) => setState(() => notifications = val),
                  ),
                  buildTile(
                    'Sound',
                    sound,
                    (val) => setState(() => sound = val),
                    enabled: notifications,
                  ),
                  buildTile(
                    'Vibrate',
                    vibrate,
                    (val) => setState(() => vibrate = val),
                    enabled: notifications,
                  ),
                  buildTile(
                    'Special Offers',
                    specialOffers,
                    (val) => setState(() => specialOffers = val),
                    enabled: notifications,
                  ),
                  buildTile(
                    'Payments',
                    payments,
                    (val) => setState(() => payments = val),
                    enabled: notifications,
                  ),
                  buildTile(
                    'App Updates',
                    appUpdates,
                    (val) => setState(() => appUpdates = val),
                    enabled: notifications,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Save logic here
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
