import 'dart:math';
import 'dungeon.dart';
import 'content.dart';
import 'package:audioplayers/audioplayers.dart';
final _audio = AudioCache();

final Map<int, Map<String, dynamic>> COMMAND_TO_STATUS = {
  0 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
  1 : {"name" : "power_up", "effect" : 5, "range" : "attack_buff", "time" : 10},
  2 : {"name" : "power_down", "effect" : -5, "range" : "attack_buff", "time" : 10},
  3 : {"name" : "defence_up", "effect" : 5, "range" : "defence_buff", "time" : 10},
  4 : {"name" : "defence_down", "effect" : -5, "range" : "defence_buff", "time" : 10},
  5 : {"name" : "poison", "effect" : 0, "range" : "HP", "time" : -1},
};

// 抽選に使う関数
final random = Random();
bool lottery(int num) {
  if(random.nextDouble()*100 <= num) {
    return true;
  } else {
    return false;
  }
}

class Pouch {
  // Itemオブジェクトを格納するクラス
  late var pouch;
  Pouch() {
    this.pouch = List<List<Item>>.generate(
      2, (i) => List<Item>.generate(5, (j) => Item(0)).toList(),
    ).toList();

    // テスト
    this.pouch[0][0] = Item(100);
    this.pouch[0][1] = Item(200);
    this.pouch[0][2] = Item(300);
    // this.pouch[1][0] = Item(102); // 金シリーズ
    // this.pouch[1][1] = Item(152);
    // this.pouch[1][2] = Item(182);
    // this.pouch[1][0] = Item(777); // ハテナブロック
  }

  // どのメソッドを使うか判定するメソッド
  void which(var cIndex, var rIndex) {
    if(this.pouch[cIndex[0]][cIndex[1]].status["type"]==100
    && this.pouch[rIndex[0]][rIndex[1]].status["type"]==100) { // 同じ武器同士だった時
      this.composite(cIndex, rIndex);
    } else if(this.pouch[cIndex[0]][cIndex[1]].status["type"]==200 // 武器と工具だった時
    && this.pouch[rIndex[0]][rIndex[1]].status["type"]==100) {
      this.cure(cIndex, rIndex);
    } else { // 異なる武器同士だった時
      this.swap(cIndex, rIndex);
    }
  }

  // ポーチの中身同士をドラッグ＆ドロップで入れ替えるメソッド
  void swap(var cIndex, var rIndex) {
    _audio.play('drop.mp3');
    final tmp = [...this.pouch];
    Item tmp_item = tmp[cIndex[0]][cIndex[1]];
    tmp[cIndex[0]][cIndex[1]] = tmp[rIndex[0]][rIndex[1]];
    tmp[rIndex[0]][rIndex[1]] = tmp_item;
    this.pouch = tmp;
  }

  // ポーチの武器同士をドラッグ＆ドロップで合成するメソッド
  void composite(var cIndex, var rIndex) {
    if((cIndex[0]!=rIndex[0] || cIndex[1]!=rIndex[1])
        && this.pouch[cIndex[0]][cIndex[1]].status["item_id"]==this.pouch[rIndex[0]][rIndex[1]].status["item_id"]
        && this.pouch[rIndex[0]][rIndex[1]].status["level"] <= 10) {
      _audio.play('composite.mp3');
      final tmp = [...this.pouch];
      tmp[rIndex[0]][rIndex[1]].status["level"] += tmp[cIndex[0]][cIndex[1]].status["level"];
      tmp[rIndex[0]][rIndex[1]].status["attack"] += tmp[cIndex[0]][cIndex[1]].status["level"];
      int stamina1 = tmp[rIndex[0]][rIndex[1]].status["stamina"];
      int stamina2 = tmp[cIndex[0]][cIndex[1]].status["stamina"];
      tmp[rIndex[0]][rIndex[1]].status["stamina"] = (stamina1+stamina2)~/2;
      tmp[cIndex[0]][cIndex[1]] = Item(0);
      this.pouch = tmp;
    } else {
      this.swap(cIndex, rIndex);
    }
  }

