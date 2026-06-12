class ProfileEndpoints {
  static const String baseUrl = 'https://final1111.runasp.net';
  // User
  static const String getProfile = '$baseUrl/api/profile';
  static const String updateProfile = '$baseUrl/api/profile';
  static const String postImageProfile = '$baseUrl/api/profile/image';
  static const String deleteImageProfile = '$baseUrl/api/profile/image';

  //Medications
  static const String getMedications = '$baseUrl/api/MedicalData/medications';
  static const String editMedications = '$baseUrl/api/MedicalData/medications';
  static const String deleteMedications =
      '$baseUrl/api/MedicalData/medications/{id}';
  //Allergies
  static const String getAllergies = '$baseUrl/api/MedicalData/allergies';
  static const String editAllergies = '$baseUrl/api/MedicalData/allergies';
  static const String deleteAllergies =
      '$baseUrl/api/MedicalData/allergies/{id}';

  //ChronicDiseases
  static const String getChronicDiseases =
      '$baseUrl/api/MedicalData/chronic-diseases';
  static const String editChronicDiseases =
      '$baseUrl/api/MedicalData/chronic-diseases';
  static const String deleteChronicDiseases =
      '$baseUrl/api/MedicalData/chronic-diseases/{id}';
  //PastSurgeries
  static const String getPastSurgeries =
      '$baseUrl/api/MedicalData/past-surgeries';
  static const String editPastSurgeries =
      '$baseUrl/api/MedicalData/past-surgeries';
  static const String deletePastSurgeries =
      '$baseUrl/api/MedicalData/past-surgeries/{id}';

  //EmergencyContacts
  static const String getEmergencyContacts =
      '$baseUrl/api/MedicalData/emergency-contacts';
  static const String editEmergencyContacts =
      '$baseUrl/api/MedicalData/emergency-contacts';
  static const String deleteEmergencyContacts =
      '$baseUrl/api/MedicalData/emergency-contacts/{id}';
}
