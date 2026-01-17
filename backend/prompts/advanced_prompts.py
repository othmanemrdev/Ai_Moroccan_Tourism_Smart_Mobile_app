"""
Advanced Prompt Templates for Zorbladi.ma
Implements: Few-Shot, Chain-of-Thought, Knowledge Generation
"""

# ============================================================================
# KNOWLEDGE BASES
# ============================================================================

MOROCCAN_FOOD_KNOWLEDGE = """
MOROCCAN CUISINE KNOWLEDGE BASE:
- Morocco has 8 distinct culinary regions (Fes, Marrakech, Casablanca, Tangier, etc.)
- Common cooking methods: slow-cooking (tagine), steaming (couscous), baking in clay ovens
- Essential spices: cumin, saffron, cinnamon, ginger, ras el hanout (blend of 20+ spices)
- Staple ingredients: couscous, lamb, chicken, vegetables, preserved lemons, olives
- Traditional dishes: Tagine, Couscous, Harira, Pastilla, Mechoui, Rfissa, Zaalouk
- Meal structure: Often starts with salads, main dish, ends with mint tea and pastries
"""

MOROCCAN_MONUMENTS_KNOWLEDGE = """
MOROCCAN MONUMENTS KNOWLEDGE BASE:
- Morocco has 9 UNESCO World Heritage Sites
- Architectural styles: Moorish, Almohad, Alaouite, Merinid, Saadian
- Common features: zellige (mosaic tilework), carved cedar, intricate stucco, horseshoe arches
- Famous monuments: Hassan II Mosque, Koutoubia, Hassan Tower, Bahia Palace, Kasbah of Ait Benhaddou
- Imperial Cities: Fes, Marrakech, Meknes, Rabat (each with distinct architectural heritage)
- Religious sites: Most mosques closed to non-Muslims (except Hassan II Mosque in Casablanca)
"""

# ============================================================================
# FEW-SHOT EXAMPLES
# ============================================================================

FOOD_FEW_SHOT_EXAMPLES = """
EXAMPLE 1:
Image Description: Orange-red stew in conical clay pot with visible meat chunks and vegetables
Analysis Process:
1. Conical clay pot = traditional tagine cookware
2. Slow-cooked appearance with rich sauce
3. Meat and vegetables visible
4. Traditional Moroccan spice coloring (saffron/paprika)
Result: {
  "name": "Tagine",
  "type": "Main Dish",
  "description": "Traditional Moroccan slow-cooked stew prepared in a conical clay pot. Features tender meat (usually lamb or chicken) with vegetables and aromatic spices.",
  "ingredients": ["lamb or chicken", "vegetables (carrots, potatoes, onions)", "preserved lemons", "olives", "saffron", "cumin"],
  "region": "National dish, found throughout Morocco",
  "confidence": 0.95
}

EXAMPLE 2:
Image Description: Steamed grain with vegetables, chickpeas, and meat on top
Analysis Process:
1. Fine grain texture = semolina couscous
2. Seven vegetables tradition visible
3. Chickpeas and meat topping
4. Friday tradition dish
Result: {
  "name": "Couscous",
  "type": "Main Dish",
  "description": "Steamed semolina grain served with seven vegetables, chickpeas, and meat. Traditional Friday family meal in Morocco.",
  "ingredients": ["semolina", "seven vegetables", "chickpeas", "lamb or chicken", "ras el hanout"],
  "region": "National dish, especially popular in Fes",
  "confidence": 0.92
}

EXAMPLE 3:
Image Description: Thick soup with tomato base, visible lentils, chickpeas, and herbs
Analysis Process:
1. Thick, hearty soup consistency
2. Tomato-based broth
3. Lentils and chickpeas visible
4. Fresh herbs (cilantro/parsley)
Result: {
  "name": "Harira",
  "type": "Soup",
  "description": "Traditional Moroccan soup made with tomatoes, lentils, chickpeas, and lamb. Especially popular during Ramadan to break the fast.",
  "ingredients": ["tomatoes", "lentils", "chickpeas", "lamb", "cilantro", "parsley", "spices"],
  "region": "National dish, Ramadan tradition",
  "confidence": 0.90
}
"""

