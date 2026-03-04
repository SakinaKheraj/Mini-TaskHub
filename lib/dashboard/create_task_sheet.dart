import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/auth_service.dart';
import '../providers/task_provider.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';

/// The sliding panel for creating or editing tasks.
/// It uses a local state to manage the form before saving to Supabase.
class CreateTaskSheet extends StatefulWidget {
  final Task? task;
  const CreateTaskSheet({super.key, this.task});

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;
  late String _selectedPriority;
  late String _startTime;
  late String _endTime;
  late DateTime _selectedDate;
  bool _isProcessing = false;

  final List<String> _categories = [
    'Education',
    'work',
    'Groceries',
    'Daily Tasks',
  ];
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _times = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if we are editing an existing task
    _nameController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedCategory = widget.task?.category ?? 'Education';
    _selectedPriority = widget.task?.priority ?? 'Low';
    _startTime = widget.task?.startTime ?? '09:00 AM';
    _endTime = widget.task?.endTime ?? '05:00 PM';
    _selectedDate = widget.task?.date != null
        ? DateTime.parse(widget.task!.date!)
        : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF121212) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                isEditing ? "Edit task" : "Create a new task",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 48), // Spacer for centering
            ],
          ).animate().fadeIn().slideY(begin: 0.2),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child:
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          _buildLabel("Task Name", isDarkMode),
                          const SizedBox(height: 12),
                          _buildTextField(
                            _nameController,
                            "Enter task name...",
                            isDarkMode,
                          ),
                          const SizedBox(height: 24),
                          _buildLabel("Category", isDarkMode),
                          const SizedBox(height: 12),
                          _buildCategoryChips(isDarkMode),
                          const SizedBox(height: 24),
                          _buildLabel("Date & Time", isDarkMode),
                          const SizedBox(height: 12),
                          _buildDatePicker(isDarkMode),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Start time", isDarkMode),
                                    const SizedBox(height: 12),
                                    _buildTimeDropdown(
                                      _startTime,
                                      (val) =>
                                          setState(() => _startTime = val!),
                                      isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("End time", isDarkMode),
                                    const SizedBox(height: 12),
                                    _buildTimeDropdown(
                                      _endTime,
                                      (val) => setState(() => _endTime = val!),
                                      isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildLabel("Priority", isDarkMode),
                          const SizedBox(height: 12),
                          _buildPriorityChips(isDarkMode),
                          const SizedBox(height: 24),
                          _buildLabel("Description", isDarkMode),
                          const SizedBox(height: 12),
                          _buildTextField(
                            _descriptionController,
                            "Enter description...",
                            isDarkMode,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 40),
                          _buildSubmitButton(),
                          const SizedBox(height: 40),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOut),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDarkMode) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isDarkMode, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey.shade500),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(bool isDarkMode) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedCategory = cat),
          labelStyle: GoogleFonts.outfit(
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w500,
          ),
          selectedColor: const Color(0xFF8B5CF6),
          backgroundColor: isDarkMode
              ? const Color(0xFF2D2D2D)
              : const Color(0xFFEDE9FE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: BorderSide.none,
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildPriorityChips(bool isDarkMode) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _priorities.map((prio) {
        final isSelected = _selectedPriority == prio;
        return ChoiceChip(
          label: Text(prio),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedPriority = prio),
          labelStyle: GoogleFonts.outfit(
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w500,
          ),
          selectedColor: const Color(0xFF8B5CF6),
          backgroundColor: isDarkMode
              ? const Color(0xFF2D2D2D)
              : const Color(0xFFEDE9FE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide.none,
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker(bool isDarkMode) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_selectedDate.day} ${_getMonth(_selectedDate.month)}, ${_getWeekday(_selectedDate.weekday)}",
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF8B5CF6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDropdown(
    String value,
    ValueChanged<String?> onChanged,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: _times
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: onChanged,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
          dropdownColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8B5CF6)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isEditing = widget.task != null;
    return Center(
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              isEditing ? "Update task" : "Create task",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        )
        .animate(target: _isProcessing ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95))
        .shimmer(duration: 1.seconds);
  }

  void _handleSubmit() async {
    if (_nameController.text.isEmpty || _isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final user = context.read<AuthService>().currentUser;
      if (user != null) {
        final taskProvider = context.read<TaskProvider>();
        if (widget.task != null) {
          await taskProvider.updateTask(
            widget.task!.id!,
            user.id,
            title: _nameController.text,
            description: _descriptionController.text,
            category: _selectedCategory,
            priority: _selectedPriority,
            startTime: _startTime,
            endTime: _endTime,
            date: _selectedDate.toIso8601String(),
          );
        } else {
          await taskProvider.addTask(
            user.id,
            _nameController.text,
            description: _descriptionController.text,
            category: _selectedCategory,
            priority: _selectedPriority,
            startTime: _startTime,
            endTime: _endTime,
            date: _selectedDate.toIso8601String(),
          );
        }
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getWeekday(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }
}
