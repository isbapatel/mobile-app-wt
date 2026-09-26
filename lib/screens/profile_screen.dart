import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/app_colors.dart';
import '../widgets/skill_chip.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;

  late String name;
  late String email;
  late String phone;
  late String category;
  late String status;
  late String company;
  late List<String> currentSkills;
  late List<String> aspiredSkills;
  late String linkedin;
  late String github;
  late String leetcode;
  late String photoUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    name = firebaseUser?.displayName ?? "User Name";
    email = firebaseUser?.email ?? "email@example.com";
    phone = firebaseUser?.phoneNumber ?? "+91 1234567890";
    photoUrl = firebaseUser?.photoURL ?? "";

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .get();

    if (doc.exists && mounted) {
      final data = doc.data()!;
      name = data["name"] ?? name;
      email = data["email"] ?? email;
      phone = data["phone"] ?? phone;
      category = data["category"] ?? "Category";
      status = data["status"] ?? "Status";
      company = data["company"] ?? "";
      currentSkills = List<String>.from(data["currentSkills"] ?? []);
      aspiredSkills = List<String>.from(data["aspiredSkills"] ?? []);
      linkedin = data["linkedin"] ?? "";
      github = data["github"] ?? "";
      leetcode = data["leetcode"] ?? "";
      photoUrl = data["photoUrl"] ?? photoUrl;
    } else {
      category = "Category";
      status = "Status";
      company = "";
      currentSkills = [];
      aspiredSkills = [];
      linkedin = "";
      github = "";
      leetcode = "";
    }

    setState(() => loading = false);
  }

  void _showSubmitPopup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title:
            const Text("Thank you!", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Our team will reach out to you shortly"),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            // profile top card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.scaffoldBg,
                    backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child: photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 36)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.email,
                              size: 14, color: AppColors.mutedText),
                          const SizedBox(width: 6),
                          Text(email,
                              style:
                                  const TextStyle(color: AppColors.mutedText)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 14, color: AppColors.mutedText),
                          const SizedBox(width: 6),
                          Text(phone,
                              style:
                                  const TextStyle(color: AppColors.mutedText)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // category
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(category),
                  const SizedBox(height: 10),
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(status),
                  if (company.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text('Organisation Name',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(company),
                  ]
                ],
              ),
            ),

            const SizedBox(height: 12),

            // current skills
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Skills', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(children: currentSkills.map((s) => SkillChip(label: s, onRemove: () {})).toList()),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // aspired skills & profiles
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Aspired Skills', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(children: aspiredSkills.map((s) => SkillChip(label: s, onRemove: () {})).toList()),
                  const SizedBox(height: 18),
                  const Text('Profiles',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),
                  if (linkedin.isNotEmpty) Text("LinkedIn: $linkedin"),
                  if (github.isNotEmpty) Text("GitHub: $github"),
                  if (leetcode.isNotEmpty) Text("LeetCode: $leetcode"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Submit Button
            ElevatedButton(
              onPressed: _showSubmitPopup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white, // TEXT COLOR WHITE
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                    child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
