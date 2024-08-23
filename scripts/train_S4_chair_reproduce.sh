#!/bin/bash

EXPERIMENT_DIR=_experiments
EXPERIMENT_NAME=DiT_S4_chair_reproduce_cs
DATASET_DIR=/mnt/fast/nobackup/users/vt00262/datasets/ShapeNetCore/ShapeNetCore.v2.PC15k/
CONDA_ENV="ssmdiff"

# --------------------
# Training
# --------------------
source /user/HS502/vt00262/miniconda3/bin/activate $CONDA_ENV || exit
cd /mnt/fast/nobackup/users/vt00262/DiffusionSSM-3D

CGO_ENABLED=0 python train.py --distribution_type 'multi' \
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
    --use_wandb \
    --niter 10000 \
    --saveIter 2000 \
    --diagIter 1000 \
    --vizIter 1000 \
    --print_freq 50 \
    --val_bs 50

# --------------------
# Evaluation
# --------------------
# python eval.py \
#     --dataroot $DATASET_DIR \
#     --category chair \
#     --model_dir $EXPERIMENT_DIR \
#     --experiment_name $EXPERIMENT_NAME \
#     --model_type 'DiT-S/4' \
#     --voxel_size 32 \
#     --model _experiments/DiT_S4_chair_reproduce/training/checkpoints/epoch_1.pth \
#     --generate \
#     --eval_gen \
