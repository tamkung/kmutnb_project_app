import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  final String url, name;
  const PDFViewer({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
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
