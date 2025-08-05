import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class PrayerTime {
  final String name;
  final String arabicName;
  final String time;
  final bool isNext;

  PrayerTime({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.isNext,
  });
}

class PrayerProvider extends ChangeNotifier {
  List<PrayerTime> _prayerTimes = [];
  String _location = 'Jakarta, Indonesia';
  bool _isLoading = false;
  Position? _currentPosition;

  List<PrayerTime> get prayerTimes => _prayerTimes;
  String get location => _location;
  bool get isLoading => _isLoading;

  Future<void> getCurrentLocation() async {
    try {
      _isLoading = true;
      notifyListeners();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      await _fetchPrayerTimes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Get location error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      if (_currentPosition == null) return;

      final now = DateTime.now();
      final dateString = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      
      final url = '${AppConstants.prayerTimesAPI}/$dateString'
          '?latitude=${_currentPosition!.latitude}'
          '&longitude=${_currentPosition!.longitude}'
          '&method=2';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        
        _prayerTimes = [
          PrayerTime(name: 'Fajr', arabicName: 'الفجر', time: timings['Fajr'], isNext: false),
          PrayerTime(name: 'Dhuhr', arabicName: 'الظهر', time: timings['Dhuhr'], isNext: false),
          PrayerTime(name: 'Asr', arabicName: 'العصر', time: timings['Asr'], isNext: true),
          PrayerTime(name: 'Maghrib', arabicName: 'المغرب', time: timings['Maghrib'], isNext: false),
          PrayerTime(name: 'Isha', arabicName: 'العشاء', time: timings['Isha'], isNext: false),
        ];
        
        _updateNextPrayer();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Fetch prayer times error: $e');
    }
  }

  void _updateNextPrayer() {
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    
    for (int i = 0; i < _prayerTimes.length; i++) {
      final prayerTime = _prayerTimes[i];
      final timeParts = prayerTime.time.split(':');
      final prayerMinutes = int.parse(timeParts[0]) * 60 + int.parse(timeParts[1]);
      
      _prayerTimes[i] = PrayerTime(
        name: prayerTime.name,
        arabicName: prayerTime.arabicName,
        time: prayerTime.time,
        isNext: prayerMinutes > currentTime,
      );
      
      if (prayerMinutes > currentTime) break;
    }
  }

  String calculateTimeUntilNext() {
    final nextPrayer = _prayerTimes.firstWhere(
      (prayer) => prayer.isNext,
      orElse: () => _prayerTimes.first,
    );
    
    final now = DateTime.now();
    final timeParts = nextPrayer.time.split(':');
    final prayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    
    if (prayerTime.isBefore(now)) {
      prayerTime.add(const Duration(days: 1));
    }
    
    final difference = prayerTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    return '${hours}h ${minutes}m';
  }
}