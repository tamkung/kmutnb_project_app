import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer1 extends StatefulWidget {
  final String url, name;
  const PDFViewer1({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  _PDFViewer1State createState() => _PDFViewer1State();
}

class _PDFViewer1State extends State<PDFViewer1> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: pColor,
          title: Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[],
        ),
        body: pdfviewer(),
      ),
    );
  }

  Widget pdfviewer() => SfPdfViewer.network(
        widget.url,
        controller: _pdfViewerController,
        key: _pdfViewerStateKey,
      );
}
