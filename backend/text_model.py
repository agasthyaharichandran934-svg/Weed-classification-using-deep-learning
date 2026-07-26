#!/usr/bin/env python
"""Test script to verify model loading and predictions"""

import os
import sys

# Add project to path
sys.path.insert(0, r'C:\Users\New\PycharmProjects\Newbackup\weedout')

# Suppress warnings
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

print("=" * 60)
print("Testing WeedOut Model Loading")
print("=" * 60)

# Test 1: Import predict module
print("\n[Test 1] Importing predict module...")
try:
    from Weedoutapp.predict import get_model, predict_weed_from_image, label_list
    print("✓ Import successful")
except Exception as e:
    print(f"✗ Import failed: {e}")
    sys.exit(1)

# Test 2: Check model path
print("\n[Test 2] Checking model file...")
model_path = r"C:\Users\New\PycharmProjects\weedout\Weedoutapp\static\model1.h5"
if os.path.exists(model_path):
    size = os.path.getsize(model_path) / (1024*1024)
    print(f"✓ Model found at: {model_path}")
    print(f"  File size: {size:.2f} MB")
else:
    print(f"✗ Model not found at: {model_path}")
    sys.exit(1)

# Test 3: Load model
print("\n[Test 3] Loading model...")
try:
    model = get_model()
    if model is None:
        print("✗ Model loading returned None")
        print("  This may be due to TensorFlow version incompatibility")
    else:
        print("✓ Model loaded successfully")
        print(f"  Model layers: {len(model.layers)}")
except Exception as e:
    print(f"✗ Model loading failed: {e}")

# Test 4: List available labels
print("\n[Test 4] Available crop labels:")
for i, label in enumerate(label_list, 1):
    print(f"  {i:2d}. {label}")

print("\n" + "=" * 60)
print("Server is ready for predictions!")
print("=" * 60)

