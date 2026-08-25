import 'package:flutter/material.dart';
import 'package:offixoadmin/features/settings/data/models/resigned_member.dart';
import 'package:offixoadmin/features/staffdetails/domain/staff_repository.dart';

class ResignedMembersProvider extends ChangeNotifier {
  final Staffrepository _repository = Staffrepository();
  
  List<ResignedMember> _members = [];
  bool _isLoading = false;
  String? _error;

  List<ResignedMember> get members => _members;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchResignedMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _members = await _repository.getResignedMembers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
