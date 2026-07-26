"""
Test script for Weed and Crop Classification System
This script tests the classification functionality and generates sample reports.
"""

import os
import sys
import json
import django
from datetime import datetime

# Configure Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'weedout.settings')
django.setup()

from Weedoutapp.classificationreport import (
    WeedCropClassifier, 
    ClassificationReport,
    classify_image,
    classify_batch,
    generate_report
)


def test_classifier_initialization():
    """Test if classifier can be initialized"""
    print("\n" + "="*60)
    print("TEST 1: Classifier Initialization")
    print("="*60)
    
    try:
        classifier = WeedCropClassifier()
        print(f"✓ Classifier initialized successfully")
        print(f"  - Weed model path: {classifier.model_weed_path}")
        print(f"  - Crop model path: {classifier.model_crop_path}")
        print(f"  - Weed model loaded: {classifier.weed_model is not None}")
        print(f"  - Crop model loaded: {classifier.crop_model is not None}")
        print(f"  - Classifier ready: {classifier.is_loaded}")
        return True
    except Exception as e:
        print(f"✗ Error initializing classifier: {str(e)}")
        return False


def test_model_existence():
    """Test if model files exist"""
    print("\n" + "="*60)
    print("TEST 2: Model File Existence")
    print("="*60)
    
    classifier = WeedCropClassifier()
    
    weed_exists = os.path.exists(classifier.model_weed_path)
    crop_exists = os.path.exists(classifier.model_crop_path)
    
    print(f"Weed model file exists: {'✓' if weed_exists else '✗'} ({classifier.model_weed_path})")
    print(f"Crop model file exists: {'✓' if crop_exists else '✗'} ({classifier.model_crop_path})")
    
    if weed_exists:
        weed_size = os.path.getsize(classifier.model_weed_path) / (1024*1024)
        print(f"  Weed model size: {weed_size:.2f} MB")
    
    if crop_exists:
        crop_size = os.path.getsize(classifier.model_crop_path) / (1024*1024)
        print(f"  Crop model size: {crop_size:.2f} MB")
    
    return weed_exists or crop_exists


def test_image_preprocessing():
    """Test image preprocessing functionality"""
    print("\n" + "="*60)
    print("TEST 3: Image Preprocessing")
    print("="*60)
    from PIL import Image
    import numpy as np
    
    # Create a dummy image
    dummy_image = Image.new('RGB', (500, 500), color='green')
    test_image_path = '/tmp/test_image.jpg'
    dummy_image.save(test_image_path)
    
    try:
        classifier = WeedCropClassifier()
        preprocessed = classifier.preprocess_image(test_image_path)
        
        if preprocessed is not None:
            print(f"✓ Image preprocessing successful")
            print(f"  - Input size: 500x500")
            print(f"  - Output shape: {preprocessed.shape}")
            print(f"  - Expected shape: (1, 299, 299, 3)")
            print(f"  - Value range: [{preprocessed.min():.3f}, {preprocessed.max():.3f}]")
            return True
        else:
            print(f"✗ Image preprocessing returned None")
            return False
    except Exception as e:
        print(f"✗ Error preprocessing image: {str(e)}")
        return False
    finally:
        if os.path.exists(test_image_path):
            os.remove(test_image_path)


