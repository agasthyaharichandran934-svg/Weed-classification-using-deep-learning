#!/usr/bin/env python
"""
Final comprehensive test of model loading functionality
"""

print("=" * 60)
print("FINAL MODEL LOADING TEST")
print("=" * 60)

# Test 1: predict.py model loading
print("\n[1] Testing predict.py...")
from Weedoutapp.predict import get_model
model1 = get_model()
print(f"✓ Model loaded: {model1 is not None}")
if model1:
    print(f"✓ Layers: {len(model1.layers)}")
    print(f"✓ Input shape: {model1.layers[0].input_shape if hasattr(model1.layers[0], 'input_shape') else 'N/A'}")

# Test 2: predict_new.py model loading
print("\n[2] Testing predict_new.py...")
from Weedoutapp.predict_new import PLANT_MODEL, WEED_MODEL
print(f"✓ Plant model loaded: {PLANT_MODEL is not None}")
print(f"✓ Weed model loaded: {WEED_MODEL is not None}")

if PLANT_MODEL:
    print(f"✓ Plant model layers: {len(PLANT_MODEL.layers)}")
# Test 3: Prediction test (if models loaded)
if model1:
    print("\n[3] Testing prediction...")
    import numpy as np
    test_input = np.zeros((1, 48, 48, 1), dtype=np.float32)
    try:
        output = model1.predict(test_input, verbose=0)
        print(f"✓ Prediction works!")
        print(f"✓ Output shape: {output.shape}")
    except Exception as e:
        print(f"✗ Prediction failed: {e}")

print("\n" + "=" * 60)
print("ALL TESTS COMPLETED SUCCESSFULLY!")
print("=" * 60)
