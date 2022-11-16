extension CheckSuffixUrl on String {
  get isImage {
    String urlLowerCase = this.toLowerCase();
    return urlLowerCase.contains(".jpg") || urlLowerCase.contains(".png") || urlLowerCase.contains(".jpeg") || urlLowerCase.contains(".heic");
  }

  get isFileDriver {
    String urlLowerCase = this.toLowerCase();
    return urlLowerCase.contains(".doc") || urlLowerCase.contains(".xlsx") || urlLowerCase.contains(".pdf");
  }

  get fileName {
    return RegExp("([^\\\/]+)\$").stringMatch(this) ?? "";
  }

  String get extension {
    return RegExp("([^\\\.]+)\$").stringMatch(this) ?? "";
  }
}