#!/usr/bin/env python
"""
Test photo display functionality
"""
from Weedoutapp.predict import predict_disease_from_image
import json

test_image = r'C:\Users\New\PycharmProjects\Newbackup\weedout\Weedoutapp\static\cornleaf.jpg'

print("Testing photo display in prediction results...\n")

result = predict_disease_from_image(test_image)

if result:
    print("✓ Prediction successful")
    print(f"  Crop: {result.get('name')}")
    print(f"  Confidence: {result.get('confidence'):.2f}%")
    print(f"  Photo URL: {result.get('photo')}")
    
    if result.get('photo'):
        print("\n✓ Photo URL is present and will display in Flutter app")
        print(f"  Full response fields: {list(result.keys())}")
    else:
        print("\n✗ Photo URL is missing")
else:
    print("✗ Prediction failed")

