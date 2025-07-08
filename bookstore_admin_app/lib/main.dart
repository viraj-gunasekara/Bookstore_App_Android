import 'package:bookstore_admin_app/controlllers/auth_service.dart';
import 'package:bookstore_admin_app/providers/admin_provider.dart';
import 'package:bookstore_admin_app/views/admin_home.dart';
import 'package:bookstore_admin_app/views/books_page.dart';
import 'package:bookstore_admin_app/views/categories_page.dart';
import 'package:bookstore_admin_app/views/login.dart';
import 'package:bookstore_admin_app/views/modify_book.dart';
import 'package:bookstore_admin_app/views/modify_promo.dart';
import 'package:bookstore_admin_app/views/promo_banners_page.dart';
import 'package:bookstore_admin_app/views/signup.dart';
import 'package:bookstore_admin_app/views/view_book.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Bookstore Admin App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade900),
        ),
        routes: {
          "/": (context) => CheckUser(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SignupPage(),
          "/home": (context) => AdminHome(),
          "/category": (context) => CategoriesPage(),
          "/books": (context) => BooksPage(),
          "/add_book": (context) => ModifyBook(),
          "/view_book": (context) => ViewBook(),
          "/promos": (context) => PromoBannersPage(),
          "/update_promo": (context) => ModifyPromo(),
        },
      ),
    );
  }
}

//check user state - loggedin/or not
class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
