import 'package:flutter_test/flutter_test.dart';
import 'package:rescufy/data/models/request_history_model.dart';

void main() {
  group('RequestHistoryModel', () {
    test('parses full swagger item correctly', () {
      final model = RequestHistoryModel.fromJson({
        'id': 12,
        'description': 'Chest pain and difficulty breathing',
        'address': '123 Main Street',
        'requestStatus': 'Pending',
        'createdAt': '2026-06-10T11:59:39.006Z',
        'patientName': 'John Doe',
        'assignedAmbulancePlate': 'AMB-012',
        'driverName': 'Ahmed Hassan',
        'hospitalName': 'City General Hospital',
      });

      expect(model.id, 12);
      expect(model.description, 'Chest pain and difficulty breathing');
      expect(model.address, '123 Main Street');
      expect(model.requestStatus, 'Pending');
      expect(model.createdAt, DateTime.parse('2026-06-10T11:59:39.006Z'));
      expect(model.patientName, 'John Doe');
      expect(model.assignedAmbulancePlate, 'AMB-012');
      expect(model.driverName, 'Ahmed Hassan');
      expect(model.hospitalName, 'City General Hospital');
    });

    test('keeps optional fields null when absent or empty', () {
      final model = RequestHistoryModel.fromJson({
        'id': '5',
        'description': null,
        'address': null,
        'requestStatus': 'Canceled',
        'createdAt': '2026-06-10T11:59:39.006Z',
        'patientName': null,
        'assignedAmbulancePlate': '',
      });

      expect(model.id, 5);
      expect(model.description, '');
      expect(model.address, '');
      expect(model.patientName, '');
      expect(model.assignedAmbulancePlate, isNull);
      expect(model.driverName, isNull);
      expect(model.hospitalName, isNull);
    });
  });
}
