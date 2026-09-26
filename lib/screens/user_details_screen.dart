import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/skill_chip.dart';
import '../widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _collegeOrCompany = TextEditingController();
  final TextEditingController _skillInput = TextEditingController();
  final TextEditingController _aspiredSkillInput = TextEditingController();
  final TextEditingController _linkedin = TextEditingController();
  final TextEditingController _leetcode = TextEditingController();
  final TextEditingController _github = TextEditingController();

  List<String> currentSkills = [];
  List<String> aspiredSkills = [];

  String status = 'Student';

  final List<String> availableCategories = [
    'SDE',
    'UI/UX designer',
    'Product Manager',
    'Domain Expert'
  ];
  final List<String> selectedCategories = [];

  final List<String> skillSuggestions = [
    'Python','Python development','Java','C++','C','HTML','CSS','JavaScript','Frontend',
    'React','Node.js','Dart','Flutter','Kotlin','Swift','SQL','NoSQL','Machine Learning',
    'Data Science','AWS','GCP','Azure','DevOps','Docker','Kubernetes','Android','iOS',
    'UI Design','UX Research','Product Management','Testing','Automation','Selenium',
    'Rust','Go','TypeScript'
  ];

  void addSkill(String skill, List<String> list) {
    final s = skill.trim();
    if (s.isEmpty) return;
    if (list.length >= 50) return;
    if (!list.contains(s)) {
      setState(() {
        list.add(s);
      });
    }
  }

  void removeSkill(String skill, List<String> list) {
    setState(() {
      list.remove(skill);
    });
  }

  Future<void> _openCategoryPicker() async {
    final temp = List<String>.from(selectedCategories);
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, setStateModal) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select up to 2 categories', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...availableCategories.map((c) {
                  final checked = temp.contains(c);
                  return CheckboxListTile(
                    value: checked,
                    title: Text(c),
                    onChanged: (v) {
                      setStateModal(() {
                        if (v == true) {
                          if (temp.length < 2) {
                            temp.add(c);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Only 2 allowed')),
                            );
                          }
                        } else {
                          temp.remove(c);
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Done', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      selectedCategories
                        ..clear()
                        ..addAll(temp);
                    });
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _collegeOrCompany.dispose();
    _skillInput.dispose();
    _aspiredSkillInput.dispose();
    _linkedin.dispose();
    _leetcode.dispose();
    _github.dispose();
    super.dispose();
  }

  bool get _canSubmit => _linkedin.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    _linkedin.addListener(() {
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(title: const Text('User details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: _openCategoryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: selectedCategories.isEmpty
                                ? Text('Select up to 2 categories', style: TextStyle(color: AppColors.mutedText))
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: selectedCategories
                                        .map((s) => Chip(backgroundColor: AppColors.chipBg, label: Text(s)))
                                        .toList(),
                                  ),
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Student',
                              groupValue: status,
                              onChanged: (v) => setState(() => status = v!),
                            ),
                            const Text('Student'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Working Professional',
                              groupValue: status,
                              onChanged: (v) => setState(() => status = v!),
                            ),
                            const Expanded(child: Text('Working Professional')),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  InputField(
                    label: status == 'Student' ? 'College' : "Company's Name",
                    hint: status == 'Student' ? 'College' : "Company's Name",
                    controller: _collegeOrCompany,
                  ),

                  const SizedBox(height: 18),
                  const Text('Skills & Focus', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),

                  const Text('Current skills', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                      children: currentSkills
                          .map((s) => SkillChip(label: s, onRemove: () => removeSkill(s, currentSkills)))
                          .toList()),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            final query = textEditingValue.text.toLowerCase();
                            if (query.isEmpty) return const Iterable<String>.empty();
                            return skillSuggestions.where((option) => option.toLowerCase().contains(query));
                          },
                          onSelected: (String selection) {
                            addSkill(selection, currentSkills);
                            _skillInput.clear();
                          },
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            controller.text = _skillInput.text;
                            controller.selection = _skillInput.selection;
                            controller.addListener(() {
                              if (controller.text != _skillInput.text) _skillInput.text = controller.text;
                            });
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              onSubmitted: (value) {
                                addSkill(value, currentSkills);
                                _skillInput.clear();
                              },
                              decoration: InputDecoration(
                                hintText: 'Add skill...',
                                filled: true,
                                fillColor: AppColors.cardBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.inputBorder),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          addSkill(_skillInput.text, currentSkills);
                          _skillInput.clear();
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Text('Aspired skills', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                      children: aspiredSkills
                          .map((s) => SkillChip(label: s, onRemove: () => removeSkill(s, aspiredSkills)))
                          .toList()),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            final query = textEditingValue.text.toLowerCase();
                            if (query.isEmpty) return const Iterable<String>.empty();
                            return skillSuggestions.where((option) => option.toLowerCase().contains(query));
                          },
                          onSelected: (String selection) {
                            addSkill(selection, aspiredSkills);
                            _aspiredSkillInput.clear();
                          },
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            controller.text = _aspiredSkillInput.text;
                            controller.selection = _aspiredSkillInput.selection;
                            controller.addListener(() {
                              if (controller.text != _aspiredSkillInput.text) _aspiredSkillInput.text = controller.text;
                            });
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              onSubmitted: (value) {
                                addSkill(value, aspiredSkills);
                                _aspiredSkillInput.clear();
                              },
                              decoration: InputDecoration(
                                hintText: 'Add skill...',
                                filled: true,
                                fillColor: AppColors.cardBg,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.inputBorder),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          addSkill(_aspiredSkillInput.text, aspiredSkills);
                          _aspiredSkillInput.clear();
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Text('Profile links', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),

                  InputField(label: 'LinkedIn *', hint: 'https://linkedin.com/in/username', controller: _linkedin),
                  const SizedBox(height: 12),
                  InputField(label: 'LeetCode', hint: 'https://leetcode.com/username', controller: _leetcode),
                  const SizedBox(height: 12),
                  InputField(label: 'GitHub', hint: 'https://github.com/username', controller: _github),
                  const SizedBox(height: 20),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canSubmit
                          ? () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
                                "category": selectedCategories.join(', '),
                                "status": status,
                                "college": _collegeOrCompany.text.trim(),
                                "currentSkills": currentSkills,
                                "aspiredSkills": aspiredSkills,
                                "linkedin": _linkedin.text.trim(),
                                "leetcode": _leetcode.text.trim(),
                                "github": _github.text.trim(),
                              }, SetOptions(merge: true));

                              Navigator.pushReplacementNamed(context, '/profile');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit
                              ? AppColors.primaryBlue
                              : AppColors.primaryBlue.withOpacity(0.45),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(height: 6, width: width * 0.5),
          ],
        ),
      ),
    );
  }
}