MONUMENT_FEW_SHOT_EXAMPLES = """
EXAMPLE 1:
Image Description: Large mosque with towering minaret, white and green colors, ocean view
Analysis Process:
1. Massive scale and modern construction
2. Minaret over 200m tall
3. Oceanfront location
4. Green tile roof and white marble
5. One of few mosques open to non-Muslims
Result: {
  "name": "Hassan II Mosque",
  "type": "Mosque",
  "city": "Casablanca",
  "description": "One of the largest mosques in the world, built partially over the Atlantic Ocean. Features the world's tallest minaret at 210 meters. Completed in 1993.",
  "architectural_style": "Moorish with modern elements",
  "historical_period": "Contemporary (1993)",
  "confidence": 0.98
}

EXAMPLE 2:
Image Description: Square minaret with intricate geometric patterns, red-brown color, Marrakech medina
Analysis Process:
1. Square minaret (Almohad style)
2. 77 meters tall
3. Geometric zellige patterns
4. Located in Marrakech medina
5. Symbol of the city
Result: {
  "name": "Koutoubia Mosque",
  "type": "Mosque/Minaret",
  "city": "Marrakech",
  "description": "The largest mosque in Marrakech, famous for its 77-meter minaret visible throughout the city. Built in the 12th century during the Almohad dynasty.",
  "architectural_style": "Almohad",
  "historical_period": "12th century (1158)",
  "confidence": 0.95
}

EXAMPLE 3:
Image Description: Ornate palace with colorful tiles, carved wood, and courtyard with fountain
Analysis Process:
1. Intricate zellige tilework
2. Carved cedar ceilings
3. Central courtyard with fountain
4. 19th century Moroccan palace style
5. Located in Marrakech medina
Result: {
  "name": "Bahia Palace",
  "type": "Palace",
  "city": "Marrakech",
  "description": "19th-century palace built for Si Moussa, Grand Vizier of Sultan Hassan I. Features stunning Moroccan and Islamic architecture with beautiful gardens.",
  "architectural_style": "Alaouite with Andalusian influences",
  "historical_period": "19th century (1880s)",
  "confidence": 0.93
}
"""

# ============================================================================
# ADVANCED PROMPTS
# ============================================================================

def get_food_classification_prompt():
    """
    Few-Shot + Knowledge Generation + Chain-of-Thought
    """
    return f"""You are an expert in Moroccan cuisine with deep cultural and culinary knowledge.

{MOROCCAN_FOOD_KNOWLEDGE}

{FOOD_FEW_SHOT_EXAMPLES}

NOW ANALYZE THIS NEW IMAGE:

Use Chain-of-Thought reasoning:
Step 1: Identify the cooking vessel, presentation style, and plating
Step 2: Recognize key ingredients, colors, and textures
Step 3: Match visual cues with known Moroccan dishes from your knowledge base
Step 4: Consider regional variations and preparation methods
Step 5: Estimate confidence based on distinctive features

Provide your analysis in this exact JSON format:
{{
  "name": "Dish name in English",
  "type": "Category (Main Dish, Soup, Appetizer, Dessert, Pastry)",
  "description": "Detailed description including cultural context and traditional preparation",
  "ingredients": ["ingredient1", "ingredient2", "ingredient3"],
  "region": "Region or city where this dish is most popular",
  "confidence": 0.XX,
  "reasoning": "Brief explanation of how you identified this dish"
}}

Be specific and accurate. If uncertain, indicate lower confidence and explain why.
"""

def get_monument_classification_prompt():
    """
    Few-Shot + Knowledge Generation + Chain-of-Thought
    """
    return f"""You are an expert in Moroccan architecture and historical monuments.

{MOROCCAN_MONUMENTS_KNOWLEDGE}

{MONUMENT_FEW_SHOT_EXAMPLES}

NOW ANALYZE THIS NEW IMAGE:

Use Chain-of-Thought reasoning:
Step 1: Identify architectural style (Moorish, Almohad, Alaouite, etc.)
Step 2: Look for distinctive features (minaret shape, tilework, arches, materials)
Step 3: Determine approximate historical period based on construction techniques
Step 4: Match with known Moroccan monuments from your knowledge base
Step 5: Consider location clues (city landmarks, surrounding architecture)
Step 6: Estimate confidence based on unique identifying features

Provide your analysis in this exact JSON format:
{{
  "name": "Monument name in English",
  "type": "Category (Mosque, Palace, Fortress, Gate, Madrasa, etc.)",
  "city": "City name",
  "description": "Detailed description including historical significance and architectural features",
  "architectural_style": "Primary architectural style",
  "historical_period": "Century or specific year of construction",
  "confidence": 0.XX,
  "reasoning": "Brief explanation of how you identified this monument"
}}

Be specific and accurate. If uncertain, indicate lower confidence and explain why.
"""

