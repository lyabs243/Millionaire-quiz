class MoneyManagement {

  List<int> jackpots = [500, 1000, 2000, 3000, 5000, 7500, 10000, 12500, 15000, 25000, 50000, 100000, 250000, 50000,
  1000000];

  /**
   * helps to return the minimum amount compared to a level when the player lost, for example if the player had $ 3000
   * and he failed, his sum will be reduced to $ 500
   */
  List<int> levelsMinimumMoney = [500, 5000, 25000];
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
    return levelsMinimumMoney[level];
  }

  /**
   * transform value to format: 5K 1M 2,5K
   */
  static String moneyDescriptionReduce(int value) {
    String result = '$value';
    if(value >= 1000000) {
      result = (value / 1000000).toString() + 'M';
    }
    else if(value >= 1000) {
      result = (value / 1000).toString() + 'K';
    }
    return result;
  }
}