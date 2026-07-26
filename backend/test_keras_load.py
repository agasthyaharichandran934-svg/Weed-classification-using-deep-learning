#!/usr/bin/env python
"""Test script to load model with keras 2.15.0"""

import os
import sys

# Try with keras 2.15.0
print("Testing with Keras 2.15.0...")
print(f"Keras version: {__import__('keras').__version__}")

try:
    from keras.models import load_model
    model_path = r"C:\Users\New\PycharmProjects\weedout\Weedoutapp\static\model1.h5"
    
    print(f"Loading model from {model_path}...")
    model = load_model(model_path, compile=False)
    print(f"✅ Model loaded successfully!")
    print(f"Model summary:")
    print(model.summary())
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()




