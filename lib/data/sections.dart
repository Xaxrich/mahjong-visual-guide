class Section {
  final String id;
  final String num;
  final String label;

  const Section({required this.id, required this.num, required this.label});
}

const List<Section> sections = [
  Section(id: 'section-tiles', num: '01', label: 'What are the tiles?'),
  Section(id: 'section-win', num: '02', label: 'How do you win?'),
  Section(id: 'section-draw', num: '03', label: 'How do you draw tiles?'),
  Section(id: 'section-actions', num: '04', label: 'Valid moves on a turn'),
];
