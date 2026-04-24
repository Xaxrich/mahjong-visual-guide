class TileInfo {
  final String id;
  final int? num;
  final String zh;
  final String en;

  const TileInfo({required this.id, this.num, required this.zh, required this.en});
}

class SuitMeta {
  final String label;
  final String sub;
  final String desc;

  const SuitMeta({required this.label, required this.sub, required this.desc});
}

const Map<String, List<TileInfo>> tiles = {
  'wan': [
    TileInfo(id: 'wan-1', num: 1, zh: '一萬', en: 'One of Characters'),
    TileInfo(id: 'wan-2', num: 2, zh: '二萬', en: 'Two of Characters'),
    TileInfo(id: 'wan-3', num: 3, zh: '三萬', en: 'Three of Characters'),
    TileInfo(id: 'wan-4', num: 4, zh: '四萬', en: 'Four of Characters'),
    TileInfo(id: 'wan-5', num: 5, zh: '五萬', en: 'Five of Characters'),
    TileInfo(id: 'wan-6', num: 6, zh: '六萬', en: 'Six of Characters'),
    TileInfo(id: 'wan-7', num: 7, zh: '七萬', en: 'Seven of Characters'),
    TileInfo(id: 'wan-8', num: 8, zh: '八萬', en: 'Eight of Characters'),
    TileInfo(id: 'wan-9', num: 9, zh: '九萬', en: 'Nine of Characters'),
  ],
  'tiao': [
    TileInfo(id: 'tiao-1', num: 1, zh: '一條', en: 'One of Bamboo'),
    TileInfo(id: 'tiao-2', num: 2, zh: '二條', en: 'Two of Bamboo'),
    TileInfo(id: 'tiao-3', num: 3, zh: '三條', en: 'Three of Bamboo'),
    TileInfo(id: 'tiao-4', num: 4, zh: '四條', en: 'Four of Bamboo'),
    TileInfo(id: 'tiao-5', num: 5, zh: '五條', en: 'Five of Bamboo'),
    TileInfo(id: 'tiao-6', num: 6, zh: '六條', en: 'Six of Bamboo'),
    TileInfo(id: 'tiao-7', num: 7, zh: '七條', en: 'Seven of Bamboo'),
    TileInfo(id: 'tiao-8', num: 8, zh: '八條', en: 'Eight of Bamboo'),
    TileInfo(id: 'tiao-9', num: 9, zh: '九條', en: 'Nine of Bamboo'),
  ],
  'bing': [
    TileInfo(id: 'bing-1', num: 1, zh: '一餅', en: 'One of Dots'),
    TileInfo(id: 'bing-2', num: 2, zh: '二餅', en: 'Two of Dots'),
    TileInfo(id: 'bing-3', num: 3, zh: '三餅', en: 'Three of Dots'),
    TileInfo(id: 'bing-4', num: 4, zh: '四餅', en: 'Four of Dots'),
    TileInfo(id: 'bing-5', num: 5, zh: '五餅', en: 'Five of Dots'),
    TileInfo(id: 'bing-6', num: 6, zh: '六餅', en: 'Six of Dots'),
    TileInfo(id: 'bing-7', num: 7, zh: '七餅', en: 'Seven of Dots'),
    TileInfo(id: 'bing-8', num: 8, zh: '八餅', en: 'Eight of Dots'),
    TileInfo(id: 'bing-9', num: 9, zh: '九餅', en: 'Nine of Dots'),
  ],
  'wind': [
    TileInfo(id: 'east', zh: '東', en: 'East Wind'),
    TileInfo(id: 'south', zh: '南', en: 'South Wind'),
    TileInfo(id: 'west', zh: '西', en: 'West Wind'),
    TileInfo(id: 'north', zh: '北', en: 'North Wind'),
  ],
  'dragon': [
    TileInfo(id: 'red', zh: '中', en: 'Red Dragon'),
    TileInfo(id: 'green', zh: '發', en: 'Green Dragon'),
    TileInfo(id: 'white', zh: '白', en: 'White Dragon'),
  ],
};

const Map<String, List<TileInfo>> flowerTiles = {
  'flower': [
    TileInfo(id: 'mei', num: 1, zh: '梅', en: 'Plum Blossom'),
    TileInfo(id: 'lan', num: 2, zh: '蘭', en: 'Orchid'),
    TileInfo(id: 'ju', num: 3, zh: '菊', en: 'Chrysanthemum'),
    TileInfo(id: 'zhu', num: 4, zh: '竹', en: 'Bamboo Shoot'),
  ],
  'season': [
    TileInfo(id: 'spring', num: 1, zh: '春', en: 'Spring'),
    TileInfo(id: 'summer', num: 2, zh: '夏', en: 'Summer'),
    TileInfo(id: 'autumn', num: 3, zh: '秋', en: 'Autumn'),
    TileInfo(id: 'winter', num: 4, zh: '冬', en: 'Winter'),
  ],
};

const Map<String, SuitMeta> suitMeta = {
  'wan': SuitMeta(label: 'Characters', sub: '萬 · Wàn', desc: 'Numbered 1–9. The character 萬 means "ten thousand."'),
  'tiao': SuitMeta(label: 'Bamboo', sub: '條 · Tiáo', desc: 'Numbered 1–9. Sticks of bamboo. The 1-bamboo is traditionally drawn as a bird.'),
  'bing': SuitMeta(label: 'Dots', sub: '餅 · Bǐng', desc: 'Numbered 1–9. Circles represent coins, one of the three original suits.'),
  'wind': SuitMeta(label: 'Winds', sub: '風 · Fēng', desc: 'Four winds — East, South, West, North. Honor tiles.'),
  'dragon': SuitMeta(label: 'Dragons', sub: '箭 · Jiàn', desc: 'Three dragons — Red (中), Green (發), White (板). Honor tiles.'),
};

const Map<String, SuitMeta> flowerMeta = {
  'flower': SuitMeta(
    label: 'Flowers',
    sub: '花 · Huā',
    desc: 'Four flower tiles. Each player\'s seat number has a matching flower — drawing your own flower is worth 1 臺 bonus.',
  ),
  'season': SuitMeta(
    label: 'Seasons',
    sub: '季 · Jì',
    desc: 'Four season tiles. Same matching rule as flowers — your seat number matches one season for a 1 臺 bonus.',
  ),
};

TileInfo? findTile(String id, {bool includeFlowers = false}) {
  for (final group in tiles.values) {
    for (final t in group) {
      if (t.id == id) return t;
    }
  }
  if (includeFlowers) {
    for (final group in flowerTiles.values) {
      for (final t in group) {
        if (t.id == id) return t;
      }
    }
  }
  return null;
}
