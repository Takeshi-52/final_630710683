import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_630710683/helpers/api_caller.dart';
import 'package:final_630710683/helpers/dialog_utils.dart';
import 'package:final_630710683/helpers/my_text_field.dart';
import 'package:final_630710683/models/web_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WebItem> _webItems = [];
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  WebItem? _selectedWebItem;

 @override
void initState() {
  super.initState();
  _loadWebItems();
}

Future<void> _loadWebItems() async {
  try {
    final data = await ApiCaller().get('web_types');
    List list = jsonDecode(data);
    setState(() {
      _webItems = list.map((e) => WebItem.fromJson(e)).toList();
    });
  } on Exception catch (e) {
    showOkDialog(context: context, title: "Error", message: e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                'Webby Fondue',
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 24),
              ),
              Text('ระบบรายงานเว็บเลวๆ',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16))
            ],
          ),
        ),
        backgroundColor: Color(0xFF006876),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '* ต้องกรอกข้อมูล',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: _urlController,
              hintText: 'URL *',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: _detailsController,
              hintText: 'รายละเอียด',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'ระบุประเภทเว็บเลว *',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _webItems.length,
                itemBuilder: (context, index) {
                  final item = _webItems[index];
                  final imageUrl =
                      item.image != null && item.image.isNotEmpty
                          ? '${ApiCaller.baseUrl}/${item.image}'
                          : null;
                  return Card(
                    child: ListTile(
                      leading: imageUrl != null
                          ? Image.network(imageUrl)
                          : null,
                      title: Text(item.title),
                      onTap: () {
                        setState(() {
                          _selectedWebItem = item;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  _selectedWebItem != null ? _handleApiPost : null,
              child: Text('ส่งข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "report_web",
        params: {
          "url": _urlController.text,
          "details": _detailsController.text,
          "type_id": _selectedWebItem?.id,
        },
      );
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }
}
