import 'package:file_view_pager/data_attachments.dart';
import 'package:file_view_pager/view_attachment_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: MainPage()
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewAttachmentsPage(
                  dataAttachments: DataAttachments(
                      listAttachment: [
                        "https://static.cyhome.vn/1kva-1-600x400-1623308080615.jpg",
                        "https://static.cyhome.vn/46961230_317991655706559_211159421407985664_n-1623308080690.jpg",
                        "https://static.cyhome.vn/sign-1623308080691.docx",
                        "https://static.cyhome.vn/sign-1623308080785.pdf",
                        "https://static.cyhome.vn/uploadv2/appicons-1668571908458.zip",
                        "https://static.cyhome.vn/uploadv2/hongnhanxuahtrolremix-luudaotamialiu-5951542-1668571918080.mp3"
                      ],
                      initPosition: 0,
                      contentSuccess: "Download successfully"),
                )),
          );
        },
        child: Text("Open View pager"),
      ),
    );
  }
}

