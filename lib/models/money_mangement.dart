class MoneyManagement {

  static List<int> jackpots = [500, 1000, 2000, 3000, 5000, 7500, 10000, 12500, 15000, 25000, 50000, 100000, 250000, 500000,
  1000000];
  static List<String> jackpotsText = ['           500', '        1 000', '        2 000', '        3 000', '        5 000',
    '        7 500', '      10 000', '      12 500', '      15 000', '      25 000', '      50 000', '   100 000', '   250 000',
    '   500 000', '1 000 000'];
  static List<double> jackpotsPositions = [516, 480, 444, 406, 368, 332, 295, 258, 222, 184, 148, 110, 72, 35, 0];

  /**
   * helps to return the minimum amount compared to a level when the player lost, for example if the player had $ 3000
   * and he failed, his sum will be reduced to $ 500
   */
  static List<int> levelsMinimumMoney = [500, 5000, 25000, 1000000];
  int currentStep = 0;

  /**
   * When user success this will return current money of user
   */
  int stepUp() {
    int money = jackpots[currentStep];
    currentStep++;
    return money;
  }

  /**
   * when player fail to answer question this will return
   * money earning by player
   */
  int playerFail(int level) {
    if(currentStep > 0) {
      currentStep = jackpots.indexOf(levelsMinimumMoney[level]);
      return levelsMinimumMoney[level];
    }
    return 0;
  }

  /**
   * transform value to format: 5K 1M 2,5K
   */
  static String moneyDescriptionReduce(int value) {
    String result = '$value';
    if(value >= 1000000000) {
      result = (value / 1000000000).toStringAsFixed(1) + 'B';
    }
    else if(value >= 1000000) {
      result = (value / 1000000).toStringAsFixed(1) + 'M';
    }
    else if(value >= 1000) {
      result = (value / 1000).toStringAsFixed(1) + 'K';
    }
    result = result.replaceAll('.0', '');
    return result;
  }
}