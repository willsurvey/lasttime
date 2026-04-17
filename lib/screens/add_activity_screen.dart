import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/storage_service.dart';
import '../models/activity_model.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // Controllers untuk input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  // State untuk pilihan
  String? _selectedEmoji;
  DateTime? _selectedDate;

  // Daftar emoji sesuai desain
  final List<Map<String, dynamic>> _emojis = [
    {'emoji': '✂️', 'label': 'Potong Rambut'},
    {'emoji': '🔧', 'label': 'Servis'},
    {'emoji': '🧹', 'label': 'Bersihkan'},
    {'emoji': '🏃', 'label': 'Olahraga'},
    {'emoji': '💊', 'label': 'Obat'},
    {'emoji': '📚', 'label': 'Belajar'},
    {'emoji': '🚿', 'label': 'Mandi'},
    {'emoji': '💳', 'label': 'Tagihan'},
    {'emoji': '🌿', 'label': 'Tanaman'},
    {'emoji': '🐾', 'label': 'Hewan'},
    {'emoji': '🚗', 'label': 'Mobil'},
    {'emoji': '🎯', 'label': 'Target'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Fungsi pilih tanggal
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(  // ✅ FIX: Tambahkan `data:`
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Helper: Mapping emoji ke warna
  Color _getEmojiColor(String emoji) {
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
  IconData _getEmojiIcon(String emoji) {
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

  // Fungsi simpan
  Future<void> _saveActivity() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nama aktivitas harus diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih ikon/emoji terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Buat ActivityModel dari input form
    final newActivity = ActivityModel(
      title: _nameController.text.trim(),
      lastDate: _selectedDate != null 
          ? '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} ${_selectedDate!.year}'
          : 'Baru ditambahkan',
      daysAgo: 'Baru ditambahkan',
      iconColor: _getEmojiColor(_selectedEmoji!),
      icon: _getEmojiIcon(_selectedEmoji!),
      status: 'Selesai',
    );

    try {
      // Simpan ke SharedPreferences HANYA di sini
      await StorageService.addActivity(newActivity);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Aktivitas berhasil disimpan!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      if (mounted) {
        Navigator.pop(context, {
          'name': _nameController.text.trim(),
          'emoji': _selectedEmoji,
          'note': _noteController.text.trim(),
          'date': _selectedDate ?? DateTime.now(),
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Tambah Aktivitas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Section: PILIH IKON / EMOJI
                const Text(
                  'PILIH IKON / EMOJI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      final item = _emojis[index];
                      final isSelected = _selectedEmoji == item['emoji'];
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmoji = item['emoji'];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            item['emoji'],
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Section: NAMA AKTIVITAS
                const Text(
                  'NAMA AKTIVITAS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Potong Rambut',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: AppColors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contoh: Potong rambut, Ganti oli, Olahraga',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),

                // Section: CATATAN (OPSIONAL)
                const Text(
                  'CATATAN (OPSIONAL)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: AppColors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 24),

                // Section: TANGGAL TERAKHIR DILAKUKAN
                const Text(
                  'TANGGAL TERAKHIR DILAKUKAN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Pilih tanggal (opsional)',
                          style: TextStyle(
                            color: _selectedDate != null
                                ? AppColors.textPrimary
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons: Simpan & Batal
                Row(
                  children: [
                    // Tombol Batal (1/3 lebar)
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 40 - 12) / 3,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Simpan (2/3 lebar)
                    SizedBox(
                      width: ((MediaQuery.of(context).size.width - 40 - 12) / 3) * 2,
                      child: ElevatedButton(
                        onPressed: _saveActivity,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Simpan Aktivitas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}