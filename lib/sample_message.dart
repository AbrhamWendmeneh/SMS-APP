import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:contacts_service/contacts_service.dart';

class SampleMessageScreen extends StatefulWidget {
  const SampleMessageScreen({Key? key, String? phoneNumber}) : super(key: key);

  @override
  State<SampleMessageScreen> createState() => _SampleMessageScreenState();
}

class _SampleMessageScreenState extends State<SampleMessageScreen> {
  List<SmsMessage> _messages = [];
  String? phoneNumber;
  List<Contact> contacts = [];
  final TextEditingController _message = TextEditingController();

  String? contactNumber;

  @override
  void initState() {
    super.initState();
    getAllSms();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> getAllSms() async {
    List<SmsMessage> messages = [];

    List<SmsMessage> sentMessages = await SmsQuery().querySms(
      address: phoneNumber,
      kinds: [SmsQueryKind.sent],
    );

    List<SmsMessage> receivedMessages = await SmsQuery().querySms(
      address: phoneNumber,
    );

    messages.addAll(receivedMessages);
    messages.addAll(sentMessages);

    List<String?> phoneNumbers =
        messages.map((message) => message.address).toList();

    Iterable<Contact> contacts =
        await ContactsService.getContactsForPhone(phoneNumbers as String?);

    Map<String, String> contactMap = {};

    for (var contact in contacts) {
      String phoneNumber = contact.phones?.elementAt(0).value ?? '';
      String displayName = contact.displayName ?? '';
      contactMap[phoneNumber] = displayName;
    }

    messages.sort((val1, val2) => (contactMap[val1.address] ?? '')
        .compareTo(contactMap[val2.address] ?? ''));

    setState(() {
      _messages = messages;
    });
  }

  Future<void> getContactDetails() async {
    // ignore: no_leading_underscores_for_local_identifiers
    Iterable<Contact>? _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          contactNumber ?? '',
          style: const TextStyle(
            fontSize: 26.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? _buildNormalContainer()
              : _buildWideContainers();
        },
      ),
    );
  }

  Widget _buildWideContainers() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSender = false; // Replace with your logic
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: isSender
                        // ignore: dead_code
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          // ignore: dead_code
                          color: isSender ? Colors.grey[300] : Colors.blue[400],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isSender
                                // ignore: dead_code
                                ? const Radius.circular(20)
                                : const Radius.circular(0),
                            bottomRight: isSender
                                // ignore: dead_code
                                ? const Radius.circular(0)
                                : const Radius.circular(20),
                          ),
                        ),
                        child: SizedBox(
                          width: 200.0,
                          child: Text(
                            '${_messages[index].body}',
                            style: TextStyle(
                              // ignore: dead_code
                              color: isSender ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    contacts[index].displayName ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    contacts[index].phones?.first.value ?? '',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSender = false; // Replace with your logic
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: isSender
                        // ignore: dead_code
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          // ignore: dead_code
                          color: isSender ? Colors.grey[300] : Colors.blue[400],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isSender
                                // ignore: dead_code
                                ? const Radius.circular(20)
                                : const Radius.circular(0),
                            bottomRight: isSender
                                // ignore: dead_code
                                ? const Radius.circular(0)
                                : const Radius.circular(20),
                          ),
                        ),
                        child: SizedBox(
                          width: 200.0,
                          child: Text(
                            '${_messages[index].body}',
                            style: TextStyle(
                              // ignore: dead_code
                              color: isSender ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    contacts[index].displayName ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    contacts[index].phones?.first.value ?? '',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
