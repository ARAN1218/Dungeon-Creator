import 'dart:math' as math;
import 'dungeon.dart';
import 'package:audioplayers/audioplayers.dart';
final _audio = AudioCache();


// アイテム系(type)
// 100...武器
// 200...ガシェット
// 300...食べ物
// 400...薬
// 777...ラッキールーレット
final List<int> ITEM_ID_LIST = [
  100,101,102, // 武器
  150,151,152, // 頭装備
  180,181,182, // 体装備
  200, // 工具
  300,301, // 食べ物
  400, 401, 402, 403, // 薬
  777 // ハテナブロック
]; // 0は入れない

final Map<int, String> ITEM_ID_TO_NAME_MAP = {
  0 : "None", // アイテム無し
  100 : "bronze_sword",
  101 : "silver_sword",
  102 : "gold_sword",
  150 : "bronze_helmet",
  151 : "silver_helmet",
  152 : "gold_helmet",
  180 : "bronze_armor",
  181 : "silver_armor",
  182 : "gold_armor",
  200 : "tool",
  300 : "hato_shortbread",
  301 : "zunda",
  400 : "attack_medicine",
  401 : "defence_medicine",
  402 : "hp_medicine",
  403 : "sp_medicine",
  777 : "hatena"
};

final Map<int, Map<String, int>> ITEM_ID_TO_STATUS = {
  0 : {"type" : 0},
  100 : {"type" : 100, "rare" : 10, "level" : 1, "attack" : 10, "variance" : 3, "stamina" : 20},
  101 : {"type" : 100, "rare" : 5, "level" : 1, "attack" : 15, "variance" : 2, "stamina" : 10},
  102 : {"type" : 100, "rare" : 1, "level" : 1, "attack" : 20, "variance" : 1, "stamina" : 5},
  150 : {"type" : 110, "rare" : 10, "defence" : 5, "command" : 0},
  151 : {"type" : 110, "rare" : 3, "defence" : 10, "command" : 0},
  152 : {"type" : 110, "rare" : 1, "defence" : 20, "command" : 0},
  180 : {"type" : 111, "rare" : 10, "defence" : 5, "command" : 0},
  181 : {"type" : 111, "rare" : 5, "defence" : 10, "command" : 0},
  182 : {"type" : 111, "rare" : 1, "defence" : 20, "command" : 0},
  200 : {"type" : 200, "rare" : 10, "command" : 0, "effect" : 10}, // 逐一確認して個別対応します...?
  300 : {"type" : 300, "rare" : 7, "HP_effect" : 15, "SP_effect" : 10},
  301 : {"type" : 300, "rare" : 7, "HP_effect" : 5, "SP_effect" : 25},
  400 : {"type" : 400, "rare" : 3, "command" : 1},
  401: {"type" : 400, "rare" : 3, "command" : 3},
  402: {"type" : 400, "rare" : 3, "command" : 5},
  403: {"type" : 400, "rare" : 3, "command" : 6},
  777 : {"type" : 777, "rare" : 7, "command" : 777}
};

// アイテム抽選の抽選袋
final List<int> ITEM_LOTTERY_LIST = [
  for(int item_id in ITEM_ID_LIST) for(int j=0; j<ITEM_ID_TO_STATUS[item_id]!["rare"]!; j++) item_id
];

// contentの抽選に使う関数
final random = math.Random();
bool lottery(int num) {
  if(random.nextDouble()*100 <= num) {
    return true;
  } else {
    return false;
  }
}

final Map<String, int> ITEM_ID_TO_EQUIP = {
  "weapon" : 100,
  "head" : 110,
  "body" : 111,
};

// モンスター系
final List<int> MONSTER_ID_LIST = [-1,-2,-3,-4,-5,-6,-7,-8,-9,-10];
final List<int> MONSTER_ID_LIST_easy = [
  -1,-2,-3
];
final List<int> MONSTER_ID_LIST_normal = [
  -1,-2,-3,-4,-5,-6,-7,-8,-9,-10
];
final List<int> MONSTER_ID_LIST_hard = [
  -4,-5,-6,-7,-8,-9,-10
];

final Map<int, String> MONSTER_ID_TO_NAME_MAP = {
  -1 : "slime",
  -2 : "zombie",
  -3 : "trawl",
  -4 : "slimedu",
  -5 : "skeleton",
  -6 : "snowman",
  -7 : "spider_poison",
  -8 : "spider_burn",
  -9 : "spider_palsy",
  -10 : "spider_freeze",

};
final Map<int, Map<String, int>> MONSTER_ID_TO_STATUS = {
  -1 : {"attack" : 10, "HP" : 10, "speed" : 2, "command" : -1},
  -2 : {"attack" : 15, "HP" : 20, "speed" : 3, "command" : -1},
  -3 : {"attack" : 20, "HP" : 30, "speed" : 4, "command" : -1},
  -4 : {"attack" : 10, "HP" : 10, "speed" : 2, "command" : -2},
  -5 : {"attack" : 15, "HP" : 15, "speed" : 2, "command" : -4},
  -6 : {"attack" : 20, "HP" : 40, "speed" : 4, "command" : -5},
  -7 : {"attack" : 10, "HP" : 15, "speed" : 3, "command" : -2},
  -8 : {"attack" : 10, "HP" : 15, "speed" : 3, "command" : -3},
  -9 : {"attack" : 10, "HP" : 15, "speed" : 3, "command" : -4},
  -10 : {"attack" : 10, "HP" : 15, "speed" : 3, "command" : -5},
};
final Map<int, Map<String, dynamic>> MONSTER_COMMAND_TO_STATUS = {
  -1 : {"name" : "bleeding", "con_damage" : 3, "effect" : -3, "range" : "HP", "time" : 5, "prob" : 5}, // 出血
  -2 : {"name" : "poison", "con_damage" : 3, "effect" : -3, "range" : "HP", "time" : 5, "prob" : 20}, // 毒
  -3 : {"name" : "burn", "con_damage" : 2, "effect" : -2, "range" : "attack_buff", "time" : 5, "prob" : 30}, // 火傷
  -4 : {"name" : "palsy", "con_damage" : 1, "effect" : 1, "range" : "stamina", "time" : 5, "prob" : 20}, // 麻痺
  -5 : {"name" : "freeze", "con_damage" : 0, "effect" : -20, "range" : "defence_buff", "time" : 5, "prob" : 10}, // 凍結...いすれはダメージ2倍に仕様変更するかも
  -6 : {"name" : "confusion", "con_damage" : 0, "effect" : 3, "range" : "variance_buff", "time" : 10, "prob" : 20}, // 混乱
};

