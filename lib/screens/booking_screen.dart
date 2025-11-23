import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  int? _selectedSlotIndex;
  final TextEditingController _phoneController = TextEditingController();

  final List<String> _slots = const ['09:30 AM', '10:00 PM'];

  @override
  void initState() {
    super.initState();
    // Rebuild when phone text changes so _canBook updates and button enables
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool get _canBook =>
      _selectedDate != null && _selectedSlotIndex != null && _phoneController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _selectedDate == null
        ? 'Pick a Date'
        : DateFormat('MMMM d, yyyy').format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date and Slot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date field
            const Text(
              'Select Date',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black87),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        dateLabel,
                        style: TextStyle(
                          color: _selectedDate == null ? AppColors.mutedText : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Select Time Slot',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_slots.length, (index) {
                final isSelected = _selectedSlotIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSlotIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: index == 0 ? 12 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryBlue : AppColors.inputBorder,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _slots[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),
            const Text(
              'Contact number',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your contact number',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canBook
                    ? () {
                        // After booking, go directly to user details screen
                        Navigator.pushReplacementNamed(context, '/userDetails', arguments: {
                          'date': _selectedDate,
                          'slot': _selectedSlotIndex != null ? _slots[_selectedSlotIndex!] : null,
                          'phone': _phoneController.text.trim(),
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _canBook ? AppColors.primaryBlue : AppColors.primaryBlue.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Book a Slot',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
