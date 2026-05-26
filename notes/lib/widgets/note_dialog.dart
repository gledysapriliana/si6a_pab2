import 'dart:convert';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';

class NoteDialog extends StatefulWidget {
  final Note? note; // null jika mode tambah, berisi data jika mode edit

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _imageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Jika mode edit, isi form dengan data yang sudah ada
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _imageBase64 = widget.note!.imageBase64;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar dan konversi ke base64
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pickImageFailed(e.toString()))),
        );
      }
    }
  }

  // Fungsi untuk menyimpan note (tambah atau update)
  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final note = Note(
          id: widget.note?.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageBase64: _imageBase64,
          createdAt: widget.note?.createdAt ?? DateTime.now(),
        );

        if (mounted) {
          Navigator.of(context).pop(note);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.note != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  isEdit ? l10n.editNote : l10n.addNote,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Input Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.titleLabel,
                    hintText: 'Masukkan judul note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.titleEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionLabel,
                    hintText: 'Masukkan deskripsi note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.descriptionEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: _imageBase64 != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(_imageBase64!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.tapToAddImage,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),

                // Tombol hapus gambar jika sudah ada gambar
                if (_imageBase64 != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _imageBase64 = null;
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      l10n.changeImage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Tombol Simpan & Batal
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveNote,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEdit ? l10n.save : l10n.add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
