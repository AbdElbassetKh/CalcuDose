// main.dart - The entry point of your Flutter application

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'l10n/app_localizations.dart';
import 'utils/unit_converter.dart'; // Ajout de l'import

void main() {
  runApp(const MedicationApp());
}

class MedicationApp extends StatefulWidget {
  const MedicationApp({Key? key}) : super(key: key);

  @override
  State<MedicationApp> createState() => _MedicationAppState();
}

class _MedicationAppState extends State<MedicationApp> {
  Locale _locale = const Locale('fr');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'fr'
          ? const Locale('en')
          : const Locale('fr');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Management',
      locale: _locale,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFF303030),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => HomePage(onLanguageToggle: _toggleLanguage),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onLanguageToggle;

  const HomePage({Key? key, required this.onLanguageToggle}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onLanguageToggle,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                icon: const Icon(Icons.calculate),
                text: l10n.get('tripleMethod')),
            Tab(icon: const Icon(Icons.water_drop), text: l10n.get('dripRate')),
            Tab(
                icon: const Icon(Icons.timer),
                text: l10n.get('medicationTimer')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TripleMethodCalculator(),
          DripRateCalculator(),
          MedicationTimer(),
        ],
      ),
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final appLocalizations = AppLocalizations(locale);
    await appLocalizations
        .load(); // Make sure this method exists in AppLocalizations
    return appLocalizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// 1. Triple Method Calculator
class TripleMethodCalculator extends StatefulWidget {
  const TripleMethodCalculator({Key? key}) : super(key: key);

  @override
  TripleMethodCalculatorState createState() => TripleMethodCalculatorState();
}

class TripleMethodCalculatorState extends State<TripleMethodCalculator> {
  final TextEditingController _medicationConcentrationController =
      TextEditingController();
  final TextEditingController _diluteVolumeController = TextEditingController();
  final TextEditingController _prescribedDoseController =
      TextEditingController();
  double _resultVolume = 0.0;
  bool _hasCalculated = false;

  // Ajouter les contrôleurs et variables pour les unités
  WeightUnit _concentrationUnit = WeightUnit.mg;
  VolumeUnit _volumeUnit = VolumeUnit.ml;
  WeightUnit _doseUnit = WeightUnit.mg;

