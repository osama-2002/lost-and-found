import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqodat/pages/home_page.dart';
import 'package:mafqodat/pages/login_page.dart';

class ReportPage extends StatefulWidget {
  final bool lost;
  final String? description;
  final String? id;
  const ReportPage(
      {super.key,
      required this.lost,
      required this.description,
      required this.id});
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    if (widget.description != null) {
      _descriptionController.text = widget.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Report',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                cursorHeight: 20,
                autofocus: false,
                decoration: InputDecoration(
                  labelText: 'Enter a description about the item',
                  hintText: "Enter a description about the item",
                  prefixIcon: const Icon(Icons.abc),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                onPressed: () {
                  Map<String, dynamic> data = {
                    "description": _descriptionController.text,
                    "lost": widget.lost,
                    "uid": FirebaseAuth.instance.currentUser!.uid,
                  };
                  if (_formKey.currentState!.validate()) {
                    if (widget.description != null) {
                      FirebaseFirestore.instance
                          .collection("reports")
                          .doc(widget.id)
                          .update(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: widget.lost
                              ? const Text(
                                  "Your claim has been updated successfully")
                              : const Text(
                                  "Your report has been updated successfully"),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } else {
                      FirebaseFirestore.instance
                          .collection("reports")
                          .doc()
                          .set({
                        "description": _descriptionController.text,
                        "lost": widget.lost,
                        "uid": FirebaseAuth.instance.currentUser!.uid,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: widget.lost
                              ? const Text(
                                  "Your claim has been added successfully")
                              : const Text(
                                  "Your report has been added successfully"),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  widget.description != null
                      ? "Edit"
                      : widget.lost
                          ? "Report"
                          : "Submit",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
