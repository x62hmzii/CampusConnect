import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:campusconnect/data/models/note_model.dart';
import 'package:campusconnect/data/repositories/note_repository_impl.dart';
import 'package:campusconnect/data/datasources/note_local_datasource.dart';
import 'package:campusconnect/presentation/pages/pdf_viewer_screen.dart';

class NotesFragment extends StatefulWidget {
  const NotesFragment({Key? key}) : super(key: key);

  @override
  State<NotesFragment> createState() => _NotesFragmentState();
}

class _NotesFragmentState extends State<NotesFragment> {
  final NoteRepository noteRepository = NoteRepository(
    localDataSource: NoteLocalDataSource(),
  );

  // Sample data for dropdowns
  final List<String> degrees = ['SE', 'BCS', 'BBA'];
  final List<String> departments = ['CS', 'IT', 'CE', 'ME'];
  final List<String> semesters = ['Semester 1', '2', '3', '4','5','6','7','8'];
  final Map<String, List<String>> subjects = {
    'CS': ['Flutter', 'Data Structures', 'DBMS', 'OS'],
    'IT': ['Web dev', 'Python', 'Java', 'Networking'],
    'CE': ['Electronics', 'Circuits', 'Signals'],
    'ME': ['Mechanics', 'Thermodynamics', 'CAD'],
  };

  // Selected values for filters
  String? selectedDegree;
  String? selectedDepartment;
  String? selectedSemester;
  String? selectedSubject;

  // For upload dialog
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  PlatformFile? selectedFile;
  String? selectedUploadDegree;
  String? selectedUploadDepartment;
  String? selectedUploadSemester;
  String? selectedUploadSubject;

