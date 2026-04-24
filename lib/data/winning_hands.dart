class Meld {
  final String type;
  final List<String> tiles;
  final String label;

  const Meld({required this.type, required this.tiles, required this.label});
}

class WinningHand {
  final String id;
  final String name;
  final String zh;
  final List<Meld> melds;
  final String points;
  final String desc;

  const WinningHand({
    required this.id,
    required this.name,
    required this.zh,
    required this.melds,
    required this.points,
    required this.desc,
  });
}

const List<WinningHand> winningHandsHk = [
  WinningHand(
    id: 'basic',
    name: 'Standard hand',
    zh: '平胡',
    melds: [
      Meld(type: 'chow', tiles: ['wan-2', 'wan-3', 'wan-4'], label: 'Chow · 2-3-4 Characters'),
      Meld(type: 'pung', tiles: ['tiao-5', 'tiao-5', 'tiao-5'], label: 'Pung · 5 Bamboo'),
      Meld(type: 'chow', tiles: ['bing-7', 'bing-8', 'bing-9'], label: 'Chow · 7-8-9 Circles'),
      Meld(type: 'pung', tiles: ['east', 'east', 'east'], label: 'Pung · East Wind'),
      Meld(type: 'pair', tiles: ['red', 'red'], label: 'Pair · Red Dragon'),
    ],
    points: '10 points',
    desc: 'Four sets + one pair. The pair is the "eyes". Any combination of chows and pungs works.',
  ),
  WinningHand(
    id: 'allpungs',
    name: 'All Pungs',
    zh: '對對胡',
    melds: [
      Meld(type: 'pung', tiles: ['wan-3', 'wan-3', 'wan-3'], label: 'Pung · 3 Characters'),
      Meld(type: 'pung', tiles: ['tiao-7', 'tiao-7', 'tiao-7'], label: 'Pung · 7 Bamboo'),
      Meld(type: 'pung', tiles: ['bing-2', 'bing-2', 'bing-2'], label: 'Pung · 2 Circles'),
      Meld(type: 'pung', tiles: ['south', 'south', 'south'], label: 'Pung · South Wind'),
      Meld(type: 'pair', tiles: ['green', 'green'], label: 'Pair · Green Dragon'),
    ],
    points: '30 points',
    desc: 'Every set is a triplet — no runs allowed. A fan/yaku in most rulesets.',
  ),
  WinningHand(
    id: 'purity',
    name: 'All Same Suit',
    zh: '清一色',
    melds: [
      Meld(type: 'chow', tiles: ['bing-1', 'bing-2', 'bing-3'], label: 'Chow · 1-2-3 Circles'),
      Meld(type: 'chow', tiles: ['bing-4', 'bing-5', 'bing-6'], label: 'Chow · 4-5-6 Circles'),
      Meld(type: 'chow', tiles: ['bing-7', 'bing-8', 'bing-9'], label: 'Chow · 7-8-9 Circles'),
      Meld(type: 'pung', tiles: ['bing-2', 'bing-2', 'bing-2'], label: 'Pung · 2 Circles'),
      Meld(type: 'pair', tiles: ['bing-5', 'bing-5'], label: 'Pair · 5 Circles'),
    ],
    points: '80 points',
    desc: 'The entire hand is one suit. No honors, no winds, no dragons. Rare and beautiful.',
  ),
  WinningHand(
    id: 'thirteen',
    name: 'Thirteen Orphans',
    zh: '十三幺',
    melds: [
      Meld(type: 'special', tiles: ['wan-1', 'wan-9', 'tiao-1', 'tiao-9', 'bing-1', 'bing-9', 'east'], label: 'Terminals & honors'),
      Meld(type: 'special', tiles: ['south', 'west', 'north', 'red', 'green', 'white', 'wan-1'], label: 'Plus any duplicate'),
    ],
    points: 'Limit hand',
    desc: 'One of each terminal (1s and 9s) and each honor tile, plus any one of those duplicated. A special hand.',
  ),
];

