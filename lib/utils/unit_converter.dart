enum WeightUnit { kg, g, mg }

enum VolumeUnit { l, ml, cc, drops }

class UnitConverter {
  static double convertWeight(double value, WeightUnit from, WeightUnit to) {
    // Convert to mg first
    double inMg = value;
    switch (from) {
      case WeightUnit.kg:
        inMg = value * 1000000;
        break;
      case WeightUnit.g:
        inMg = value * 1000;
        break;
      case WeightUnit.mg:
        inMg = value;
        break;
    }

    // Convert from mg to target unit
    switch (to) {
      case WeightUnit.kg:
        return inMg / 1000000;
      case WeightUnit.g:
        return inMg / 1000;
      case WeightUnit.mg:
        return inMg;
    }
  }

  static double convertVolume(double value, VolumeUnit from, VolumeUnit to) {
    // Convert to ml first
    double inMl = value;
    switch (from) {
      case VolumeUnit.l:
        inMl = value * 1000;
        break;
      case VolumeUnit.ml:
      case VolumeUnit.cc:
        inMl = value;
        break;
      case VolumeUnit.drops:
        inMl = value / 20; // Assuming 20 drops = 1 ml
        break;
    }

    // Convert from ml to target unit
    switch (to) {
      case VolumeUnit.l:
        return inMl / 1000;
      case VolumeUnit.ml:
      case VolumeUnit.cc:
        return inMl;
      case VolumeUnit.drops:
        return inMl * 20;
    }
  }

  // Helper pour obtenir le symbole de l'unité
  static String getWeightSymbol(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kg:
        return 'kg';
      case WeightUnit.g:
        return 'g';
      case WeightUnit.mg:
        return 'mg';
    }
  }

  static String getVolumeSymbol(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.l:
        return 'L';
      case VolumeUnit.ml:
        return 'mL';
      case VolumeUnit.cc:
        return 'cc';
      case VolumeUnit.drops:
        return 'gttes';
    }
  }
}