  // 装備を直すメソッド
  void cure(var cIndex, var rIndex) {
    _audio.play('composite.mp3');
    final tmp = [...this.pouch];
    int stamina1 = tmp[rIndex[0]][rIndex[1]].status["stamina"] + tmp[cIndex[0]][cIndex[1]].status["effect"];
    int stamina2 = ITEM_ID_TO_STATUS[tmp[rIndex[0]][rIndex[1]].status["item_id"]]!["stamina"]!;
    tmp[rIndex[0]][rIndex[1]].status["stamina"] = min(stamina1, stamina2);
    tmp[cIndex[0]][cIndex[1]] = Item(0);
    this.pouch = tmp;
  }

  // ポーチの中身をフィールドにドラッグ＆ドロップで捨てるメソッド
  void drop(Dungeon dungeon, var pouchIndex, var fieldIndex) {
    final tmp = [...this.pouch];
    Content tmp_item = Content("item", tmp[pouchIndex[0]][pouchIndex[1]].status["item_id"]);
    tmp_item.content = tmp[pouchIndex[0]][pouchIndex[1]]; // レベル等のステータスを引き継がせる
    dungeon.content[fieldIndex[0]][fieldIndex[1]] = tmp_item;
    tmp[pouchIndex[0]][pouchIndex[1]] = Item(0);
    this.pouch = tmp;
  }
}

// プレイヤーのステータスを司るクラス
class Player extends Pouch {
  Map<String,int> status = {
    "HP" : 100,
    "SP" : 100,
    "attack" : 1,
    "attack_buff" : 0,
    "defence" : 0,
    "defence_buff" : 0,
    "stamina" : -1
  };
  Map<String,Item> equipments = {
    "weapon" : Item(100),
    "head" : Item(150),
    "body" : Item(180),
  };
  Map<int, Map<String, dynamic>> conditions = {
    0 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
    1 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
    2 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
    3 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
    4 : {"name" : "None", "effect" : 0, "range" : "None", "time" : -1},
  };

  Player() : super() {
    this.update();
  }

  // プレイヤーのステータスを更新するメソッド
  void update() {
    // 攻撃力
    this.status["attack"] = (this.equipments["weapon"]!.name!="None" // 装備なしの時
        ? this.equipments["weapon"]?.status["attack"]
        : 1)!;
    this.status["attack"] = (this.status["attack"]! + this.status["attack_buff"]!);
    this.status["attack"] = (this.status["attack"]! < 1 // 1より下がらないようにする
        ? 1
        : this.status["attack"])!;

    // 分散
    this.status["variance"] = (this.equipments["weapon"]!.name!="None" // 装備なしの時
        ? this.equipments["weapon"]?.status["variance"]
        : 0)!;

    // 防御力
    int? head = this.equipments["head"]!.name!="None" // 装備なしの時
        ? this.equipments["head"]!.status["defence"]
        : 0;
    int? body = this.equipments["body"]!.name!="None" // 装備なしの時
      ? this.equipments["body"]!.status["defence"]
      : 0;
    this.status["defence"] = (head! + body!);
    this.status["defence"] = (this.status["defence"]! + this.status["defence_buff"]!);
    this.status["defence"] = (this.status["defence"]! < 1 // 1より下がらないようにする
        ? 1
        : this.status["defence"])!;
  }

  // プレイヤーがダメージを受ける
  // void damage(int effect) {
  //   this.status["HP"] = (this.status["HP"]! - effect);
  //   if() {
  //
  //   }
  // }

  // 装備をつけるor入れ替えるメソッド
  void equip_equipments(var equipment, var rIndex) {
    if(this.equipments[equipment]?.name != "") { // 装備をすでにつけている場合
      final tmp = [...this.pouch];
      var tmp_item = this.equipments[equipment];
      this.equipments[equipment] = tmp[rIndex[0]][rIndex[1]];
      tmp[rIndex[0]][rIndex[1]] = tmp_item;
      this.pouch = tmp;
    } else if(this.pouch[rIndex[0]][rIndex[1]].status["type"] == ITEM_ID_TO_EQUIP[equipment]) { // 装備をつけていない&ドラッグしたものが装備品の場合
      final tmp = [...this.pouch];
      this.equipments[equipment] = tmp[rIndex[0]][rIndex[1]];
      tmp[rIndex[0]][rIndex[1]] = Item(0);
      this.pouch = tmp;
    }

    this.update();
  }