def get_itinerary_generation_prompt(city: str, days: int, budget: str = "medium", interests: str = "cultural"):
    """
    Chain-of-Thought + Few-Shot + Knowledge Generation
    """
    
    few_shot_example = """
EXAMPLE ITINERARY (Fes, 2 days):

Day 1: Medina & Historical Sites
  Morning (9:00-12:00):
    - 9:00: Start at Bab Boujloud (Blue Gate) - iconic entrance to Fes el-Bali
    - 9:30: Walk through Talaa Kebira street, observe artisan workshops
    - 10:30: Visit Al-Qarawiyyin University (exterior) - world's oldest university
    - 11:30: Explore Attarine Madrasa - stunning zellige and carved wood
  
  Lunch (12:30-14:00):
    - Traditional restaurant in the Medina (Tagine or Couscous)
    - Estimated cost: 80-120 MAD per person
  
  Afternoon (14:00-17:30):
    - 14:00: Bou Inania Madrasa - masterpiece of Merinid architecture
    - 15:00: Nejjarine Museum of Wooden Arts & Crafts
    - 16:00: Chouara Tannery (view from terrace) - traditional leather dyeing
    - 17:00: Shopping in the souks (leather goods, ceramics, spices)
  
  Evening (19:00-21:00):
    - Dinner at rooftop restaurant with Medina view
    - Mint tea and pastries

Day 2: Royal Fes & Jewish Quarter
  Morning (9:00-12:00):
    - 9:00: Royal Palace (Dar el-Makhzen) - view golden doors (exterior only)
    - 10:00: Mellah (Jewish Quarter) - historic synagogues and cemetery
    - 11:00: Jnan Sbil Gardens - peaceful royal gardens
  
  Lunch (12:30-14:00):
    - Local café or restaurant near Ville Nouvelle
  
  Afternoon (14:00-17:00):
    - 14:00: Borj Nord - fortress with panoramic city views and arms museum
    - 15:30: Last-minute shopping or relaxation
    - 16:30: Prepare for departure
"""
    
    return f"""Create a detailed {days}-day itinerary for {city}, Morocco with a {budget} budget focusing on {interests} interests.

MOROCCAN TRAVEL KNOWLEDGE:
- Best visiting hours: 9 AM - 6 PM for most sites
- Lunch break: 12:30 - 2:30 PM (most restaurants)
- Friday: Many sites close for prayer (1-3 PM)
- Summer: Very hot afternoons, plan indoor activities
- Ramadan: Reduced hours, respect fasting
- Budget levels: 
  * Budget: 200-400 MAD/day (local food, public transport, free sites)
  * Medium: 400-800 MAD/day (mid-range restaurants, petit taxis, paid attractions)
  * Luxury: 800+ MAD/day (fine dining, private guides, premium experiences)

{few_shot_example}

NOW CREATE ITINERARY FOR {city}:

Think step by step (Chain-of-Thought):
Step 1: List the top 10-15 must-see attractions in {city} matching {interests} interests
Step 2: Group attractions by geographical proximity (North, South, Medina, New City, etc.)
Step 3: Estimate realistic travel times between locations (walking: 15-30min, taxi: 10-20min)
Step 4: Balance cultural sites, food experiences, shopping, and rest periods
Step 5: Consider optimal visiting times (morning for outdoor sites, afternoon for museums)
Step 6: Assign attractions to days, ensuring logical flow and avoiding backtracking
Step 7: Include meal breaks with {budget} budget-appropriate restaurant recommendations
Step 8: Add practical tips (transport, timing, estimated costs in MAD)

Provide the itinerary in this JSON format:
{{
  "Day 1": [
    {{
      "time": "9:00-12:00",
      "activity": "Detailed activity description with specific sites",
      "tips": "Practical advice (transport, costs, what to bring)"
    }},
    ...
  ],
  "Day 2": [...],
  ...
}}

Make it realistic, culturally rich, practical for tourists, and aligned with {budget} budget and {interests} interests.
"""
    """
    Chain-of-Thought + Few-Shot + Knowledge Generation
    """
    
    few_shot_example = """
EXAMPLE ITINERARY (Fes, 2 days):

Day 1: Medina & Historical Sites
  Morning (9:00-12:00):
    - 9:00: Start at Bab Boujloud (Blue Gate) - iconic entrance to Fes el-Bali
    - 9:30: Walk through Talaa Kebira street, observe artisan workshops
    - 10:30: Visit Al-Qarawiyyin University (exterior) - world's oldest university
    - 11:30: Explore Attarine Madrasa - stunning zellige and carved wood
  
  Lunch (12:30-14:00):
    - Traditional restaurant in the Medina (Tagine or Couscous)
    - Estimated cost: 80-120 MAD per person
  
  Afternoon (14:00-17:30):
    - 14:00: Bou Inania Madrasa - masterpiece of Merinid architecture
    - 15:00: Nejjarine Museum of Wooden Arts & Crafts
    - 16:00: Chouara Tannery (view from terrace) - traditional leather dyeing
    - 17:00: Shopping in the souks (leather goods, ceramics, spices)
  
  Evening (19:00-21:00):
    - Dinner at rooftop restaurant with Medina view
    - Mint tea and pastries

Day 2: Royal Fes & Jewish Quarter
  Morning (9:00-12:00):
    - 9:00: Royal Palace (Dar el-Makhzen) - view golden doors (exterior only)
    - 10:00: Mellah (Jewish Quarter) - historic synagogues and cemetery
    - 11:00: Jnan Sbil Gardens - peaceful royal gardens
  
  Lunch (12:30-14:00):
    - Local café or restaurant near Ville Nouvelle
  
  Afternoon (14:00-17:00):
    - 14:00: Borj Nord - fortress with panoramic city views and arms museum
    - 15:30: Last-minute shopping or relaxation
    - 16:30: Prepare for departure
"""
    
    return f"""Create a detailed {days}-day itinerary for {city}, Morocco.

MOROCCAN TRAVEL KNOWLEDGE:
- Best visiting hours: 9 AM - 6 PM for most sites
- Lunch break: 12:30 - 2:30 PM (most restaurants)
- Friday: Many sites close for prayer (1-3 PM)
- Summer: Very hot afternoons, plan indoor activities
- Ramadan: Reduced hours, respect fasting

{few_shot_example}

NOW CREATE ITINERARY FOR {city}:

Think step by step (Chain-of-Thought):
Step 1: List the top 10-15 must-see attractions in {city}
Step 2: Group attractions by geographical proximity (North, South, Medina, New City, etc.)
Step 3: Estimate realistic travel times between locations (walking: 15-30min, taxi: 10-20min)
Step 4: Balance cultural sites, food experiences, shopping, and rest periods
Step 5: Consider optimal visiting times (morning for outdoor sites, afternoon for museums)
Step 6: Assign attractions to days, ensuring logical flow and avoiding backtracking
Step 7: Include meal breaks with local restaurant recommendations
Step 8: Add practical tips (transport, timing, costs)

Provide the itinerary in this JSON format:
{{
  "Day 1": [
    {{
      "time": "9:00-12:00",
      "activity": "Detailed activity description with specific sites",
      "tips": "Practical advice (transport, costs, what to bring)"
    }},
    ...
  ],
  "Day 2": [...],
  ...
}}

Make it realistic, culturally rich, and practical for tourists.
"""

