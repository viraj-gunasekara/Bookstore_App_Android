import 'package:bookstore_admin_app/containers/dashboard_text.dart';
import 'package:bookstore_admin_app/containers/home_button.dart';
import 'package:bookstore_admin_app/controlllers/auth_service.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 235,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardText(keyword: "Total Books", value: "100"),
                  DashboardText(keyword: "Total Books", value: "100"),
                  DashboardText(keyword: "Total Books", value: "100"),
                  DashboardText(keyword: "Total Books", value: "100"),
                  DashboardText(keyword: "Total Books", value: "100"),
                ],
              ),
            ),
            //Buttons for admin
            Row(
              children: [
                HomeButton(onTap: () {}, name: "All Orders"),
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/books");
                  },
                  name: "All Books",
                ),
              ],
            ),
            Row(
              children: [
                HomeButton(onTap: () {
                  Navigator.pushNamed(context, "/promos", arguments: {"promo":true});
                }, name: "Promos"),
                HomeButton(onTap: () {
                  Navigator.pushNamed(context, "/promos", arguments: {"promo":false});
                }, name: "Banners"),
              ],
            ),
            Row(
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/category");
                  },
                  name: "Categories",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
