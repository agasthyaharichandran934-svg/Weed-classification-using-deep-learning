#!/usr/bin/env python
"""Test script to verify model loads successfully"""

import os
import sys
import django

# Setup Django
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'weedout.settings')
django.setup()

# Import predict module
from Weedoutapp.predict import get_model, predict_weed_from_image
import cv2
import numpy as np

print("=" * 60)
print("Testing Model Load")
print("=" * 60)

# Test 1: Load model
print("\n[TEST 1] Loading model...")
model = get_model()
if model is None:
    print("❌ Model load failed")
    sys.exit(1)
else:
    print("✅ Model loaded successfully")
    print(f"   Model type: {type(model)}")

# Test 2: Create a dummy image and test prediction
print("\n[TEST 2] Testing dummy prediction...")
try:
    # Create a dummy 224x224 RGB image
    dummy_image = np.random.randint(0, 255, (224, 224, 3), dtype=np.uint8)
    
    # Save temporarily
    temp_path = "temp_test_image.jpg"
    cv2.imwrite(temp_path, dummy_image)
    
    # Test prediction
    result = predict_weed_from_image(temp_path)
    print(f"✅ Prediction test successful")
    print(f"   Result: {result}")
    
    # Cleanup
    if os.path.exists(temp_path):
        os.remove(temp_path)
        
except Exception as e:
    print(f"❌ Prediction test failed: {str(e)}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

print("\n" + "=" * 60)
print("✅ All tests passed!")
print("=" * 60)