def get_cost_estimation_prompt(activity: str, city: str):
    """
    Chain-of-Thought + Few-Shot
    """
    
    few_shot_examples = """
EXAMPLE 1: Dinner at traditional restaurant in Marrakech
Reasoning:
- Appetizer (Moroccan salads): 30-50 MAD
- Main course (Tagine or Couscous): 80-120 MAD
- Dessert (Pastries or fruit): 25-40 MAD
- Drink (Mint tea or juice): 15-25 MAD
- Service (optional tip): 10-15 MAD
Total per person: 160-250 MAD
Location factor: Marrakech (tourist area) = +20%
Final estimate: 190-300 MAD per person

EXAMPLE 2: Guided tour of Fes Medina (half-day)
Reasoning:
- Official guide fee (4 hours): 200-300 MAD
- Entry fees (2-3 sites): 60-90 MAD
- Mint tea break: 20-30 MAD
- Tips for guide: 50-100 MAD
Total per person (solo): 330-520 MAD
Total per person (group of 4): 100-150 MAD (shared guide cost)
Final estimate: 100-520 MAD depending on group size

EXAMPLE 3: Taxi from airport to city center (Casablanca)
Reasoning:
- Distance: ~30 km
- Official taxi rate: ~250-300 MAD fixed price
- Petit taxi (if allowed): Not available for this distance
- Grand taxi (shared): 50-70 MAD per person
- Private taxi/Uber: 200-300 MAD
Final estimate: 50-300 MAD depending on taxi type
"""
    
    return f"""Estimate the cost for this activity in {city}, Morocco: "{activity}"

{few_shot_examples}

MOROCCAN PRICING KNOWLEDGE:
- Currency: Moroccan Dirham (MAD), 1 EUR ≈ 10-11 MAD
- Bargaining: Expected in souks (start at 50% of asking price)
- Tipping: 10-15% in restaurants, 20-50 MAD for guides
- City factor: Marrakech/Casablanca (+20%), Fes/Rabat (standard), smaller cities (-15%)

Think step by step (Chain-of-Thought):
Step 1: Break down the activity into cost components (transport, entry fees, food, guide, etc.)
Step 2: Estimate each component's cost range based on Moroccan pricing
Step 3: Apply location factor for {city}
Step 4: Consider variations (budget vs. mid-range vs. luxury)
Step 5: Provide total cost range with explanation

Respond in JSON format:
{{
  "activity": "{activity}",
  "city": "{city}",
  "cost_breakdown": [
    {{"item": "Component name", "min_cost": XX, "max_cost": XX, "currency": "MAD"}},
    ...
  ],
  "total_min": XX,
  "total_max": XX,
  "currency": "MAD",
  "notes": "Important considerations (group size, season, bargaining tips)",
  "reasoning": "Brief explanation of cost calculation"
}}
"""

