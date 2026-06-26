import 'dart:io';
import 'package:flutter/material.dart' hide Table, TableRow;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendanceresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payslipmodel.dart';

class PdfService {
  static Future<String?> generateAndSaveMonthlyAttendancePdf(
      MonthlyAttendanceResponse data) async {
    try {
      final pdf = pw.Document();

      // Basic stats
      int present = 0;
      int absent = 0;
      int holidays = 0;
      for (var day in data.calendarData) {
        if (day.status == 'present') {
          present++;
        } else if (day.status == 'absent') {
          absent++;
        } else if (day.status == 'holiday') {
          holidays++;
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              _buildHeader(data),
              pw.SizedBox(height: 20),
              _buildSummary(data, present, absent, holidays),
              pw.SizedBox(height: 20),
              _buildAttendanceTable(data),
            ];
          },
        ),
      );

      final bytes = await pdf.save();

      // Save to Downloads folder
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return null;

      final monthStr = data.month.toString().padLeft(2, '0');
      final fileName = 'Attendance_${data.memberInfo.empNo}_${data.year}_$monthStr.pdf';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('PDF Generation error: $e');
      return null;
    }
  }

  static pw.Widget _buildHeader(MonthlyAttendanceResponse data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Monthly Attendance Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Employee Name: ${data.memberInfo.name}',
            style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Employee ID: ${data.memberInfo.empNo}',
            style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Department: ${data.memberInfo.department}',
            style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Designation: ${data.memberInfo.designation}',
            style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 10),
        pw.Text(
            'Month/Year: ${data.month.toString().padLeft(2, '0')} / ${data.year}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildSummary(
      MonthlyAttendanceResponse data, int present, int absent, int holidays) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Present', present.toString(), PdfColors.green700),
          _summaryItem('Absent', absent.toString(), PdfColors.red700),
          _summaryItem('Holidays', holidays.toString(), PdfColors.blue700),
        ],
      ),
    );
  }

  static pw.Widget _summaryItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 20, fontWeight: pw.FontWeight.bold, color: color)),
        pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  static pw.Widget _buildAttendanceTable(MonthlyAttendanceResponse data) {
    return pw.TableHelper.fromTextArray(
      headers: [
        'Date',
        'Day',
        'Status',
        'Check-In',
        'Check-Out',
        'Worked Hrs'
      ],
      data: data.calendarData.map((day) {
        final details = day.attendanceDetails;
        return [
          day.date,
          day.dayType,
          day.status.toUpperCase(),
          details?.checkinTime ?? '--',
          details?.checkoutTime ?? '--',
          details?.workingHours ?? '--',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      cellStyle: const pw.TextStyle(fontSize: 10),
    );
  }

  static Future<String?> generateAndSavePayslipPdf(
    Payslip data, {
    String? staffName,
    String? empNo,
    String? department,
    String? designation,
  }) async {
    try {
      final pdf = pw.Document();

      final double baseSalary = double.tryParse(data.baseSalary) ?? 0;
      final double otherAllowance = double.tryParse(data.otherAllowance) ?? 0;
      final double travelAllowance = double.tryParse(data.travelAllowance) ?? 0;
      final double medicalAllowance = double.tryParse(data.medicalAllowance) ?? 0;
      final double otAmount = double.tryParse(data.otAmount) ?? 0;
      final double grossSalary = double.tryParse(data.grossSalary) ?? 0;
      
      final double pfAmount = double.tryParse(data.pfAmount) ?? 0;
      final double insuranceAmount = double.tryParse(data.insuranceAmount) ?? 0;
      final double lopDeduction = double.tryParse(data.lopDeduction) ?? 0;
      final double otherDeduction = double.tryParse(data.otherDeduction) ?? 0;
      final double netSalary = double.tryParse(data.netSalary) ?? 0;

      String _fmt(double v) => v.toStringAsFixed(2);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Salary Slip',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Employee Name: ${staffName?.isNotEmpty == true ? staffName : data.memberName}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Employee ID: ${empNo?.isNotEmpty == true ? empNo : data.empNo}',
                    style: const pw.TextStyle(fontSize: 14)),
                if (department?.isNotEmpty == true)
                  pw.Text('Department: $department',
                      style: const pw.TextStyle(fontSize: 14)),
                if (designation?.isNotEmpty == true)
                  pw.Text('Designation: $designation',
                      style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 5),
                pw.Text('Month/Year: ${data.monthLabel} ${data.year}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem('Net Salary', 'Rs ${_fmt(netSalary)}', PdfColors.blue700),
                      _summaryItem('LOP Days', '${data.lopDays}', PdfColors.red700),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Earnings', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                _pdfRow('Base Salary', 'Rs ${_fmt(baseSalary)}'),
                if (otherAllowance > 0) _pdfRow('Other Allowance', 'Rs ${_fmt(otherAllowance)}'),
                if (travelAllowance > 0) _pdfRow('Travel Allowance', 'Rs ${_fmt(travelAllowance)}'),
                if (medicalAllowance > 0) _pdfRow('Medical Allowance', 'Rs ${_fmt(medicalAllowance)}'),
                if (otAmount > 0) _pdfRow('Overtime Amount', 'Rs ${_fmt(otAmount)}'),
                _pdfRow('Gross Salary', 'Rs ${_fmt(grossSalary)}', isBold: true),
                
                pw.SizedBox(height: 20),
                pw.Text('Deductions', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                _pdfRow('PF Amount', 'Rs ${_fmt(pfAmount)}'),
                _pdfRow('Insurance', 'Rs ${_fmt(insuranceAmount)}'),
                _pdfRow('LOP Deduction', 'Rs ${_fmt(lopDeduction)}'),
                if (otherDeduction > 0) _pdfRow('Other Deductions', 'Rs ${_fmt(otherDeduction)}'),

                pw.SizedBox(height: 20),
                pw.Divider(),
                _pdfRow('Net Salary', 'Rs ${_fmt(netSalary)}', isBold: true),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return null;

      final monthStr = data.month.toString().padLeft(2, '0');
      final fileName = 'Payslip_${data.empNo}_${data.year}_$monthStr.pdf';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('Payslip PDF Generation error: $e');
      return null;
    }
  }

  static pw.Widget _pdfRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
