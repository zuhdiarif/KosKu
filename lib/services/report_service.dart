import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:kosmo/models/kos_model.dart';

class ReportService {
  static Future<void> generatePaymentReportPdf({
    required KosModel kos,
    required List<PaymentModel> payments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Laporan Keuangan Kosmo', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text(kos.name, style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Alamat: ${kos.address}'),
              pw.Text('Total Kamar: ${kos.totalRooms}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF004532)),
                data: <List<String>>[
                  <String>['ID Payment', 'Jumlah (Rp)', 'Jatuh Tempo', 'Status'],
                  ...payments.map((p) => [
                        p.id.substring(0, 8),
                        p.amount.toStringAsFixed(0),
                        '${p.dueDate.day}/${p.dueDate.month}/${p.dueDate.year}',
                        p.status.toUpperCase(),
                      ]),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Pemasukan:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Rp ${payments.where((p) => p.status == 'paid').fold(0.0, (sum, p) => sum + p.amount).toStringAsFixed(0)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: const PdfColor.fromInt(0xFF004532)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Keuangan_${kos.name}.pdf',
    );
  }
}
