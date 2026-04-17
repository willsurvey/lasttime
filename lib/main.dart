import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'models/activity_model.dart';
import 'widgets/activity_card.dart';
import 'screens/add_activity_screen.dart';
import 'services/storage_service.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ActivityModel> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivitiesFromStorage();
  }

  Future<void> _loadActivitiesFromStorage() async {
    final loadedActivities = await StorageService.loadActivities();
    
    if (mounted) {
      setState(() {
        // ✅ FIX: Tidak ada data dummy — jika kosong, tampilkan empty state
        activities = loadedActivities;
      });
    }
  }

  // ✅ FIX: Hanya reload data dari storage, JANGAN simpan lagi (sudah disimpan di AddActivityScreen)
  Future<void> _addNewActivity(Map<String, dynamic> newData) async {
    // Reload data dari storage (karena sudah disimpan di AddActivityScreen)
    final updatedActivities = await StorageService.loadActivities();
    
    if (mounted) {
      setState(() {
        activities = updatedActivities;
      });
    }
  }

  // Helper: Mapping emoji ke warna
  Color _getEmojiColor(String? emoji) {
    switch (emoji) {
      case '✂️': return AppColors.haircut;
      case '🔧': return AppColors.motor;
      case '🧹': return AppColors.cleaning;
      case '🏃': return AppColors.laundry;
      case '💊': return AppColors.bill;
      case '📚': return AppColors.haircut;
      case '🚿': return AppColors.laundry;
      case '💳': return AppColors.bill;
      case '🌿': return AppColors.cleaning;
      case '🐾': return AppColors.motor;
      case '🚗': return AppColors.motor;
      case '🎯': return AppColors.bill;
      default: return AppColors.haircut;
    }
  }

  // Helper: Mapping emoji ke IconData
  IconData _getEmojiIcon(String? emoji) {
    switch (emoji) {
      case '✂️': return Icons.cut;
      case '🔧': return Icons.build;
      case '🧹': return Icons.cleaning_services;
      case '🏃': return Icons.directions_run;
      case '💊': return Icons.medication;
      case '📚': return Icons.school;
      case '🚿': return Icons.shower;
      case '💳': return Icons.payments;
      case '🌿': return Icons.eco;
      case '🐾': return Icons.pets;
      case '🚗': return Icons.directions_car;
      case '🎯': return Icons.flag;
      default: return Icons.star;
    }
  }

  // Helper: Nama bulan
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
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
                  
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddActivityScreen(),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        _addNewActivity(result);
                      }
                    },
                    child: Container(
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ✅ FIX: Empty state jika belum ada aktivitas
              Expanded(
                child: activities.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada aktivitas.\nKlik + untuk menambah.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
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