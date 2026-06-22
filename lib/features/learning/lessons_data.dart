class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  const QuizQuestion(this.question, this.options, this.correctIndex);
}

class Lesson {
  final String id;
  final String category;
  final String emoji;
  final String title;
  final String content;
  final List<QuizQuestion> quiz;

  const Lesson({
    required this.id,
    required this.category,
    required this.emoji,
    required this.title,
    required this.content,
    required this.quiz,
  });
}

const lessons = <Lesson>[
  Lesson(
    id: 'climate-change',
    category: 'Climate Change',
    emoji: '🌡️',
    title: 'Understanding Climate Change',
    content:
        'Climate change refers to long-term shifts in temperatures and weather patterns. '
        'Since the industrial era, human activities — mainly burning fossil fuels — have been the main driver, '
        'releasing greenhouse gases that trap heat in the atmosphere. Effects include rising sea levels, '
        'more extreme weather events, and disruptions to ecosystems. Reducing emissions in transport, '
        'energy, food, and waste are key actions everyone can take to help limit warming.',
    quiz: [
      QuizQuestion('What is the main driver of recent climate change?', ['Volcanic activity', 'Human fossil fuel use', 'Ocean currents', 'Solar flares'], 1),
      QuizQuestion('Which gas is most associated with global warming?', ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Helium'], 2),
    ],
  ),
  Lesson(
    id: 'carbon-footprints',
    category: 'Carbon Footprints',
    emoji: '👣',
    title: 'What Is a Carbon Footprint?',
    content:
        'A carbon footprint is the total amount of greenhouse gases produced directly or indirectly by an individual, '
        'organization, or product, measured in CO₂ equivalent (CO₂e). It includes emissions from travel, food, '
        'home energy use, and waste. Tracking your footprint helps identify the biggest sources of impact so you '
        'can make targeted changes — like switching to renewable energy, eating less meat, or driving less.',
    quiz: [
      QuizQuestion('Carbon footprints are measured in units of:', ['Liters', 'CO₂ equivalent', 'Watts', 'Kilometers'], 1),
      QuizQuestion('Which is typically NOT a major source of personal emissions?', ['Travel', 'Food', 'Energy', 'Reading books'], 3),
    ],
  ),
  Lesson(
    id: 'renewable-energy',
    category: 'Renewable Energy',
    emoji: '☀️',
    title: 'The Power of Renewable Energy',
    content:
        'Renewable energy comes from sources that naturally replenish, such as sunlight, wind, and water. '
        'Unlike fossil fuels, renewables produce little to no greenhouse gas emissions during operation. '
        'Solar panels on homes, wind farms, and hydroelectric dams are increasingly common ways to power '
        'communities sustainably. Switching even part of your household energy to renewables can significantly '
        'cut your carbon footprint over time.',
    quiz: [
      QuizQuestion('Which of these is a renewable energy source?', ['Coal', 'Natural gas', 'Solar', 'Diesel'], 2),
      QuizQuestion('A key benefit of renewable energy is:', ['Higher emissions', 'Lower emissions during operation', 'Always cheaper to build', 'Unlimited fossil fuel use'], 1),
    ],
  ),
  Lesson(
    id: 'biodiversity',
    category: 'Biodiversity',
    emoji: '🦋',
    title: 'Why Biodiversity Matters',
    content:
        'Biodiversity refers to the variety of life on Earth, including plants, animals, fungi, and microorganisms. '
        'Healthy ecosystems rely on this diversity to provide clean air, water, pollination, and food. '
        'Climate change, habitat destruction, and pollution threaten biodiversity worldwide. Protecting natural '
        'habitats, reducing waste, and supporting sustainable agriculture all help preserve the delicate balance '
        'of ecosystems that humans depend on.',
    quiz: [
      QuizQuestion('Biodiversity loss is mainly caused by:', ['Habitat destruction and pollution', 'Too much rain', 'More trees', 'Cleaner air'], 0),
      QuizQuestion('Healthy ecosystems provide:', ['Nothing useful', 'Clean air and water', 'Only scenery', 'More pollution'], 1),
    ],
  ),
  Lesson(
    id: 'circular-economy',
    category: 'Circular Economy',
    emoji: '♻️',
    title: 'Introduction to the Circular Economy',
    content:
        'A circular economy is a model that aims to eliminate waste through continual use of resources. '
        'Instead of the traditional "take-make-dispose" approach, products and materials are reused, repaired, '
        'refurbished, and recycled for as long as possible. This reduces the need for new raw materials and '
        'cuts down on landfill waste, helping reduce overall carbon emissions associated with production.',
    quiz: [
      QuizQuestion('The circular economy aims to:', ['Increase waste', 'Eliminate waste through reuse and recycling', 'Use more raw materials', 'Encourage single-use products'], 1),
      QuizQuestion('Which is part of a circular approach?', ['Disposing items after one use', 'Repairing and reusing items', 'Buying more new products', 'Ignoring recycling'], 1),
    ],
  ),
  Lesson(
    id: 'waste-management',
    category: 'Waste Management',
    emoji: '🗑️',
    title: 'Smarter Waste Management',
    content:
        'Effective waste management involves reducing, reusing, and recycling materials before disposal. '
        'Segregating waste into categories like plastic, organic, paper, glass, and e-waste makes recycling '
        'more efficient and reduces contamination. Organic waste sent to landfills produces methane, a potent '
        'greenhouse gas, so composting food scraps can significantly cut emissions from household waste.',
    quiz: [
      QuizQuestion('Composting helps reduce emissions of which gas from landfills?', ['Oxygen', 'Methane', 'Helium', 'Nitrogen'], 1),
      QuizQuestion('Segregating waste makes recycling:', ['Less efficient', 'Impossible', 'More efficient', 'Irrelevant'], 2),
    ],
  ),
  Lesson(
    id: 'sustainable-agriculture',
    category: 'Sustainable Agriculture',
    emoji: '🌾',
    title: 'Sustainable Agriculture Basics',
    content:
        'Sustainable agriculture meets current food needs without compromising future generations. '
        'Practices include crop rotation, reduced pesticide use, efficient water management, and supporting '
        'local, seasonal produce. Diets with less meat and more plant-based foods generally have a lower '
        'carbon footprint, since livestock farming is a significant source of greenhouse gas emissions.',
    quiz: [
      QuizQuestion('Which practice supports sustainable agriculture?', ['Crop rotation', 'Excess pesticide use', 'Wasting water', 'Importing all food'], 0),
      QuizQuestion('Diets with more plant-based foods tend to have:', ['Higher footprints', 'Lower footprints', 'No effect', 'Unmeasurable footprints'], 1),
    ],
  ),
  Lesson(
    id: 'sdgs',
    category: 'SDGs',
    emoji: '🌐',
    title: 'Sustainable Development Goals (SDGs)',
    content:
        'The United Nations Sustainable Development Goals are 17 global goals adopted to achieve a better and '
        'more sustainable future by 2030. They address challenges like poverty, inequality, climate change, '
        'environmental degradation, and peace and justice. Goal 13, Climate Action, directly calls for urgent '
        'action to combat climate change and its impacts — something every individual can contribute to through '
        'everyday sustainable choices.',
    quiz: [
      QuizQuestion('How many SDGs are there?', ['10', '17', '25', '5'], 1),
      QuizQuestion('Which SDG focuses on Climate Action?', ['Goal 1', 'Goal 5', 'Goal 13', 'Goal 17'], 2),
    ],
  ),
];
