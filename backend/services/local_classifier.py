import tensorflow as tf
from PIL import Image
import numpy as np
import json
import io
from pathlib import Path

class LocalClassifier:
    def __init__(self):
        base_path = Path(__file__).parent.parent / "models"
        
        # Charger les modèles
        print("Loading MobileNetV3 models...")
        self.food_model = tf.keras.models.load_model(
            str(base_path / "Moroccan_Food_best_model.h5")
        )
        self.monument_model = tf.keras.models.load_model(
            str(base_path / "Moroccan_Monument_best_model.h5")
        )
        print("✅ Models loaded successfully!")
        
        # Charger les classes
        with open(base_path / "food_classes.json", 'r', encoding='utf-8') as f:
            self.food_classes = json.load(f)
        with open(base_path / "monument_classes.json", 'r', encoding='utf-8') as f:
            self.monument_classes = json.load(f)
    
    def preprocess_image(self, image_bytes):
        """Prétraiter l'image pour MobileNetV3 (224x224, RGB, normalisé 0-1)"""
        img = Image.open(io.BytesIO(image_bytes))
        img = img.convert('RGB')
        img = img.resize((224, 224))
        img_array = np.array(img) / 255.0  # Normalisation 0-1
        img_array = np.expand_dims(img_array, axis=0)
        return img_array
    
    def predict(self, image_bytes, category):
        """Prédire la classe (food ou monument)"""
        img_array = self.preprocess_image(image_bytes)
        
        if category == "food":
            predictions = self.food_model.predict(img_array, verbose=0)
            classes = self.food_classes
        else:  # monument
            predictions = self.monument_model.predict(img_array, verbose=0)
            classes = self.monument_classes
        
        # Top 3 prédictions
        top_3_indices = np.argsort(predictions[0])[-3:][::-1]
        
        results = []
        for idx in top_3_indices:
            results.append({
                "name": classes[str(idx)],
                "confidence": float(predictions[0][idx])
            })
        
        return {
            "top_prediction": results[0],
            "all_predictions": results,
            "source": "local_model"
        }

# Instance globale (chargée au démarrage)
try:
    local_classifier = LocalClassifier()
except ImportError as e:
    print(f"⚠️ Warning: Could not import dependencies for local models: {e}")
    print("   Make sure TensorFlow is installed: pip install tensorflow")
    local_classifier = None
except FileNotFoundError as e:
    print(f"⚠️ Warning: Model files not found: {e}")
    print("   Make sure model files exist in backend/models/")
    local_classifier = None
except Exception as e:
    print(f"⚠️ Warning: Could not load local models: {e}")
    import traceback
    traceback.print_exc()
    local_classifier = None
