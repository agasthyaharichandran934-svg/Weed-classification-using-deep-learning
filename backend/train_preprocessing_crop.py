import os
import cv2
import numpy as np

# Input dataset path (class-wise folders inside this)
dataset_path = r"C:\Users\New\PycharmProjects\weedout\Weedoutapp\static\dataset_crops\\"

# Output folder for preprocessed images
output_path = r"C:\Users\New\PycharmProjects\weedout\Weedoutapp\static\processed_dataset_crops\\"
os.makedirs(output_path, exist_ok=True)

# Image target size
img_size = (128, 128)

# Augmentation functions
def augment_image(img):
    aug_images = []

    # Flip (horizontal + vertical)
    aug_images.append(cv2.flip(img, 1))   # horizontal flip
    aug_images.append(cv2.flip(img, 0))   # vertical flip

    # Rotation (±15 degrees)
    h, w = img.shape
    center = (w // 2, h // 2)
    for angle in [-15, 15]:
        M = cv2.getRotationMatrix2D(center, angle, 1.0)
        rotated = cv2.warpAffine(img, M, (w, h))
        aug_images.append(rotated)

    # Brightness adjustment
    bright = cv2.convertScaleAbs(img, alpha=1.2, beta=30)  # brighter
    dark = cv2.convertScaleAbs(img, alpha=0.8, beta=-30)   # darker
    aug_images.extend([bright, dark])

    return aug_images


# Loop through all classes
for class_name in os.listdir(dataset_path):
    class_path = os.path.join(dataset_path, class_name)
    if not os.path.isdir(class_path):
        continue

    # Make output class folder
    save_class_path = os.path.join(output_path, class_name)
    os.makedirs(save_class_path, exist_ok=True)


    # Process each image
    for img_file in os.listdir(class_path):
        img_path = os.path.join(class_path, img_file)

        # Read image (grayscale)
        img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
        if img is None:
            continue
        # Resize
        img = cv2.resize(img, img_size)

        # ---------- Noise Removal ----------
        img = cv2.medianBlur(img, 3)  # remove salt-and-pepper noise
        # img = cv2.GaussianBlur(img, (3,3), 0)  # alternative option

        # ---------- Normalization ----------
        img_norm = img.astype('float32') / 255.0

        # Save original processed
        save_path = os.path.join(save_class_path, img_file)
        cv2.imwrite(save_path, (img_norm * 255).astype('uint8'))

        # ---------- Augmentation ----------
        augmented_imgs = augment_image(img)

        # Save augmented versions
        for i, aug in enumerate(augmented_imgs):
            aug_norm = aug.astype('float32') / 255.0
            aug_save_path = os.path.join(save_class_path, f"{os.path.splitext(img_file)[0]}_aug{i}.jpg")
            cv2.imwrite(aug_save_path, (aug_norm * 255).astype('uint8'))

print("✅ Preprocessing completed: Grayscale + Noise Removal + Augmentation + Normalization")