const List<WinningHand> winningHandsTaiwan = [
  WinningHand(
    id: 'basic',
    name: 'Standard hand',
    zh: '平胡',
    melds: [
      Meld(type: 'chow', tiles: ['wan-2', 'wan-3', 'wan-4'], label: 'Chow · 2-3-4 Characters'),
      Meld(type: 'chow', tiles: ['tiao-3', 'tiao-4', 'tiao-5'], label: 'Chow · 3-4-5 Bamboo'),
      Meld(type: 'chow', tiles: ['bing-6', 'bing-7', 'bing-8'], label: 'Chow · 6-7-8 Circles'),
      Meld(type: 'pung', tiles: ['east', 'east', 'east'], label: 'Pung · East Wind'),
      Meld(type: 'chow', tiles: ['wan-6', 'wan-7', 'wan-8'], label: 'Chow · 6-7-8 Characters'),
      Meld(type: 'pair', tiles: ['red', 'red'], label: 'Pair · Red Dragon'),
    ],
    points: '1 臺',
    desc: 'Five sets + one pair — 17 tiles total. Taiwan hands have one extra meld compared to Hong Kong. You need at least 1 臺 to declare a valid win.',
  ),
  WinningHand(
    id: 'allpungs',
    name: 'All Pungs',
    zh: '對對胡',
    melds: [
      Meld(type: 'pung', tiles: ['wan-3', 'wan-3', 'wan-3'], label: 'Pung · 3 Characters'),
      Meld(type: 'pung', tiles: ['tiao-7', 'tiao-7', 'tiao-7'], label: 'Pung · 7 Bamboo'),
      Meld(type: 'pung', tiles: ['bing-2', 'bing-2', 'bing-2'], label: 'Pung · 2 Circles'),
      Meld(type: 'pung', tiles: ['south', 'south', 'south'], label: 'Pung · South Wind'),
      Meld(type: 'pung', tiles: ['west', 'west', 'west'], label: 'Pung · West Wind'),
      Meld(type: 'pair', tiles: ['green', 'green'], label: 'Pair · Green Dragon'),
    ],
    points: '4 臺',
    desc: 'Every set is a triplet — no runs allowed. A fan/yaku in most rulesets.',
  ),
  WinningHand(
    id: 'purity',
    name: 'All Same Suit',
    zh: '清一色',
    melds: [
      Meld(type: 'chow', tiles: ['bing-1', 'bing-2', 'bing-3'], label: 'Chow · 1-2-3 Circles'),
      Meld(type: 'chow', tiles: ['bing-4', 'bing-5', 'bing-6'], label: 'Chow · 4-5-6 Circles'),
      Meld(type: 'chow', tiles: ['bing-7', 'bing-8', 'bing-9'], label: 'Chow · 7-8-9 Circles'),
      Meld(type: 'pung', tiles: ['bing-2', 'bing-2', 'bing-2'], label: 'Pung · 2 Circles'),
      Meld(type: 'chow', tiles: ['bing-5', 'bing-6', 'bing-7'], label: 'Chow · 5-6-7 Circles'),
      Meld(type: 'pair', tiles: ['bing-5', 'bing-5'], label: 'Pair · 5 Circles'),
    ],
    points: '8 臺',
    desc: 'The entire hand is one suit. No honors, no winds, no dragons. Rare and beautiful.',
  ),
  WinningHand(
    id: 'thirteen',
    name: 'Thirteen Orphans',
    zh: '十三幺',
    melds: [
      Meld(type: 'special', tiles: ['wan-1', 'wan-9', 'tiao-1', 'tiao-9', 'bing-1', 'bing-9', 'east'], label: 'Terminals & honors'),
      Meld(type: 'special', tiles: ['south', 'west', 'north', 'red', 'green', 'white', 'wan-1'], label: 'Plus any duplicate'),
    ],
    points: 'Limit hand',
    desc: 'One of each terminal (1s and 9s) and each honor tile, plus any one of those duplicated. A special hand.',
  ),
];
