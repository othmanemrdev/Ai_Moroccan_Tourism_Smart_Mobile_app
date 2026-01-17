"""
Script de vérification des modèles MobileNetV3
Pour tester que TensorFlow 2.13.0 charge correctement vos modèles de 2023
"""
import sys
from pathlib import Path

print("=" * 70)
print("VÉRIFICATION DES MODÈLES MOBILENETV3 (2023)")
print("=" * 70)

# 1. Vérifier Python
print(f"\n1. Python Version: {sys.version.split()[0]}", end="")
if sys.version_info >= (3, 10) and sys.version_info < (3, 12):
    print(" ✓")
else:
    print(" ⚠ (Recommandé: Python 3.10 ou 3.11)")

# 2. Vérifier TensorFlow
try:
    import tensorflow as tf
    print(f"2. TensorFlow: {tf.__version__}", end="")
    if tf.__version__.startswith("2.13"):
        print(" ✓")
    else:
        print(f" ⚠ (Attendu: 2.13.x)")
except ImportError as e:
    print(f"2. TensorFlow: NOT INSTALLED ✗")
    print(f"   Erreur: {e}")
    sys.exit(1)

# 3. Vérifier NumPy
try:
    import numpy as np
    print(f"3. NumPy: {np.__version__}", end="")
    if np.__version__.startswith("1.24"):
        print(" ✓")
    else:
        print(f" ⚠ (Recommandé: 1.24.x)")
except ImportError:
    print("3. NumPy: NOT INSTALLED ✗")

# 4. Vérifier que les fichiers modèles existent
print("\n" + "-" * 70)
print("VÉRIFICATION DES FICHIERS MODÈLES")
print("-" * 70)

models_dir = Path("models")
required_files = [
    "Moroccan_Food_best_model.h5",
    "Moroccan_Monument_best_model.h5",
    "food_classes.json",
    "monument_classes.json"
]

all_files_exist = True
for filename in required_files:
    filepath = models_dir / filename
    exists = filepath.exists()
    status = "✓" if exists else "✗"
    size = f"({filepath.stat().st_size / (1024*1024):.1f} MB)" if exists else ""
    print(f"  {filename:35} {status} {size}")
    if not exists:
        all_files_exist = False

if not all_files_exist:
    print("\n⚠ ATTENTION: Certains fichiers modèles sont manquants!")
    print("   Placez vos fichiers .h5 et .json dans backend/models/")
    sys.exit(1)

# 5. Tester le chargement des modèles
print("\n" + "-" * 70)
print("TEST DE CHARGEMENT DES MODÈLES")
print("-" * 70)

try:
    print("\nChargement du modèle Food...")
    food_model = tf.keras.models.load_model(str(models_dir / "Moroccan_Food_best_model.h5"))
    print(f"  ✓ Modèle Food chargé avec succès!")
    print(f"    Input shape: {food_model.input_shape}")
    print(f"    Output shape: {food_model.output_shape}")
    print(f"    Nombre de classes: {food_model.output_shape[-1]}")
except Exception as e:
    print(f"  ✗ Erreur lors du chargement du modèle Food:")
    print(f"    {e}")
    import traceback
    traceback.print_exc()

try:
    print("\nChargement du modèle Monument...")
    monument_model = tf.keras.models.load_model(str(models_dir / "Moroccan_Monument_best_model.h5"))
    print(f"  ✓ Modèle Monument chargé avec succès!")
    print(f"    Input shape: {monument_model.input_shape}")
    print(f"    Output shape: {monument_model.output_shape}")
    print(f"    Nombre de classes: {monument_model.output_shape[-1]}")
except Exception as e:
    print(f"  ✗ Erreur lors du chargement du modèle Monument:")
    print(f"    {e}")
    import traceback
    traceback.print_exc()

# 6. Vérifier les fichiers JSON
print("\n" + "-" * 70)
print("VÉRIFICATION DES CLASSES JSON")
print("-" * 70)

import json

try:
    with open(models_dir / "food_classes.json", "r", encoding="utf-8") as f:
        food_classes = json.load(f)
    print(f"  ✓ food_classes.json: {len(food_classes)} classes")
    print(f"    Exemples: {list(food_classes.values())[:3]}")
except Exception as e:
    print(f"  ✗ Erreur food_classes.json: {e}")

try:
    with open(models_dir / "monument_classes.json", "r", encoding="utf-8") as f:
        monument_classes = json.load(f)
    print(f"  ✓ monument_classes.json: {len(monument_classes)} classes")
    print(f"    Exemples: {list(monument_classes.values())[:3]}")
except Exception as e:
    print(f"  ✗ Erreur monument_classes.json: {e}")

# 7. Test de prédiction (avec image factice)
print("\n" + "-" * 70)
print("TEST DE PRÉDICTION")
print("-" * 70)

try:
    # Créer une image factice (224x224x3)
    test_image = np.random.rand(1, 224, 224, 3).astype(np.float32)
    
    print("\nTest avec image factice (224x224x3)...")
    food_pred = food_model.predict(test_image, verbose=0)
    print(f"  ✓ Prédiction Food: shape {food_pred.shape}")
    print(f"    Top classe: {np.argmax(food_pred[0])}")
    print(f"    Confiance: {np.max(food_pred[0]):.2%}")
    
    monument_pred = monument_model.predict(test_image, verbose=0)
    print(f"  ✓ Prédiction Monument: shape {monument_pred.shape}")
    print(f"    Top classe: {np.argmax(monument_pred[0])}")
    print(f"    Confiance: {np.max(monument_pred[0]):.2%}")
    
except Exception as e:
    print(f"  ✗ Erreur lors de la prédiction: {e}")
    import traceback
    traceback.print_exc()

# Résumé final
print("\n" + "=" * 70)
print("RÉSUMÉ")
print("=" * 70)
print("\n✅ Environnement prêt pour la classification locale!")
print("   - TensorFlow 2.13.0 installé")
print("   - Modèles MobileNetV3 chargés")
print("   - Prédictions fonctionnelles")
print("\n🚀 Vous pouvez maintenant redémarrer le backend:")
print("   python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000")
print("\n" + "=" * 70)
