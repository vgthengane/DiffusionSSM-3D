import os
os.environ['PYTORCH_CUDA_ALLOC_CONF'] = 'max_split_size_mb:512'


import torch
from mamba.mamba_ssm import Mamba, Mamba2
from mamba.mamba_ssm.modules.mamba2_simple import Mamba2Simple


from models_dis import DiS_models
from models_dis2 import DiS_models as DiS_models2
from DiT.models import DiT_models

# batch, length, dim = 2, 64, 256
# x = torch.randn(batch, length, dim).to("cuda")
batch_size, img_size = 32, 32

x = torch.randn((batch_size, 3, img_size, img_size)).to("cuda")
t = torch.randn((batch_size)).to("cuda")
kwargs = {'labels': None}


model = DiS_models["DiS-S/2"](
    img_size=img_size,
    num_classes=-1,
    channels=3,
    bimamba_type="none"
).to("cuda")

model2 = DiS_models2["DiS-S/2"](
    img_size=img_size,
    num_classes=-1,
    channels=3,
).to("cuda")

model_dit = DiT_models["DiT-S/2"](
    input_size=img_size,
    num_classes=-1,
    in_channels=3
).to("cuda")

# Initialize the Mamba model
# model = Mamba(
#     # This module uses roughly 3 * expand * d_model^2 parameters
#     d_model=dim, # Model dimension d_model
#     d_state=64,  # SSM state expansion factor
#     d_conv=4,    # Local convolution width
#     expand=2,    # Block expansion factor
# ).to("cuda")



# # Initialize the Mamba2 model
# model2 = Mamba2Simple(
#     # This module uses roughly 3 * expand * d_model^2 parameters
#     d_model=dim, # Model dimension d_model
#     d_state=64,  # SSM state expansion factor, typically 64 or 128
#     d_conv=4,    # Local convolution width
#     expand=2,    # Block expansion factor
#     headdim=32,  # Additional parameter for Mamba2
#     ngroups=1,   # Number of groups for group normalization
#     # sequence_parallel=False, # Whether to use sequence parallelism
# ).to("cuda")

# Function to count model parameters
def count_parameters(model):
    return sum(p.numel() for p in model.parameters())

# Print the number of parameters for each model
print(f"Mamba model parameters: {count_parameters(model)}")
print(f"Mamba2 model parameters: {count_parameters(model2)}")
print(f"DiT model parameters: {count_parameters(model_dit)}")

for i in range(5):
    # Measure inference time for Mamba model
    start_event = torch.cuda.Event(enable_timing=True)
    end_event = torch.cuda.Event(enable_timing=True)

    start_event.record()
    y = model(x, t, **kwargs)
    end_event.record()

    # Wait for all CUDA operations to finish
    torch.cuda.synchronize()

    mamba_time = start_event.elapsed_time(end_event) # Time in milliseconds

    print(f"\nMamba model time: {mamba_time} ms")
    print(y.shape)

print("===============")

for i in range(5):
    # assert y.shape == x.shape

    # Measure inference time for Mamba2 model
    start_event = torch.cuda.Event(enable_timing=True)
    end_event = torch.cuda.Event(enable_timing=True)

    # print("Before forward pass:")
    # print(torch.cuda.memory_summary())
    # y = model2(x, t, **kwargs)
    # print("After forward pass:")
    # print(torch.cuda.memory_summary())

    start_event.record()
    y = model2(x, t, **kwargs)
    end_event.record()

    # Wait for all CUDA operations to finish
    torch.cuda.synchronize()

    mamba2_time = start_event.elapsed_time(end_event) # Time in milliseconds

    print(f"\nMamba2 model time: {mamba2_time} ms")
    print(y.shape)


print("===============")

for i in range(5):
    # Measure inference time for Mamba model
    start_event = torch.cuda.Event(enable_timing=True)
    end_event = torch.cuda.Event(enable_timing=True)

    start_event.record()
    y = model_dit(x, t, **{"y": None})
    end_event.record()

    # Wait for all CUDA operations to finish
    torch.cuda.synchronize()

    mamba_time = start_event.elapsed_time(end_event) # Time in milliseconds

    print(f"\nDiT model time: {mamba_time} ms")
    print(y.shape)




# assert y.shape == x.shape