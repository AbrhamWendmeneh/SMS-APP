import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_sms/flutter_sms.dart';

class CreateMessages extends StatefulWidget {
  const CreateMessages({Key? key}) : super(key: key);

  @override
  State<CreateMessages> createState() => _CreateMessagesState();
}

class _CreateMessagesState extends State<CreateMessages> {
  final TextEditingController _phoneNumbers = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final Map<String, dynamic> receivers = {};

  @override
  void dispose() {
    _phoneNumbers.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Text Message",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Wrap(
                    spacing: 8.0,
                    children: receivers.keys.map((number) {
                      return InputChip(
                        label: Text('${receivers[number]}'),
                        onDeleted: () {
                          setState(() {
                            receivers.remove(number);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: null,
                    controller: _phoneNumbers,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () async {
                        final PhoneContact contact =
                            await FlutterContactPicker.pickPhoneContact();
                        final number = contact.phoneNumber?.number;
                        final name = contact.fullName;
                        if (number != null) {
                          setState(() {
                            receivers[number] = name;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.deepPurple,
                      iconSize: 32.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: null,
                controller: _message,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Message cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_phoneNumbers.text.isNotEmpty || receivers.isNotEmpty) {
                      final Set<String> recipients = {};
                      recipients.addAll(receivers.keys.toList());
                      if (_phoneNumbers.text.isNotEmpty) {
                        recipients.add(_phoneNumbers.text);
                      }
                      try {
                        await sendSMS(
                          sendDirect: true,
                          message: _message.text,
                          recipients: List.from(recipients),
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Message sent"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        await Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            Navigator.pop(context);
                          },
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to send message"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        debugPrint(error.toString());
                      }
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
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
}
