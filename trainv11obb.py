from ultralytics import YOLO
import torch
import os

def train_model():
    model = YOLO('yolo11s-obb.pt')

    model.train(
        data='/home/oisinbraniff/testYolo/BlueROV-Gripper-Target.v2i.yolov8-obb/training/data.yaml',
        task='obb',
        epochs=100,
        imgsz=640,        
        batch=16,
        device=0,
        project='BlueROV2_detect',
        name='drink_can_obb_detection',
        plots=True
    )
    print("\n Model Performance")

    metrics = model.val(split='test', plots=True)
    print(f"map@50: {metrics.obb.map50}")
    print(f"Precision: {metrics.obb.mp}")
    print(f"recall: {metrics.obb.mr}")

if __name__ == '__main__':
    # Clear GPU cache
    torch.cuda.empty_cache()
    train_model()