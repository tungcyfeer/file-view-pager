import 'package:flutter/material.dart';

class DataAttachments {
  List<String> listAttachment;
  int initPosition;
  String contentSuccess;

  DataAttachments({required this.listAttachment, required this.initPosition, this.contentSuccess = "Tải tệp thành công"});
}