def test_classification_report_generation():
    """Test classification report generation"""
    print("\n" + "="*60)
    print("TEST 4: Classification Report Generation")
    print("="*60)
    
    from PIL import Image
    
    # Create a dummy image
    dummy_image = Image.new('RGB', (300, 300), color='green')
    test_image_path = '/tmp/test_report_image.jpg'
    dummy_image.save(test_image_path)
    
    try:
        report_generator = ClassificationReport()
        report = report_generator.generate_report_from_image(test_image_path)
        
        print(f"✓ Report generated successfully")
        print(f"  - Report ID: {report['report_id']}")
        print(f"  - Timestamp: {report['timestamp']}")
        
        classification = report['classification_result']
        print(f"  - Classification successful: {classification.get('success')}")
        print(f"  - Primary classification: {classification.get('primary_classification')}")
        print(f"  - Confidence score: {classification.get('confidence_score'):.4f}")
        
        recommendations = report['recommendations']
        print(f"  - Recommended action: {recommendations.get('action')}")
        print(f"  - Priority: {recommendations.get('priority')}")
        print(f"  - Confidence level: {recommendations.get('confidence_level')}")
        
        return True
    except Exception as e:
        print(f"✗ Error generating report: {str(e)}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        if os.path.exists(test_image_path):
            os.remove(test_image_path)


def test_batch_classification():
    """Test batch classification of multiple images"""
    print("\n" + "="*60)
    print("TEST 5: Batch Classification")
    print("="*60)
    
    from PIL import Image
    import random
    
    # Create multiple dummy images
    test_images = []
    for i in range(3):
        color = random.choice(['green', 'red', 'yellow'])
        dummy_image = Image.new('RGB', (300, 300), color=color)
        test_path = f'/tmp/test_batch_{i}.jpg'
        dummy_image.save(test_path)
        test_images.append(test_path)
    
    try:
        classifier = WeedCropClassifier()
        results = classifier.batch_classify(test_images)
        
        print(f"✓ Batch classification completed")
        print(f"  - Total images: {len(results)}")
        
        for i, result in enumerate(results):
            status = "✓" if result.get('success') else "✗"
            classification = result.get('primary_classification', 'UNKNOWN')
            confidence = result.get('confidence_score', 0)
            print(f"  {status} Image {i+1}: {classification} (confidence: {confidence:.4f})")
        
        return len(results) == len(test_images)
    except Exception as e:
        print(f"✗ Error in batch classification: {str(e)}")
        return False
    finally:
        for path in test_images:
            if os.path.exists(path):
                os.remove(path)


def generate_system_report():
    """Generate a comprehensive system report"""
    print("\n" + "="*60)
    print("SYSTEM CONFIGURATION REPORT")
    print("="*60)
    print(f"Generated: {datetime.now().isoformat()}")
    print(f"Python version: {sys.version}")
    print(f"Django: {django.get_version()}")
    
    try:
        import tensorflow as tf
        print(f"TensorFlow version: {tf.__version__}")
    except:
        print("TensorFlow: Not installed")
    try:
        import keras
        print(f"Keras version: {keras.__version__}")
    except:
        print("Keras: Not installed")
    
    classifier = WeedCropClassifier()
    
    print("\nModel Configuration:")
    print(f"  - Base model: Inception v3")
    print(f"  - Approach: Transfer Learning")
    print(f"  - Input size: 299x299 pixels")
    print(f"  - Preprocessing: Normalization to [0, 1]")
    
    print("\nModel Paths:")
    print(f"  - Weed model: {classifier.model_weed_path}")
    print(f"  - Crop model: {classifier.model_crop_path}")
    
    print("\nModel Status:")
    print(f"  - Weed model loaded: {classifier.weed_model is not None}")
    print(f"  - Crop model loaded: {classifier.crop_model is not None}")
    print(f"  - Classifier ready: {classifier.is_loaded}")


def main():
    """Run all tests"""
    print("\n" + "="*60)
    print("WEED & CROP CLASSIFICATION SYSTEM - TEST SUITE")
    print("="*60)
    
    tests = [
        ("Classifier Initialization", test_classifier_initialization),
        ("Model File Existence", test_model_existence),
        ("Image Preprocessing", test_image_preprocessing),
        ("Classification Report", test_classification_report_generation),
        ("Batch Classification", test_batch_classification),
    ]
    
    results = {}
    for test_name, test_func in tests:
        try:
            results[test_name] = test_func()
        except Exception as e:
            print(f"\n✗ Critical error in {test_name}: {str(e)}")
            import traceback
            traceback.print_exc()
            results[test_name] = False
    
    # Generate system report
    generate_system_report()
    
    # Summary
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{status}: {test_name}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n✓ All tests passed! Classification system is ready.")
    else:
        print(f"\n✗ {total - passed} test(s) failed. Please review the errors above.")


if __name__ == '__main__':
    main()