  void _calculateDose() {
    try {
      final double medicationConcentration =
          double.parse(_medicationConcentrationController.text);
      final double diluteVolume = double.parse(_diluteVolumeController.text);
      final double prescribedDose =
          double.parse(_prescribedDoseController.text);

      // Convertir toutes les valeurs en unités de base (mg et ml)
      final double concentrationInMg = UnitConverter.convertWeight(
          medicationConcentration, _concentrationUnit, WeightUnit.mg);
      final double volumeInMl =
          UnitConverter.convertVolume(diluteVolume, _volumeUnit, VolumeUnit.ml);
      final double doseInMg =
          UnitConverter.convertWeight(prescribedDose, _doseUnit, WeightUnit.mg);

      if (concentrationInMg <= 0 || volumeInMl <= 0) {
        _showErrorDialog('Please enter values greater than zero.');
        return;
      }

      setState(() {
        _resultVolume = (doseInMg / concentrationInMg) * volumeInMl;
        _hasCalculated = true;
      });
    } catch (e) {
      _showErrorDialog('Please enter valid numbers in all fields.');
    }
  }

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.get('ok')),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _medicationConcentrationController.clear();
    _diluteVolumeController.clear();
    _prescribedDoseController.clear();
    setState(() {
      _hasCalculated = false;
      _resultVolume = 0.0;
    });
  }

  @override
  void dispose() {
    _medicationConcentrationController.dispose();
    _diluteVolumeController.dispose();
    _prescribedDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.get('tripleMethodDesc'),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _medicationConcentrationController,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.get('medConcentration')} (${UnitConverter.getWeightSymbol(_concentrationUnit)})',
                    hintText:
                        'e.g., 1000 ${UnitConverter.getWeightSymbol(_concentrationUnit)}',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              DropdownButton<WeightUnit>(
                value: _concentrationUnit,
                items: WeightUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.name),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit != null) {
                    setState(() => _concentrationUnit = unit);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _diluteVolumeController,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.get('dilutionVolume')} (${UnitConverter.getVolumeSymbol(_volumeUnit)})',
                    hintText:
                        'e.g., 10 ${UnitConverter.getVolumeSymbol(_volumeUnit)}',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              DropdownButton<VolumeUnit>(
                value: _volumeUnit,
                items: VolumeUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.name),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit != null) {
                    setState(() => _volumeUnit = unit);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _prescribedDoseController,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.get('prescribedDose')} (${UnitConverter.getWeightSymbol(_doseUnit)})',
                    hintText:
                        'e.g., 700 ${UnitConverter.getWeightSymbol(_doseUnit)}',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              DropdownButton<WeightUnit>(
                value: _doseUnit,
                items: WeightUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.name),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit != null) {
                    setState(() => _doseUnit = unit);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _calculateDose,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(l10n.get('calculateVolume'),
                style: const TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: _resetForm,
            child: Text(l10n.get('reset')),
          ),
          if (_hasCalculated) ...[
            const SizedBox(height: 24.0),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      l10n.get('result'),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${l10n.get('administer')} ${_resultVolume.toStringAsFixed(2)} ${UnitConverter.getVolumeSymbol(VolumeUnit.ml)}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// 2. Drip Rate Calculator
class DripRateCalculator extends StatefulWidget {
  const DripRateCalculator({Key? key}) : super(key: key);

  @override
  DripRateCalculatorState createState() => DripRateCalculatorState();
}

class DripRateCalculatorState extends State<DripRateCalculator> {
  final TextEditingController _totalVolumeController = TextEditingController();
  final TextEditingController _timeHoursController = TextEditingController();
  final TextEditingController _timeMinutesController = TextEditingController();
  final TextEditingController _dropFactorController = TextEditingController();
  double _resultDripRate = 0.0;
  bool _hasCalculated = false;

  // Ajout des variables pour les unités
  VolumeUnit _volumeUnit = VolumeUnit.ml;

  void _calculateDripRate() {
    try {
      double totalVolume = double.parse(_totalVolumeController.text);
      // Convertir le volume en ml pour le calcul
      totalVolume =
          UnitConverter.convertVolume(totalVolume, _volumeUnit, VolumeUnit.ml);

      double timeInMinutes = 0;

      if (_timeHoursController.text.isNotEmpty) {
        timeInMinutes += double.parse(_timeHoursController.text) * 60;
      }

      if (_timeMinutesController.text.isNotEmpty) {
        timeInMinutes += double.parse(_timeMinutesController.text);
      }

      final double dropFactor = double.parse(_dropFactorController.text);

      if (totalVolume <= 0 || timeInMinutes <= 0 || dropFactor <= 0) {
        _showErrorDialog('Please enter values greater than zero.');
        return;
      }

      setState(() {
        _resultDripRate = (totalVolume * dropFactor) / timeInMinutes;
        _hasCalculated = true;
      });
    } catch (e) {
      _showErrorDialog('Please enter valid numbers in all required fields.');
    }
  }

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.get('ok')),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _totalVolumeController.clear();
    _timeHoursController.clear();
    _timeMinutesController.clear();
    _dropFactorController.clear();
    setState(() {
      _hasCalculated = false;
      _resultDripRate = 0.0;
    });
  }

  @override
  void dispose() {
    _totalVolumeController.dispose();
    _timeHoursController.dispose();
    _timeMinutesController.dispose();
    _dropFactorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.get('dripRateDesc'),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _totalVolumeController,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.get('totalVolume')} (${UnitConverter.getVolumeSymbol(_volumeUnit)})',
                    hintText:
                        'e.g., 500 ${UnitConverter.getVolumeSymbol(_volumeUnit)}',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              DropdownButton<VolumeUnit>(
                value: _volumeUnit,
                items: VolumeUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(UnitConverter.getVolumeSymbol(unit)),
                  );
                }).toList(),
                onChanged: (VolumeUnit? newUnit) {
                  if (newUnit != null) {
                    setState(() {
                      _volumeUnit = newUnit;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _timeHoursController,
                  decoration: InputDecoration(
                    labelText: l10n.get('hours'),
                    hintText: 'e.g., 1',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  controller: _timeMinutesController,
                  decoration: InputDecoration(
                    labelText: l10n.get('minutes'),
                    hintText: 'e.g., 30',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _dropFactorController,
            decoration: InputDecoration(
              labelText: l10n.get('dropFactor'),
              hintText: 'e.g., 20',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _calculateDripRate,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(l10n.get('calculateDripRate'),
                style: const TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: _resetForm,
            child: Text(l10n.get('reset')),
          ),
          if (_hasCalculated) ...[
            const SizedBox(height: 24.0),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      l10n.get('result'),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${_resultDripRate.round()} ${l10n.get('dropsPerMinute')}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// 3. Medication Timer
class MedicationTimer extends StatefulWidget {
  const MedicationTimer({Key? key}) : super(key: key);

  @override
  MedicationTimerState createState() => MedicationTimerState();
}

class MedicationTimerState extends State<MedicationTimer> {
  final List<TimerItem> _timers = [];
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  void _addTimer() {
    final String patientName = _patientNameController.text.trim();
    final String medicationName = _medicationNameController.text.trim();
    int hours = 0;
    int minutes = 0;

    try {
      if (_hoursController.text.isNotEmpty) {
        hours = int.parse(_hoursController.text);
      }
      if (_minutesController.text.isNotEmpty) {
        minutes = int.parse(_minutesController.text);
      }
    } catch (e) {
      _showErrorDialog('Please enter valid numbers for time.');
      return;
    }

    if (patientName.isEmpty || medicationName.isEmpty) {
      _showErrorDialog('Please enter patient and medication names.');
      return;
    }

    if (hours == 0 && minutes == 0) {
      _showErrorDialog('Please enter a time greater than zero.');
      return;
    }

    final TimerItem newTimer = TimerItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: patientName,
      medicationName: medicationName,
      durationInSeconds: (hours * 3600) + (minutes * 60),
      onComplete: _onTimerComplete,
    );

    setState(() {
      _timers.add(newTimer);
    });
    // Subscribe to timer updates
    newTimer.addListener(() {
      if (mounted) setState(() {});
    });
    _resetForm();
  }

  void _onTimerComplete(String id) async {
    if (!mounted) return;

    final timer = _timers.firstWhere((timer) => timer.id == id);
    bool isAcknowledged = false;

    // Start playing alert sound in loop
    await _audioPlayer.play(AssetSource('sounds/alert.mp3'), volume: 1.0);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    if (!mounted) {
      await _audioPlayer.stop();
      return;
    }

    final l10n = AppLocalizations.of(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(l10n.get('medicationAlert')),
          content: Text(
            '${timer.medicationName} ${l10n.get('forPatient')} ${timer.patientName} ${l10n.get('isDueNow')}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                isAcknowledged = true;
                Navigator.of(ctx).pop();
              },
              child: Text(l10n.get('acknowledge')),
            ),
          ],
        ),
      ),
    );

    // Stop sound only after acknowledgment
    await _audioPlayer.stop();

    if (isAcknowledged && mounted) {
      setState(() {
        _timers.removeWhere((t) => t.id == id);
      });
    }
  }

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.get('ok')),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _patientNameController.clear();
    _medicationNameController.clear();
    _hoursController.clear();
    _minutesController.clear();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _medicationNameController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _audioPlayer.dispose();
    for (var timer in _timers) {
      timer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.get('medicationTimerDesc'),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _patientNameController,
                    decoration: InputDecoration(
                      labelText: l10n.get('patientName'),
                      hintText: 'e.g., John Doe or Room 101',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      labelText: l10n.get('medicationName'),
                      hintText: 'e.g., Normal Saline 0.9%',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hoursController,
                          decoration: InputDecoration(
                            labelText: l10n.get('hours'),
                            hintText: 'e.g., 1',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: _minutesController,
                          decoration: InputDecoration(
                            labelText: l10n.get('minutes'),
                            hintText: 'e.g., 30',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(l10n.get('addTimer'),
                        style: const TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            l10n.get('activeTimers'),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (_timers.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(l10n.get('noActiveTimers')),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _timers.length,
              itemBuilder: (ctx, index) {
                final timer = _timers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timer.patientName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    timer.medicationName,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _timers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        LinearProgressIndicator(
                          value: timer.progress,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timer.remainingTimeFormatted,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            if (timer.isRunning)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    timer.pause();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                ),
                                child: Text(l10n.get('pause')),
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    timer.resume();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                ),
                                child: Text(l10n.get('resume')),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Timer Item class to handle individual medication timers
class TimerItem extends ChangeNotifier {
  final String id;
  final String patientName;
  final String medicationName;
  final int durationInSeconds;
  final Function(String) onComplete;

  Timer? _timer;
  int _remainingSeconds;
  bool isRunning = true;
  bool _isCompleted = false;

  TimerItem({
    required this.id,
    required this.patientName,
    required this.medicationName,
    required this.durationInSeconds,
    required this.onComplete,
  }) : _remainingSeconds = durationInSeconds {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else if (!_isCompleted) {
        _isCompleted = true;
        _timer?.cancel();
        onComplete(id);
      }
    });
  }

  void pause() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
      notifyListeners();
    }
  }

  void resume() {
    if (!isRunning && !_isCompleted) {
      _startTimer();
      isRunning = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get progress => 1 - (_remainingSeconds / durationInSeconds);

  String get remainingTimeFormatted {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
