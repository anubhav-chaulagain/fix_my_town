// mobile_report_issue_screen.dart
import 'dart:io';
import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/features/dashboard/presentation/widgets/map_picker_widget.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileReportIssueScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const MobileReportIssueScreen({super.key, this.initialCategory});

  @override
  ConsumerState<MobileReportIssueScreen> createState() =>
      _MobileReportIssueScreenState();
}

class _MobileReportIssueScreenState
    extends ConsumerState<MobileReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  late String _selectedCategory;
  String _selectedPriority = 'low';
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _categories = [
    'Pothole',
    'Broken Streetlight',
    'Garbage',
    'Water Leakage',
    'Other',
  ];

  static const List<String> _priorities = ['low', 'medium', 'high'];

  LatLng? _coordinates;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.initialCategory != null &&
            _categories.contains(widget.initialCategory)
        ? widget.initialCategory!
        : _categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Image Handling ────────────────────────────────────────────────────────

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This feature requires access to your camera or gallery. Please enable it in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null && _selectedImages.length < 5) {
      setState(() => _selectedImages.add(File(photo.path)));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        final remaining = 5 - _selectedImages.length;
        final toAdd = images.take(remaining).map((x) => File(x.path)).toList();
        setState(() => _selectedImages.addAll(toAdd));
        if (images.length > remaining) {
          _showSnackbar(
            'Only $remaining more image(s) can be added (max 5)',
            isError: true,
          );
        }
      }
    } catch (e) {
      _showSnackbar('Unable to access gallery', isError: true);
    }
  }

  void _showImagePickerSheet() {
    if (_selectedImages.length >= 5) {
      _showSnackbar('Maximum 5 images allowed', isError: true);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF1EA095),
                ),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFF1EA095),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(issuesViewModelProvider.notifier)
        .createIssue(
          title: _titleController.text.trim(),
          category: _selectedCategory,
          location: _locationController.text.trim(),
          latitude: _coordinates?.latitude.toString() ?? '',
          longitude: _coordinates?.longitude.toString() ?? '',
          description: _descriptionController.text.trim(),
          priority: _selectedPriority,
          issueImages: _selectedImages,
        );

    final issuesState = ref.read(issuesViewModelProvider);
    if (!mounted) return;

    if (issuesState.status == IssuesStatus.created) {
      _showSnackbar('Issue reported successfully!');
      _resetForm();
      AppRoutes.pop(context);
    } else if (issuesState.status == IssuesStatus.error) {
      _showSnackbar(
        issuesState.errorMessage ?? 'Failed to report issue',
        isError: true,
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = _categories.first;
      _selectedPriority = 'low';
      _selectedImages.clear();
      _coordinates = null;
      _showMap = false;
    });
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : const Color(0xFF1EA095),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final issuesState = ref.watch(issuesViewModelProvider);
    final isLoading = issuesState.status == IssuesStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Issue',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Info Banner ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1EA095).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1EA095).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF1EA095),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Help improve your town by providing detailed information about the issue.',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF1EA095).withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Title ─────────────────────────────────────────────────
              const _SectionLabel(label: 'Title'),
              const SizedBox(height: 8),
              _InputField(
                controller: _titleController,
                hint: 'e.g. Large pothole blocking lane',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),

              const SizedBox(height: 20),

              // ── Category & Priority ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(label: 'Category'),
                        const SizedBox(height: 8),
                        _DropdownField<String>(
                          value: _selectedCategory,
                          items: _categories,
                          itemLabel: (v) => v,
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(label: 'Priority'),
                        const SizedBox(height: 8),
                        _DropdownField<String>(
                          value: _selectedPriority,
                          items: _priorities,
                          itemLabel: (v) => v[0].toUpperCase() + v.substring(1),
                          onChanged: (v) =>
                              setState(() => _selectedPriority = v!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Location ──────────────────────────────────────────────
              const _SectionLabel(label: 'Location'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      controller: _locationController,
                      hint: 'Enter address or select on map',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Location is required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _showMap = !_showMap),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _showMap
                            ? const Color(0xFF1EA095)
                            : const Color(0xFF1EA095).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        color: _showMap
                            ? Colors.white
                            : const Color(0xFF1EA095),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              if (_coordinates != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      size: 13,
                      color: Color(0xFF1EA095),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_coordinates!.latitude.toStringAsFixed(6)}, ${_coordinates!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1EA095),
                      ),
                    ),
                  ],
                ),
              ],

              if (_showMap) ...[
                const SizedBox(height: 12),
                MapPickerWidget(
                  initialPosition:
                      _coordinates ?? const LatLng(27.7172, 85.3240),
                  onLocationSelected: (lat, lng, address) {
                    setState(() {
                      _coordinates = LatLng(lat, lng);
                      _locationController.text = address;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Location pinned!'),
                        backgroundColor: const Color(0xFF1EA095),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() => _showMap = false),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Hide map',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // ── Description ───────────────────────────────────────────
              const _SectionLabel(label: 'Description'),
              const SizedBox(height: 8),
              _InputField(
                controller: _descriptionController,
                hint: 'Describe the issue in detail...',
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),

              const SizedBox(height: 20),

              // ── Images ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel(label: 'Photos'),
                  Text(
                    '${_selectedImages.length}/5',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _showImagePickerSheet,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1EA095).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1EA095).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Color(0xFF1EA095),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to add photos',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PNG, JPG up to 10MB (max 5)',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),

              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImages[index],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // ── Submit Button ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1EA095),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(
                      0xFF1EA095,
                    ).withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1EA095), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF94A3B8),
            size: 20,
          ),
          style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
