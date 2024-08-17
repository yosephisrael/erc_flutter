import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:erbs/Users/homePage.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<List<DocumentSnapshot>> _groupedNotifications;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _groupedNotifications = [];
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // Remove default back button
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 65), // Adjust the width as needed
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3F7347),
              ),
            )
          : _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    if (_groupedNotifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications found',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 20,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _groupedNotifications.length,
        itemBuilder: (context, index) {
          List<DocumentSnapshot> notifications = _groupedNotifications[index];
          if (notifications.isEmpty) {
            return const SizedBox.shrink(); // Skip rendering for empty groups
          }
          String date = _getDateLabel(notifications[0]['timestamp'].toDate());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Column(
                children: notifications.map((notification) {
                  return _buildNotificationCard(
                    notification.id,
                    notification['title'],
                    notification['body'],
                    notification['timestamp'].toDate(),
                    notification['isMarked'],
                  );
                }).toList(),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildNotificationCard(
    String id,
    String title,
    String body,
    DateTime timeStamp,
    bool isMarked,
  ) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final String formattedTime = timeFormat.format(timeStamp);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (!isMarked)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.done_all, color: Colors.green.shade700),
                      onPressed: () {
                        _toggleMarkAsRead(id, !isMarked);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade700),
                      onPressed: () {
                        _deleteNotification(id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: SelectableText(body),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Text(formattedTime),
          ),
        ],
      ),
    );
  }

  void _fetchNotifications() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      QuerySnapshot notificationSnapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(user!.uid)
          .collection('notify')
          .orderBy('timestamp', descending: true)
          .get();

      Map<String, List<DocumentSnapshot>> groupedByDate = {};

      for (var notification in notificationSnapshot.docs) {
        DateTime timeStamp = notification['timestamp'].toDate();
        String date = _getDateLabel(timeStamp);

        if (!groupedByDate.containsKey(date)) {
          groupedByDate[date] = [];
        }

        groupedByDate[date]!.add(notification);
      }

      // Filter out empty groups
      List<List<DocumentSnapshot>> groupedNotifications =
          groupedByDate.values.where((group) => group.isNotEmpty).toList();

      setState(() {
        _groupedNotifications = groupedNotifications;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching notifications: $error');
    }
  }

  void _toggleMarkAsRead(String id, bool newValue) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(user!.uid)
          .collection('notify')
          .doc(id)
          .update({'isMarked': newValue});

      // Fetch the updated document snapshot
      DocumentSnapshot updatedNotification = await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(user.uid)
          .collection('notify')
          .doc(id)
          .get();

      setState(() {
        for (var group in _groupedNotifications) {
          for (var notification in group) {
            if (notification.id == id) {
              // Replace the old notification with the updated one
              group[group.indexOf(notification)] = updatedNotification;
            }
          }
        }
      });
    } catch (error) {
      print('Error toggling mark as read: $error');
    }
  }

  void _deleteNotification(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(user!.uid)
          .collection('notify')
          .doc(id)
          .delete();

      setState(() {
        _groupedNotifications.forEach((group) {
          group.removeWhere((notification) => notification.id == id);
        });
      });
    } catch (error) {
      print('Error deleting notification: $error');
    }
  }

  String _getDateLabel(DateTime date) {
    return DateFormat('E, MMM d').format(date);
  }
}
