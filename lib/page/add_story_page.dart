import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_project/provider/add_story/add_story_provider.dart';
import 'package:intermediate_project/provider/add_story/add_story_state.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();
  List<int>? _selectedFileBytes;
  String? _selectedFileName;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onPickImage() async {
    final provider = context.read<AddStoryProvider>();
    final result = await provider.pickImage(context);

    if (result != null) {
      setState(() {
        _selectedFileBytes = result['bytes'];
        _selectedFileName = result['fileName'];
      });
    }
  }

  void _onUpload() async {
    if (_selectedFileBytes == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi deskripsi dan pilih gambar dulu!")),
      );
      return;
    }

    await context.read<AddStoryProvider>().addStory(
      _descriptionController.text,
      _selectedFileBytes!,
      _selectedFileName!,
    );

    // Cek jika sukses, lalu kembali ke halaman list
    // ignore: use_build_context_synchronously
    final state = context.read<AddStoryProvider>().state;
    if (state is AddStorySuccessState) {
      if (mounted) context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Story")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview Gambar
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: _selectedFileBytes != null
                  ? Image.memory(
                      Uint8List.fromList(_selectedFileBytes!),
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Text("No Image Selected")),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _onPickImage,
              icon: const Icon(Icons.image),
              label: const Text("Pilih Gambar"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Tulis deskripsi...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Tombol Kirim
            Consumer<AddStoryProvider>(
              builder: (context, provider, child) {
                if (provider.state is AddStoryLoadingState) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("UPLOAD CERITA"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
