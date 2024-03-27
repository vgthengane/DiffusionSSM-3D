#!/bin/bash


EXPERIMENT_DIR=_experiments
EXPERIMENT_NAME=DiT_S4_chair_reproduce
DATASET_DIR=_data/ShapeNetCore.v2.PC15k/

# --------------------
# Training
# --------------------
python train.py --distribution_type 'multi' \
    --dataroot $DATASET_DIR \
    --category chair \
    --model_dir $EXPERIMENT_DIR \
    --experiment_name $EXPERIMENT_NAME \
    --model_type 'DiT-S/4' \
    --voxel_size 32 \
    --window_size 4 --window_block_indexes '0,3,6,9' \
    --bs 16 \
    --lr 1e-4 \
    --num_classes 1 \
    --use_tb \

# --------------------
# Evaluation
# --------------------
python test.py \
    --dataroot $DATASET_DIR \
    --category chair \
    --model_dir $EXPERIMENT_DIR \
    --experiment_name $EXPERIMENT_NAME \
    --model_type 'DiT-S/4' \
    --voxel_size 32 \
    --model $EXPERIMENT_DIR/$EXPERIMENT_NAME/train/last.pth \
    --generate \
    --eval_gen \
