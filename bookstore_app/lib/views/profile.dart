import 'package:bookstore_app/controlllers/auth_service.dart';
import 'package:bookstore_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          Consumer<UserProvider>(
            builder: (context, value, child) =>
            Card(
              child: ListTile(
                title: Text(value.name),
                subtitle: Text(value.email),
                onTap: () {
                  Navigator.pushNamed(context, "/update_profile");
                },
                trailing: Icon(Icons.manage_accounts_outlined),
              ),
            ),
          ),
          SizedBox(height: 20,),
      ListTile(title: Text("Orders"), leading: Icon(Icons.local_shipping_outlined), onTap: (){
        

      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
      ListTile(title: Text("Discount & Offers"), leading: Icon(Icons.discount_outlined), onTap: (){
       
      },),
      Divider( thickness: 1,  endIndent:  10, indent: 10,),
      ListTile(title: Text("Help & Support"), leading: Icon(Icons.support_agent), onTap: (){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mail us at thebookstore@gmail.com")));
      },),
          Divider( thickness: 1,  endIndent:  10, indent: 10,),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout_outlined),
            onTap: () async {
              await AuthService().logout();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => true);
            },
          ),
        ],
      ),
    );
  }
}
