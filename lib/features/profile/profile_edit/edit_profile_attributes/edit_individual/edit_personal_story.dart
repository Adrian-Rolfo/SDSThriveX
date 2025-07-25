import 'package:flutter/material.dart';
import '../../../../../core/models/personal_stories_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditPersonalStoryScreen extends StatefulWidget {
  final PersonalStoriesModel personalStory;

  const MyEditPersonalStoryScreen({super.key, required this.personalStory});

  @override
  State<MyEditPersonalStoryScreen> createState() =>
      _MyEditPersonalStoryScreenState();
}

class _MyEditPersonalStoryScreenState extends State<MyEditPersonalStoryScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.personalStory.title);
    _dateController = TextEditingController(
      text: _formatDateToDDMMYYYY(widget.personalStory.date),
    );
    _descriptionController = TextEditingController(
      text: widget.personalStory.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    TextEditingController controller,
    BuildContext context,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.personalStory.date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        // controller.text = picked.toString().split(" ")[0];
        widget.personalStory.updateDate(picked);
        controller.text = _formatDateToDDMMYYYY(picked);
      });
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    UserProvider userProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Personal Story"),
            content: const Text(
              "Are you sure you want to delete this personal story?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      userProvider.removePersonalStory(widget.personalStory.id);
      Navigator.pop(context);
    }
  }

  Future<void> _confirmChanges(UserProvider userProvider) async {
    await userProvider.updatePersonalStory(widget.personalStory.id, {
      'title': _titleController.text,
      'date': _parseDateFromDDMMYYYY(_dateController.text),
      'description': _descriptionController.text,
    });
    // String title;
    // DateTime date;
    // String description;
    // Save or refresh logic can go here if needed

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes saved")));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Personal Story', context),
          body: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => _confirmDelete(context, userProvider),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              Expanded(child: buildInputFields(context)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _confirmChanges(userProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 42, 157, 143),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Confirm changes?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          const Text("Title:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _titleController,
            onChanged: widget.personalStory.updateTitle,
            decoration: InputDecoration(
              hintText: "Enter project title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Date begun:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: "DD / MM / YYYY",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(_dateController, context),
          ),
          const SizedBox(height: 16),
          const Text("Description:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            onChanged: widget.personalStory.updateDescription,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter a short description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDateToDDMMYYYY(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDateFromDDMMYYYY(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
