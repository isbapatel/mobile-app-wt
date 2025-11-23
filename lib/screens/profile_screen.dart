import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/skill_chip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final name = args?['name'] ?? 'User Name';
    final email = args?['email'] ?? 'email@example.com';
    final phone = args?['phone'] ?? '+91 1234567890';
    final category = args?['category'] ?? 'Category';
    final status = args?['status'] ?? 'Status';
    final company = args?['company'] ?? '';
    final List<String> currentSkills = List<String>.from(args?['currentSkills'] ?? []);
    final List<String> aspiredSkills = List<String>.from(args?['aspiredSkills'] ?? []);
    final linkedin = args?['linkedin'] ?? '';
    final leetcode = args?['leetcode'] ?? '';
    final github = args?['github'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            // Top profile card
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
                    child: const Icon(Icons.person, size: 36),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 14, color: AppColors.mutedText),
                          const SizedBox(width: 6),
                          Text(email, style: const TextStyle(color: AppColors.mutedText)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 14, color: AppColors.mutedText),
                          const SizedBox(width: 6),
                          Text(phone, style: const TextStyle(color: AppColors.mutedText)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Category + status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(category),
                const SizedBox(height: 10),
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(status),
                if (company.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text('Organisation Name', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(company),
                ]
              ]),
            ),

            const SizedBox(height: 12),

            // Current skills
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Current Skills', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(children: currentSkills.map((s) => SkillChip(label: s, onRemove: () {})).toList()),
              ]),
            ),

            const SizedBox(height: 12),

            // Aspired skills + profile links
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Aspired Skills', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(children: aspiredSkills.map((s) => SkillChip(label: s, onRemove: () {})).toList()),

                const SizedBox(height: 18),
                const Text('Profiles', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 10),

                // LinkedIn (always show)
                const Text('LinkedIn', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  linkedin,
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
                const SizedBox(height: 12),

                // GitHub (show only if given)
                if (github.isNotEmpty) ...[
                  const Text('Github', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    github,
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 12),
                ],

                // LeetCode (show only if given)
                if (leetcode.isNotEmpty) ...[
                  const Text('Leetcode', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    leetcode,
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 12),
                ],
              ]),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(child: Text('Join the Call')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