  List<NoteModel> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      isLoading = true;
    });

    final filteredNotes = await noteRepository.getFilteredNotes(
      degree: selectedDegree,
      department: selectedDepartment,
      semester: selectedSemester,
      subject: selectedSubject,
    );

    setState(() {
      notes = filteredNotes;
      isLoading = false;
    });
  }

  /// Fixed file picker with proper permissions
  Future<void> _pickFile() async {
    try {
      // Request appropriate permissions based on Android version
      Map<Permission, PermissionStatus> permissions = {};

      if (Platform.isAndroid) {
        // For Android 13+ (API 33+)
        if (await Permission.manageExternalStorage.isDenied) {
          permissions[Permission.manageExternalStorage] = await Permission.manageExternalStorage.request();
        }

        // Fallback permissions for older Android versions
        permissions[Permission.storage] = await Permission.storage.request();

        // Also request media permissions for Android 13+
        permissions[Permission.photos] = await Permission.photos.request();
        permissions[Permission.videos] = await Permission.videos.request();
        permissions[Permission.audio] = await Permission.audio.request();
      }

      // Check if any required permission is granted
      bool hasPermission = permissions.values.any((status) => status.isGranted) ||
          await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted;

      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      // Hide loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (mounted) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  /// Show permission dialog with instructions
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'This app needs storage permission to access files. Please grant permission in the next dialog or go to Settings > Apps > Campus Connect > Permissions to enable storage access.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Open app settings
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadNote() async {
    if (selectedFile == null ||
        titleController.text.isEmpty ||
        selectedUploadDegree == null ||
        selectedUploadDepartment == null ||
        selectedUploadSemester == null ||
        selectedUploadSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a file')),
      );
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Uploading...'),
              ],
            ),
          );
        },
      );

      // Save file to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final savedFile = File('${appDir.path}/${selectedFile!.name}');

      if (selectedFile!.bytes != null) {
        await savedFile.writeAsBytes(selectedFile!.bytes!);
      } else if (selectedFile!.path != null) {
        final originalFile = File(selectedFile!.path!);
        await originalFile.copy(savedFile.path);
      }

      final newNote = NoteModel(
        title: titleController.text,
        description: descriptionController.text,
        filePath: savedFile.path,
        fileName: selectedFile!.name,
        fileType: selectedFile!.extension ?? 'unknown',
        degree: selectedUploadDegree!,
        department: selectedUploadDepartment!,
        semester: selectedUploadSemester!,
        subject: selectedUploadSubject!,
        uploadDate: DateTime.now(),
        uploadedBy: 'Current User',
      );

      await noteRepository.addNote(newNote);
      await _loadNotes();

      // Hide loading
      Navigator.of(context).pop();

      // Reset form
      titleController.clear();
      descriptionController.clear();
      setState(() {
        selectedFile = null;
        selectedUploadDegree = null;
        selectedUploadDepartment = null;
        selectedUploadSemester = null;
        selectedUploadSubject = null;
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note uploaded successfully')),
      );
    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Upload Notes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sourgammy',
                            color: Color(0xFF187fc4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedUploadDegree,
                          hint: const Text('Select Degree *'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: degrees.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              selectedUploadDegree = newValue;
                              selectedUploadDepartment = null;
                              selectedUploadSubject = null;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedUploadDepartment,
                          hint: const Text('Select Department *'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: selectedUploadDegree != null
                              ? departments.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                              : null,
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              selectedUploadDepartment = newValue;
                              selectedUploadSubject = null;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedUploadSemester,
                          hint: const Text('Select Semester *'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: semesters.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              selectedUploadSemester = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedUploadSubject,
                          hint: const Text('Select Subject *'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: (selectedUploadDepartment != null &&
                              subjects.containsKey(selectedUploadDepartment))
                              ? subjects[selectedUploadDepartment]!.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                              : null,
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              selectedUploadSubject = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _pickFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF187fc4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Text(
                            selectedFile != null
                                ? 'Selected: ${selectedFile!.name}'
                                : 'Select File (PDF/DOC) *',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        if (selectedFile != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'File size: ${(selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _uploadNote,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF187fc4),
                              ),
                              child: const Text(
                                'Upload',
                                style: TextStyle(color: Colors.white),
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
          },
        );
      },
    );
  }

  /// Fixed PDF viewer with loading state
  void _viewNote(NoteModel note) {
    if (note.fileType.toLowerCase() == 'pdf') {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Loading PDF...'),
              ],
            ),
          );
        },
      );

      // Check if file exists
      final file = File(note.filePath);
      if (file.existsSync()) {
        Navigator.of(context).pop(); // Hide loading

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(
              filePath: note.filePath,
              fileName: note.fileName,
            ),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Hide loading

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File not found or has been moved')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File type not supported for viewing')),
      );
    }
  }

  void _showNoteDetails(NoteModel note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Keep PDF headings default, only apply font to UI elements
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF187fc4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Description:', note.description),
                    _buildDetailRow('Degree:', note.degree),
                    _buildDetailRow('Department:', note.department),
                    _buildDetailRow('Semester:', note.semester),
                    _buildDetailRow('Subject:', note.subject),
                    _buildDetailRow('File:', note.fileName),
                    _buildDetailRow('Uploaded:', note.uploadDate.toString().split(' ')[0]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _viewNote(note),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF187fc4),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Show confirmation dialog
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Note'),
                                  content: const Text('Are you sure you want to delete this note?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await noteRepository.deleteNote(note.id);
                              _loadNotes();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Note deleted')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Sourgammy', // Apply font to UI labels
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              style: const TextStyle(
                fontFamily: 'Sourgammy', // Apply font to UI content
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontFamily: 'Sourgammy',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF187fc4),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Section with smaller font sizes
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12), // Reduced margin to fit better
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12), // Reduced padding
                child: Column(
                  children: [
                    const Text(
                      'Filter Notes',
                      style: TextStyle(
                        fontSize: 16, // Reduced from 18
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sourgammy',
                        color: Color(0xFF187fc4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Degree and Department Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDegree,
                            hint: const Text(
                              'Degree',
                              style: TextStyle(
                                fontSize: 12, // Smaller font
                                fontFamily: 'Sourgammy',
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12, // Smaller font
                              fontFamily: 'Sourgammy',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              isDense: true,
                            ),
                            items: degrees.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 12, // Smaller font
                                    fontFamily: 'Sourgammy',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDegree = newValue;
                                selectedDepartment = null;
                                selectedSubject = null;
                              });
                              _loadNotes();
                            },
                          ),
                        ),
                        const SizedBox(width: 6), // Reduced spacing
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDepartment,
                            hint: const Text(
                              'Department',
                              style: TextStyle(
                                fontSize: 12, // Smaller font
                                fontFamily: 'Sourgammy',
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12, // Smaller font
                              fontFamily: 'Sourgammy',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              isDense: true,
                            ),
                            items: selectedDegree != null
                                ? departments.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 12, // Smaller font
                                    fontFamily: 'Sourgammy',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList()
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartment = newValue;
                                selectedSubject = null;
                              });
                              _loadNotes();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Reduced spacing
                    // Semester and Subject Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSemester,
                            hint: const Text(
                              'Semester',
                              style: TextStyle(
                                fontSize: 12, // Smaller font
                                fontFamily: 'Sourgammy',
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12, // Smaller font
                              fontFamily: 'Sourgammy',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              isDense: true,
                            ),
                            items: semesters.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 12, // Smaller font
                                    fontFamily: 'Sourgammy',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSemester = newValue;
                              });
                              _loadNotes();
                            },
                          ),
                        ),
                        const SizedBox(width: 6), // Reduced spacing
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSubject,
                            hint: const Text(
                              'Subject',
                              style: TextStyle(
                                fontSize: 12, // Smaller font
                                fontFamily: 'Sourgammy',
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12, // Smaller font
                              fontFamily: 'Sourgammy',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              isDense: true,
                            ),
                            items: (selectedDepartment != null &&
                                subjects.containsKey(selectedDepartment))
                                ? subjects[selectedDepartment]!.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 12, // Smaller font
                                    fontFamily: 'Sourgammy',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList()
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSubject = newValue;
                              });
                              _loadNotes();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notes List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : notes.isEmpty
                ? const Center(
              child: Text(
                'No notes found. Upload some notes!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Sourgammy',
                ),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: _getFileIcon(note.fileType),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sourgammy',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${note.subject} • ${note.uploadDate.toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontFamily: 'Sourgammy',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Color(0xFF187fc4)),
                          onPressed: () => _viewNote(note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Show confirmation dialog
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Delete Note',
                                    style: TextStyle(fontFamily: 'Sourgammy'),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete this note?',
                                    style: TextStyle(fontFamily: 'Sourgammy'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await noteRepository.deleteNote(note.id);
                              _loadNotes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Note deleted successfully',
                                    style: TextStyle(fontFamily: 'Sourgammy'),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () => _showNoteDetails(note),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadDialog,
        backgroundColor: const Color(0xFF187fc4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue, size: 32);
      case 'txt':
        return const Icon(Icons.text_snippet, color: Colors.green, size: 32);
      default:
        return const Icon(Icons.insert_drive_file, size: 32);
    }
  }
}