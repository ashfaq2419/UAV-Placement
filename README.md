# Efficient UAV placement to serve maximum users through minimum UAVs

[Paper](https://arxiv.org/abs/2009.13158), [Spotlight Presentation](https://youtu.be/T3m57pNdrqE)

## Introduction
This repository contains the implementation of trainable structure tensors (TST), a single-staged contour instance segmentation strategy to detect the extremely cluttered baggage threats regardless of the scanner specifications. 

![TST](/images/Picture1.jpg)

1. Python 3.7.4 
2. TensorFlow 2.2.0 (CUDA compatible GPU needed for GPU training) 
3. Keras 2.3.1 or above 
4. OpenCV 4.2 
5. Imgaug 0.2.9 or above 
6. Tqdm 

Both Linux and Windows OS are supported.

## Datasets
The X-ray datasets can be downloaded from the following URLs: 
1. [GDXray](https://domingomery.ing.puc.cl/material/gdxray/) 

## Dataset Preparation

1. Download the desired dataset and update the dataset paths in ‘…\mst.m’ file.

```
├── trainingDataset
│   ├── train_images
│   │   └── tr_image_1.png
│   │   └── tr_image_2.png
│   │   ...
│   │   └── tr_image_n.png
│   ├── train_annotations
│   │   └── tr_image_1.png
│   │   └── tr_image_2.png
│   │   ...
│   │   └── tr_image_n.png
│   ├── val_images
│   │   └── va_image_1.png
│   │   └── va_image_2.png
│   │   ...
│   │   └── va_image_m.png
│   ├── val_annotations
│   │   └── va_image_1.png
│   │   └── va_image_2.png
│   │   ...
│   │   └── va_image_m.png
├── testingDataset
│   ├── original
│   │   └── o_image_1.png
│   │   └── o_image_2.png
│   │   ...
│   │   └── o_image_k.png
│   ├── test_images
│   │   └── te_image_1.png
│   │   └── te_image_2.png
│   │   ...
│   │   └── te_image_k.png
│   ├── test_annotations
│   │   └── te_image_1.png
│   │   └── te_image_2.png
│   │   ...
│   │   └── te_image_k.png
│   ├── segmentation_results
│   │   └── te_image_1.png
│   │   └── te_image_2.png
│   │   ...
│   │   └── te_image_k.png
```

## Training and Testing
1. Use '…\trainer.py' file to train the backbone network provided in the '…\codebase\models' folder. The training parameters can be configured in this file as well. Once the training is completed, the segmentation results are saved in the '…\testingDataset\segmentation_results' folder. These results are used by the 'instanceDetector.m' script in the next step for bounding box and mask generation. 
2. Once the step 1 is completed, please run '…\instanceDetector.m' to generate the final detection outputs. Please note that the '…\instanceDetector.m' requires that the original images are placed in the '…\testingDataset\original' folder (as discussed in step 12 of the previous section).

## Results
The additional results of the TST framework are presented in the '…\results' folder. Please feel free to email us if you require the trained instances. 

## Citation
If you use TST (or any part of this code in your research), please cite the following paper:

```
@inproceedings{tst,
  title   = {Trainable Structure Tensors for Autonomous Baggage Threat Detection Under Extreme Occlusion},
  author  = {Taimur Hassan and Samet Akcay and Mohammed Bennamoun and Salman Khan and Naoufel Werghi},
  note = {Asian Conference on Computer Vision (ACCV)},
  year = {2020}
}
```

## Contact
If you have any query, please feel free to contact us at: taimur.hassan@ku.ac.ae.