  // 装備を外してポーチに入れるメソッド
  void exit_equipments(var equipment) {
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 5; j++) {
        if (this.pouch[i][j].status["item_id"] == 0) { // ポーチに空きがある時
          this.pouch[i][j] = this.equipments[equipment];
          this.equipments[equipment] = Item(0);
          break;
        }
      }
    }

    this.update();
  }

  // 装備をつけたまま合成するメソッド
  void composite_equipments(var equipment, var rIndex) {
    if(this.pouch[rIndex[0]][rIndex[1]].status["item_id"] == this.equipments["weapon"]!.status["item_id"]) {
      _audio.play('composite.mp3');
      final tmp = [...this.pouch];
      int tmp_int = tmp[rIndex[0]][rIndex[1]].status["level"];
      this.equipments["weapon"]!.status["level"] = this.equipments["weapon"]!.status["level"]! + tmp_int;
      this.equipments["weapon"]!.status["attack"] = (this.equipments["weapon"]!.status["attack"]! + 1);
      this.equipments["weapon"]!.status["stamina"] = min(
          ITEM_ID_TO_STATUS[this.equipments["weapon"]!.status["type"]!]!["stamina"]!,
        (this.equipments["weapon"]!.status["stamina"]! + tmp[rIndex[0]][rIndex[1]].status["stamina"]!) ~/ 2 + 1
      );
      tmp[rIndex[0]][rIndex[1]] = Item(0);
      this.pouch = tmp;
    }

    this.update();
  }

  // 装備を直すメソッド
  void cure_equipments(var equipment, var rIndex) {
    _audio.play('composite.mp3');
    final tmp = [...this.pouch];
    int? stamina1 = (this.equipments["weapon"]!.status["stamina"]! + tmp[rIndex[0]][rIndex[1]].status["effect"]) as int?;
    int stamina2 = ITEM_ID_TO_STATUS[this.equipments["weapon"]!.status["item_id"]]!["stamina"]!;
    this.equipments["weapon"]!.status["stamina"] = min(stamina1!, stamina2);
    tmp[rIndex[0]][rIndex[1]] = Item(0);
    this.pouch = tmp;
  }

  // 装備が壊れるメソッド
  void break_equipments() {
    if(this.status["attack"]! > 1) { // 武器を装備している時(素手でない時)
      this.equipments["weapon"]!.status["stamina"] = (this.equipments["weapon"]!.status["stamina"]! - 1);
      if(this.equipments["weapon"]!.status["stamina"] == 0) {
        _audio.play('weapon_break.mp3');
        this.equipments["weapon"] = Item(0);
        this.update();
      }
    }
  }

  // 状態異常を付与するメソッド
  void add_conditions(var rIndex, Map<String, dynamic> condition) {
    for (int i = 0; i < this.conditions.length; i++) {
      if(this.conditions[i]!["name"] == "None") {
        this.conditions[i] = {...condition};
        this.status[condition["range"]] = this.status[condition["range"]]! + condition["effect"] as int;
        this.pouch[rIndex[0]][rIndex[1]] = Item(0);
        this.update();
        break;
      }
    }
  }

  // 状態異常を除去するメソッド
  void sub_conditions(int index) {
    // print("sub_conditionsを発動！");
    this.status[this.conditions[index]!["range"]] = this.status[this.conditions[index]!["range"]]! - this.conditions[index]!["effect"] as int;
    this.conditions[index] = COMMAND_TO_STATUS[0]!;
    this.update();
  }

  // ハテナボックスを使った時のラッキールーレット
  void lucky_roulette(var rIndex) {
    var lucky = random.nextInt(3)+1;
    add_conditions(rIndex, COMMAND_TO_STATUS[lucky]!);
  }
}