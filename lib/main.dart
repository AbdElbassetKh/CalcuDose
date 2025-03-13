// main.dart - The entry point of your Flutter application

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
// Removed unused import: shared_preferences

void main() {
  runApp(const MedicationApp());
}

class MedicationApp extends StatelessWidget {
  const MedicationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Management',
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Management Tool'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calculate), text: 'Triple Method'),
            Tab(icon: Icon(Icons.water_drop), text: 'Drip Rate'),
            Tab(icon: Icon(Icons.timer), text: 'Medication Timer'),
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

  void _calculateDose() {
    try {
      final double medicationConcentration =
          double.parse(_medicationConcentrationController.text);
      final double diluteVolume = double.parse(_diluteVolumeController.text);
      final double prescribedDose =
          double.parse(_prescribedDoseController.text);

      if (medicationConcentration <= 0 || diluteVolume <= 0) {
        _showErrorDialog('Please enter values greater than zero.');
        return;
      }

      setState(() {
        _resultVolume =
            (prescribedDose / medicationConcentration) * diluteVolume;
        _hasCalculated = true;
      });
    } catch (e) {
      _showErrorDialog('Please enter valid numbers in all fields.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Triple Method Calculator: Calculate the exact volume to administer based on medication concentration and prescribed dose.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _medicationConcentrationController,
            decoration: const InputDecoration(
              labelText: 'Medication Concentration (mg)',
              hintText: 'e.g., 1000',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _diluteVolumeController,
            decoration: const InputDecoration(
              labelText: 'Dilution Volume (ml)',
              hintText: 'e.g., 10',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _prescribedDoseController,
            decoration: const InputDecoration(
              labelText: 'Prescribed Dose (mg)',
              hintText: 'e.g., 700',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _calculateDose,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text('CALCULATE VOLUME',
                style: TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: _resetForm,
            child: const Text('Reset Form'),
          ),
          if (_hasCalculated) ...[
            const SizedBox(height: 24.0),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'RESULT',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Administer ${_resultVolume.toStringAsFixed(2)} ml',
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

  void _calculateDripRate() {
    try {
      final double totalVolume = double.parse(_totalVolumeController.text);
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Drip Rate Calculator: Calculate the drops per minute for intravenous medication administration.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _totalVolumeController,
            decoration: const InputDecoration(
              labelText: 'Total Volume (ml)',
              hintText: 'e.g., 500',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _timeHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
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
                  decoration: const InputDecoration(
                    labelText: 'Minutes',
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
            decoration: const InputDecoration(
              labelText: 'Drop Factor (drops/ml)',
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
            child: const Text('CALCULATE DRIP RATE',
                style: TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: _resetForm,
            child: const Text('Reset Form'),
          ),
          if (_hasCalculated) ...[
            const SizedBox(height: 24.0),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'RESULT',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${_resultDripRate.round()} drops/minute',
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

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Medication Alert!'),
          content: Text(
            '${timer.medicationName} for patient ${timer.patientName} is due now!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                isAcknowledged = true;
                Navigator.of(ctx).pop();
              },
              child: const Text('ACKNOWLEDGE'),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Medication Timer: Set alerts for medication administration to ensure timely patient care.',
                style: TextStyle(fontSize: 16.0),
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
                    decoration: const InputDecoration(
                      labelText: 'Patient Name/ID',
                      hintText: 'e.g., John Doe or Room 101',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _medicationNameController,
                    decoration: const InputDecoration(
                      labelText: 'Medication Name',
                      hintText: 'e.g., Normal Saline 0.9%',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hoursController,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
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
                          decoration: const InputDecoration(
                            labelText: 'Minutes',
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
                    child: const Text('ADD TIMER',
                        style: TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Active Timers',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (_timers.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No active timers'),
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
                                child: const Text('PAUSE'),
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
                                child: const Text('RESUME'),
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
