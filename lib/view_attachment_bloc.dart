import 'dart:async';
import 'package:flutter/services.dart';

import 'data_attachments.dart';
import 'extension.dart';

enum DownloadState { IDLE, LOADING}

class ViewAttachmentsBloc {
  DataAttachments initDataViewAttachments;

  ViewAttachmentsBloc({required this.initDataViewAttachments}) {
    currentPosition = initDataViewAttachments.initPosition;
  }

  static const MethodChannel _channel = const MethodChannel('file_view_pager');
  int currentPosition = 0;

  final _changePageStreamController = StreamController<int>.broadcast();
  final _downloadStreamController = StreamController<DownloadState>.broadcast();

  void dispose() {
    _changePageStreamController.close();
    _downloadStreamController.close();
  }

  get changePageStream =>
      _changePageStreamController.stream.asBroadcastStream();

  Stream<DownloadState> get downloadStream => _downloadStreamController.stream.asBroadcastStream();

  void changePage(int position) {
    currentPosition = position;
    _changePageStreamController.sink.add(position);
  }

  void startDownload() async {
    _downloadStreamController.sink.add(DownloadState.LOADING);
    var result = await _channel.invokeMethod('downloadFile', {"url": initDataViewAttachments.listAttachment[currentPosition]});
    if (result) {
      _downloadStreamController.sink.add(DownloadState.IDLE);
    }
  }

  get currentPositionDisplay => "${currentPosition + 1}/${initDataViewAttachments.listAttachment.length}";

  get currentFileName => initDataViewAttachments.listAttachment[currentPosition].fileName;

}
