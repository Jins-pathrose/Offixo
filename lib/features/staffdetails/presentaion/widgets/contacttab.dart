import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/profileinfomodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/inforow.dart';

class ContactTab extends StatelessWidget {
  final ProfileInfo? info;
  const ContactTab({this.info});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.phone_outlined, color: AppStyle.accentCyan, size: 20),
            const SizedBox(width: 8),
            Text('Contact', style: AppStyle.text(size: 15, weight: FontWeight.w700)),
          ]),
          const Divider(height: 20),
          InfoRow(icon: Icons.phone_outlined, label: 'Phone Number', value: info?.phoneNumber ?? '--'),
          InfoRow(icon: Icons.email_outlined, label: 'Email', value: info?.email ?? '--', isLast: true),
        ],
      ),
    );
  }
}