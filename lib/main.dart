import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'models/activity_model.dart';
import 'widgets/activity_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LastTime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Segoe UI',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data aktivitas sesuai desain
    final activities = [
      ActivityModel(
        title: 'Potong Rambut',
        lastDate: '12 Mar 2025',
        daysAgo: '18 hari yang lalu',
        iconColor: AppColors.haircut,
        icon: Icons.cut,
        status: 'Selesai',
      ),
      ActivityModel(
        title: 'Ganti Oli Motor',
        lastDate: '1 Feb 2025',
        daysAgo: '57 hari yang lalu',
        iconColor: AppColors.motor,
        icon: Icons.build,
        status: 'Selesai',
      ),
      ActivityModel(
        title: 'Bersihkan Kamar',
        lastDate: '25 Mar 2025',
        daysAgo: '5 hari yang lalu',
        iconColor: AppColors.cleaning,
        icon: Icons.cleaning_services,
        status: 'Selesai',
      ),
      ActivityModel(
        title: 'Cuci Baju',
        lastDate: '28 Mar 2025',
        daysAgo: '2 hari yang lalu',
        iconColor: AppColors.laundry,
        icon: Icons.local_laundry_service,
        status: 'Selesai',
      ),
      ActivityModel(
        title: 'Bayar Tagihan',
        lastDate: 'Belum pernah dilakukan',
        daysAgo: 'Belum dicatat',
        iconColor: AppColors.bill,
        icon: Icons.payments,
        status: 'Selesai',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'LastTime',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pantau aktivitas rutinmu',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),

              // Section Title dengan tombol +
              Row(
                children: [
                  const Text(
                    'AKTIVITAS SAYA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List Activities
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return ActivityCard(activity: activities[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}