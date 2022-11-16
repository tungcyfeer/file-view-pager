import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'data_attachments.dart';
import 'page_view_photo.dart';
import 'view_attachment_bloc.dart';

class ViewAttachmentsPage extends StatefulWidget {
  final DataAttachments dataAttachments;

  ViewAttachmentsPage({required this.dataAttachments});

  @override
  _ViewAttachmentsPageState createState() => _ViewAttachmentsPageState();
}

class _ViewAttachmentsPageState extends State<ViewAttachmentsPage> {
  late ViewAttachmentsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ViewAttachmentsBloc(initDataViewAttachments: widget.dataAttachments);
    bloc.downloadStream.listen((event) {
      if (event == DownloadState.IDLE) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
            child: Text(
              widget.dataAttachments.contentSuccess,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4A90E2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Color(0xFFECF3FC),
          duration: const Duration(seconds: 3),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: StreamBuilder<DownloadState>(
                stream: bloc.downloadStream,
                builder: (context, AsyncSnapshot<DownloadState> snapshot) {
                  return snapshot.data == DownloadState.LOADING
                      ? Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            width: 19,
                            height: 19,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            bloc.startDownload();
                          },
                          child: Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.download_sharp,
                                color: Colors.white,
                                size: 22,
                              )),
                        );
                }),
          ),
        ],
        brightness: Brightness.dark,
        title: StreamBuilder<int>(
            stream: bloc.changePageStream,
            builder: (context, AsyncSnapshot<int> snapshot) {
              return Text(
                bloc.currentFileName ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                    fontSize: 14),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              );
            }), // or use
        // Brightness.dark
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: PageViewAttachment(
                  listAttachment: widget.dataAttachments.listAttachment,
                  initPosition: widget.dataAttachments.initPosition,
                  onPageChanged: (position) {
                    bloc.changePage(position);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<int>(
                stream: bloc.changePageStream,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  return Text(
                    bloc.currentPositionDisplay,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                        fontSize: 14),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  );
                }),
            SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
    );
  }
}
