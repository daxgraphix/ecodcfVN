/// Simple emission factor based calculator.
/// Factors are approximate kg CO2e per unit, used for educational purposes.
class EmissionCalculator {
  // ---- Travel: kg CO2e per km ----
  static const Map<String, double> travelFactors = {
    'Walking': 0.0,
    'Bicycle': 0.0,
    'Bus': 0.089,
    'Car': 0.192,
    'Flight': 0.255,
    'Ride Share': 0.21,
  };

  static double travelEmissions(String type, double distanceKm, double frequencyPerWeek) {
    final factor = travelFactors[type] ?? 0.15;
    // monthly emissions = distance * factor * frequency * ~4.33 weeks
    return distanceKm * factor * frequencyPerWeek * 4.33;
  }

  // ---- Food: kg CO2e per day, scaled to month (x30) ----
  static const Map<String, double> foodFactorsPerDay = {
    'Vegan': 1.5,
    'Vegetarian': 2.5,
    'Mixed': 4.0,
    'Meat Heavy': 7.2,
  };

  static const Map<String, double> wasteMultiplier = {
    'Low': 1.0,
    'Medium': 1.15,
    'High': 1.35,
  };

  static double foodEmissions(String dietType, String wasteLevel) {
    final base = foodFactorsPerDay[dietType] ?? 4.0;
    final mult = wasteMultiplier[wasteLevel] ?? 1.0;
    return base * mult * 30;
  }

  // ---- Energy ----
  // Electricity: kg CO2e per kWh
  static const double electricityFactorGrid = 0.45;
  static const double electricityFactorSolar = 0.02;
  // Cooking gas: per kg LPG
  static const double cookingGasFactor = 2.98;
  // Charcoal per kg
  static const double charcoalFactor = 3.3;
  // Firewood per kg
  static const double firewoodFactor = 1.5;

  static double energyEmissions({
    required double electricityKwh,
    required bool solar,
    required double cookingGasKg,
    required double charcoalKg,
    required double firewoodKg,
  }) {
    final elecFactor = solar ? electricityFactorSolar : electricityFactorGrid;
    return (electricityKwh * elecFactor) +
        (cookingGasKg * cookingGasFactor) +
        (charcoalKg * charcoalFactor) +
        (firewoodKg * firewoodFactor);
  }

  // ---- Waste: kg CO2e per kg waste per category, scaled to month ----
  static const Map<String, double> wasteFactorsPerKg = {
    'Plastic': 6.0,
    'Organic': 0.5,
    'Paper': 1.3,
    'Glass': 0.9,
    'E-waste': 12.0,
  };

  static double wasteEmissions(String category, double kgPerWeek) {
    final factor = wasteFactorsPerKg[category] ?? 1.0;
    return kgPerWeek * factor * 4.33;
  }

  /// Converts a 0-100 category score from total emissions vs a reference baseline.
  /// Lower emissions => higher score.
  static double scoreFromEmissions(double monthlyKg, double baselineKg) {
    if (baselineKg <= 0) return 100;
    final ratio = monthlyKg / baselineKg;
    final score = 100 * (1 - (ratio - 1)).clamp(0.0, 1.0);
    return score.clamp(0, 100);
  }

  // Equivalencies
  static const double kgPerCarKm = 0.192; // kg CO2e per km driving
  static const double kgPerPhoneCharge = 0.0084; // kg CO2e per phone charge
  static const double kgAbsorbedPerTreePerYear = 21.0; // kg CO2 per tree per year

  static double equivalentCarKm(double kgCo2e) => kgCo2e / kgPerCarKm;
  static double equivalentPhoneCharges(double kgCo2e) => kgCo2e / kgPerPhoneCharge;
  static double equivalentTrees(double kgCo2e) => kgCo2e / kgAbsorbedPerTreePerYear;
}
