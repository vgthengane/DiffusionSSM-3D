#!/bin/bash

# Check if the experiment name is provided as a command-line argument
if [ $# -eq 0 ]; then
    echo "Error: Please provide the experiment name."
    exit 1
fi

# --------------------
# Arguments
# --------------------
# Assign the first command-line argument to EXPERIMENT_NAME
EXPERIMENT_NAME="$1"
PROJECT_HOME_DIR=/mnt/fast/nobackup/users/vt00262/DiffusionSSM-3D
EXPERIMENT_DIR=_experiments
DATASET_DIR=/mnt/fast/nobackup/users/vt00262/datasets/ShapeNetCore/ShapeNetCore.v2.PC15k/
CONDA_ENV="ssmdiff"

cd "$PROJECT_HOME_DIR" || exit

mkdir -p $EXPERIMENT_DIR/$EXPERIMENT_NAME
if [ ! -f "$EXPERIMENT_DIR/$EXPERIMENT_NAME/$(basename $0)" ]; then
    cp "$0" "$EXPERIMENT_DIR/$EXPERIMENT_NAME"
fi
# activate conda environment
source /user/HS502/vt00262/miniconda3/bin/activate $CONDA_ENV || exit

# --------------------
# Training
# --------------------
# The arguments are changed for 2 GPUs
python train.py \
    --distribution_type 'multi' \
    --dataroot $DATASET_DIR \
    --category chair \
    --model_dir $EXPERIMENT_DIR \
    --experiment_name $EXPERIMENT_NAME \
    --model_type 'DiT-S/4' \
    --voxel_size 32 \
    --window_size 4 --window_block_indexes '0,3,6,9' \
    --bs 32 \
    --lr 1e-4 \
    --num_classes 1 \
    --use_wandb \
    --niter 10000 \
    --saveIter 1000 \
    --diagIter 1000 \
    --vizIter 1000 \
    --print_freq 50 \
    --val_bs 50 |& tee $EXPERIMENT_DIR/$EXPERIMENT_NAME/training.log

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
