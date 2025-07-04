import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'CalcuDose',
      'tripleMethod': 'Triple Method',
      'dripRate': 'Drip Rate',
      'medicationTimer': 'Timer',
      'calculate': 'CALCULATE',
      'reset': 'Reset Form',
      'result': 'RESULT',
      'tripleMethodTitle': 'Triple Method Calculator',
      'tripleMethodDesc':
          'Calculate the exact volume to administer based on medication concentration and prescribed dose.',
      'medConcentration': 'Medication Concentration',
      'dilutionVolume': 'Dilution Volume',
      'prescribedDose': 'Prescribed Dose',
      'calculateVolume': 'CALCULATE VOLUME',
      'administer': 'Administer',
      'dripRateTitle': 'Drip Rate Calculator',
      'dripRateDesc':
          'Calculate the drops per minute for intravenous medication administration.',
      'totalVolume': 'Total Volume',
      'hours': 'Hours',
      'minutes': 'Minutes',
      'dropFactor': 'Drop Factor (drops/ml)',
      'calculateDripRate': 'CALCULATE DRIP RATE',
      'dropsPerMinute': 'drops/minute',
      'medTimerTitle': 'Medication Timer',
      'medTimerDesc':
          'Set alerts for medication administration to ensure timely patient care.',
      'patientName': 'Patient Name/ID',
      'medicationName': 'Medication Name',
      'addTimer': 'ADD TIMER',
      'activeTimers': 'Active Timers',
      'noTimers': 'No active timers',
      'pause': 'PAUSE',
      'resume': 'RESUME',
      'alert': 'Medication Alert!',
      'medicationDue': 'is due now for patient',
      'acknowledge': 'ACKNOWLEDGE',
      'error': 'Input Error',
      'ok': 'OK',
      'enterValidNumbers': 'Please enter valid numbers in all fields.',
      'enterValuesGreaterZero': 'Please enter values greater than zero.',
      'enterValidTime': 'Please enter valid numbers for time.',
      'enterPatientMedication': 'Please enter patient and medication names.',
      'enterTimeGreaterZero': 'Please enter a time greater than zero.',
      'example': 'e.g.,',
      'volume': 'ml',
      'selectLanguage': 'Select Language',
      'medicationTimerDesc':
          'Set alerts for medication administration to ensure timely patient care.',
      'noActiveTimers': 'No active timers',
      'medicationAlert': 'Medication Alert',
      'forPatient': 'for patient',
      'isDueNow': 'is due now',
      'hintPatientName': 'e.g., Mohammed or Room 101',
      'hintMedicationName': 'e.g., Normal Saline 0.9%',
      'hintHours': 'e.g., 1',
      'hintMinutes': 'e.g., 30',
    },
    'fr': {
      'appTitle': 'CalcuDose',
      'tripleMethod': 'Méthode Triple',
      'dripRate': 'Débit Goutte',
      'medicationTimer': 'Minuteur',
      'calculate': 'CALCULER',
      'reset': 'Réinitialiser',
      'result': 'RÉSULTAT',
      'tripleMethodTitle': 'Calculateur Méthode Triple',
      'tripleMethodDesc':
          'Calculez le volume exact à administrer selon la concentration du médicament et la dose prescrite.',
      'medConcentration': 'Concentration du médicament',
      'dilutionVolume': 'Volume de dilution',
      'prescribedDose': 'Dose prescrite',
      'calculateVolume': 'CALCULER LE VOLUME',
      'administer': 'Administrer',
      'dripRateTitle': 'Calculateur de Débit',
      'dripRateDesc':
          'Calculez les gouttes par minute pour l\'administration intraveineuse.',
      'totalVolume': 'Volume total',
      'hours': 'Heures',
      'minutes': 'Minutes',
      'dropFactor': 'Facteur goutte (gouttes/ml)',
      'calculateDripRate': 'CALCULER LE DÉBIT',
      'dropsPerMinute': 'gouttes/minute',
      'medTimerTitle': 'Minuteur de Médicaments',
      'medTimerDesc':
          'Définir des alertes pour l\'administration des médicaments.',
      'patientName': 'Nom/ID du patient',
      'medicationName': 'Nom du médicament',
      'addTimer': 'AJOUTER MINUTEUR',
      'activeTimers': 'Minuteurs actifs',
      'noTimers': 'Aucun minuteur actif',
      'pause': 'PAUSE',
      'resume': 'REPRENDRE',
      'alert': 'Alerte Médicament!',
      'medicationDue': 'est à administrer au patient',
      'acknowledge': 'CONFIRMER',
      'error': 'Erreur de saisie',
      'ok': 'OK',
      'enterValidNumbers':
          'Veuillez saisir des nombres valides dans tous les champs.',
      'enterValuesGreaterZero':
          'Veuillez saisir des valeurs supérieures à zéro.',
      'enterValidTime': 'Veuillez saisir des nombres valides pour le temps.',
      'enterPatientMedication':
          'Veuillez saisir le nom du patient et du médicament.',
      'enterTimeGreaterZero': 'Veuillez saisir un temps supérieur à zéro.',
      'example': 'ex:',
      'volume': 'ml',
      'selectLanguage': 'Choisir la langue',
      'medicationTimerDesc':
          'Définir des alertes pour l\'administration des médicaments.',
      'noActiveTimers': 'Aucun minuteur actif',
      'medicationAlert': 'Alerte Médicament',
      'forPatient': 'pour le patient',
      'isDueNow': 'est à administrer',
      'hintPatientName': 'ex: Mohammed ou Chambre 101',
      'hintMedicationName': 'ex: Solution saline 0,9%',
      'hintHours': 'ex: 1',
      'hintMinutes': 'ex: 30',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  Future<void> load() async {
    // This method is required by the LocalizationsDelegate
    // but we don't need async loading for this simple implementation
    return;
  }
}