def get_darija_translation_prompt(text: str, target_lang: str):
    """
    Few-Shot + Knowledge Generation
    """
    
    few_shot_examples = """
EXAMPLE 1:
English: "Hello, how are you?"
Darija (Latin): "Salam, labas?"
Darija (Arabic): سلام، لاباس؟
Pronunciation: "sa-LAM, la-BAS"
Context: Casual greeting, very common

EXAMPLE 2:
English: "Thank you very much"
Darija (Latin): "Shukran bezzaf" or "Baraka llahu fik"
Darija (Arabic): شكرا بزاف / بارك الله فيك
Pronunciation: "shuk-RAN bez-ZAF" / "BA-ra-ka la-hu FIK"
Context: "Baraka llahu fik" is more formal/religious

EXAMPLE 3:
English: "How much does this cost?"
Darija (Latin): "Bshal hada?" or "Shhal?"
Darija (Arabic): بشحال هادا؟ / شحال؟
Pronunciation: "besh-HAL HA-da" / "sh-HAL"
Context: Essential for shopping in souks

EXAMPLE 4:
English: "I don't understand"
Darija (Latin): "Ma fhemtsh"
Darija (Arabic): ما فهمتش
Pronunciation: "ma FHEMT-sh"
Context: Useful when communication is difficult

EXAMPLE 5:
English: "Where is the bathroom?"
Darija (Latin): "Fin kayn bit lma?" or "Fin toilette?"
Darija (Arabic): فين كاين بيت الما؟ / فين توليت؟
Pronunciation: "fin KAY-en bit el-MA" / "fin twa-LET"
Context: "Toilette" (French loanword) is commonly used
"""
    
    return f"""Translate between Darija (Moroccan Arabic) and {target_lang}.

DARIJA KNOWLEDGE BASE:
- Darija is Moroccan Arabic dialect, distinct from Modern Standard Arabic
- Written in Arabic script or Latin transliteration (both acceptable)
- Linguistic influences:
  * Classical Arabic: ~40% (base vocabulary)
  * Berber (Amazigh): ~30% (especially in rural areas)
  * French: ~20% (education, business, modern terms)
  * Spanish: ~10% (northern Morocco)
- Pronunciation differs significantly from Standard Arabic
- Common French loanwords kept as-is: "Merci", "Bonjour", "Toilette", "Taxi"
- Berber words: "Bezzaf" (a lot), "Zwin" (beautiful), "Wakha" (okay)

{few_shot_examples}

NOW TRANSLATE: "{text}"

Provide comprehensive translation:
{{
  "original_text": "{text}",
  "original_language": "{target_lang}",
  "darija_latin": "Transliteration in Latin script",
  "darija_arabic": "Translation in Arabic script",
  "pronunciation": "Phonetic guide with stress marks",
  "literal_meaning": "Word-by-word breakdown if helpful",
  "cultural_context": "When/how to use this phrase appropriately",
  "alternatives": ["Alternative ways to say the same thing"],
  "formality": "Casual/Formal/Religious"
}}

Be accurate and culturally appropriate.
"""