// アイテムクラス
// 各アイテムそれぞれとして振る舞うオブジェクトが必要なので作る
class Item {
  late var name;
  late Map<String, int> status;
  Item(int item_id) {
    var tmp;
    name = ITEM_ID_TO_NAME_MAP[item_id];
    tmp = ITEM_ID_TO_STATUS[item_id];
    status = {...tmp};
    status["item_id"] = item_id;
  }

  // プレイヤーを回復するアイテム処理メソッド
  void cure(Dungeon dungeon, var Index) {
    dungeon.player.status["HP"] = math.min(
      (dungeon.player.status["HP"]! + this.status["HP_effect"]!),
      100
    );
    dungeon.player.status["SP"] = math.min(
        (dungeon.player.status["SP"]! + this.status["SP_effect"]!),
        100
    );
    dungeon.player.pouch[Index[0]][Index[1]] = Item(0);
  }

  String show() {
    var level = this.status["level"];
    var stamina = this.status["stamina"];
    return this.status["type"]==100
        ? "\nL:$level\nS:$stamina"
        : "";
  }
}

// モンスタークラス
class Monster {
  late var name;
  late int timer;
  late Map<String, int> status;
  // 該当のモンスターになりきる
  Monster(int monster_id) {
    var tmp;
    name = MONSTER_ID_TO_NAME_MAP[monster_id];
    tmp = MONSTER_ID_TO_STATUS[monster_id];
    status = {...tmp};
    timer = status["speed"]!;
  }

  String show() {
    return "(" + this.timer.toString() + ")";
  }

  // モンスターがダメージを受けるメソッド
  void damage(Dungeon dungeon, var ij, int damage) {
    damage = damage < 1 // ダメージが1より小さくならないようにする
        ? 1
        : damage;
    print("$name に $damage ダメージを与えた！");
    dungeon.addScore(math.min(this.status["HP"]!, damage));
    this.status["HP"] = (this.status["HP"]! - damage);
    // print(min(this.status["HP"]!, damage));
    dungeon.player.break_equipments();

    if(this.status["HP"]! <= 0) { // モンスターのHPが0になった時
      dungeon.content[ij[0]][ij[1]] = Content("None", 0);
      // print("$name をやっつけた！");
    } // else { // 自身の攻撃と合わせて攻撃させたいなら起動
    //   this.attack(dungeon);
    // }
  }

  // モンスターが攻撃するメソッド
  void attack(Dungeon dungeon) {
    _audio.play('monster_attack.mp3');
    int damage = (this.status["attack"]! * (1-dungeon.player.status["defence"]!/100)).toInt();
    dungeon.player.status["HP"] = dungeon.player.status["HP"]! - damage;
    // print("$name は冒険者に $damage ダメージを与えた！");

    // 確率で状態異常を発生させる
    if(lottery(MONSTER_COMMAND_TO_STATUS[this.status["command"]]!["prob"])) {
      dungeon.player.add_conditions("bad", MONSTER_COMMAND_TO_STATUS[this.status["command"]]!);
    }

    // 確率で防具が壊れる
    if(dungeon.player.equipments["head"]?.name!="None" && lottery(5)){
      _audio.play('weapon_break.mp3');
      dungeon.player.equipments["head"] = Item(0);
      dungeon.player.update();
    }
    if(dungeon.player.equipments["body"]?.name!="None" && lottery(5)){
      _audio.play('weapon_break.mp3');
      dungeon.player.equipments["body"] = Item(0);
      dungeon.player.update();
    }
  }
}

// アイテム・モンスタークラス
class Content {
  late var content;
  late var type;
  Content(String type, int id) {
    this.type = type;
    if(type == "item") {
      content = Item(id);
    } else if (type == "monster") {
      content = Monster(id);
    } else if (id == GOAL) { // ゴールの時
      content = GOAL;
    } else {
      content = Item(0);
    }
  }

  // メソッド系
  int item_lottery() {
    return ITEM_LOTTERY_LIST[random.nextInt(ITEM_LOTTERY_LIST.length)];
  }
  int monster_lottery() {
    return MONSTER_ID_LIST[random.nextInt(MONSTER_ID_LIST.length)];
  }
  Content content_lottery(int num) {
    if(0<=num && num<=79) {
      return Content("None", 0);
    } else if (80<=num && num<=89) {
      return Content("item", item_lottery());
    } else {
      return Content("monster", monster_lottery());
    }
  }

  String show() {
    if(this.content is int) {
      return "";
    } else if (this.content == GOAL) {
      return "GOAL";
    } else {
      return this.content.show();
    }
  }
}