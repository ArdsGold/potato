import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  String? selectedComplaint; // Stores the selected complaint type
  TextEditingController contactController = TextEditingController();
  bool isLoading = false; // Loading indicator for when submission is in progress

  // Function to submit complaint to the server
  Future<void> submitComplaint() async {
    if (selectedComplaint == null || contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    final url = Uri.parse('http://192.168.100.149/dartdb/submit_complaint.php'); // Adjust with your IP/path
    try {
      final response = await http.post(
        url,
        body: {
          'complaint_type': selectedComplaint!,
          'contact_info': contactController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully')),
        );
        contactController.clear();
        setState(() {
          selectedComplaint = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint. Try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[700],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('Complaints!', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            // Complaint type selector
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text('Noise Complaint'),
                    value: 'Noise Complaint',
                    groupValue: selectedComplaint,
                    onChanged: (value) {
                      setState(() {
                        selectedComplaint = value.toString();
                      });
                    },
                  ),
                  Divider(),
                  RadioListTile(
                    title: Text('Waste Complaint'),
                    value: 'Waste Complaint',
                    groupValue: selectedComplaint,
                    onChanged: (value) {
                      setState(() {
                        selectedComplaint = value.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Info:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            // Contact info input field
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your contact info',
              ),
            ),
            SizedBox(height: 20),
            // Submit button
            Center(
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                onPressed: submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('SUBMIT', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
