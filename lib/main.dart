import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cubits/profile_cubit.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // Required for Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the connection to your Firebase Console
  await Firebase.initializeApp();

  runApp(const CyberBuddyApp());
}

class CyberBuddyApp extends StatelessWidget {
  const CyberBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // Triggers the initial data fetch from Firestore
          create: (context) => ProfileCubit()..loadData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberBuddy',
        theme: ThemeData(
          primaryColor: const Color(0xFF3F51B5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3F51B5),
            primary: const Color(0xFF3F51B5),
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
