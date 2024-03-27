#!/usr/bin/bash

# Check if the experiment name is provided as a command-line argument
if [ $# -eq 0 ]; then
    echo "Error: Please provide the experiment name."
    exit 1
fi

# Assign the first command-line argument to EXPERIMENT_NAME
EXPERIMENT_NAME="$1"

PROJECT_HOME_DIR=/vol/research/Vishal_Thengane/projects/DiffusionSSM-3D
EXPERIMENT_DIR=_experiments
DATASET_DIR=_data/ShapeNetCore.v2.PC15k/
CONDA_ENV=_diffssm3d

cd "$PROJECT_HOME_DIR" || exit

# Source the directory functions script
source scripts/create_output_exp_dir.sh
# Get the output directory
EXPERIMENT_NAME=$(get_output_dir "$EXPERIMENT_DIR" "$EXPERIMENT_NAME")

# activate conda environment
source "/vol/research/Vishal_Thengane/miniconda3/bin/activate" "$CONDA_ENV" || exit

mkdir $EXPERIMENT_DIR/$EXPERIMENT_NAME

cp "$0" $EXPERIMENT_DIR/$EXPERIMENT_NAME

# --------------------
# Training
# --------------------
python train.py \
    --distribution_type 'multi' \
    --dataroot $DATASET_DIR \
    --category chair \
    --model_dir $EXPERIMENT_DIR \
    --experiment_name $EXPERIMENT_NAME \
    --model_type 'DiT-S/4' \
    --voxel_size 32 \
    --window_size 4 --window_block_indexes '0,3,6,9' \
    --bs 64 \
    --lr 1e-4 \
    --num_classes 1 \
    --use_wandb \
    --niter 10000 \
    --saveIter 2000 \
    --diagIter 2000 \
    --vizIter 2000 \
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
