#!/bin/bash
python -m pip install huggingface_hub
huggingface-cli login
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

PYCMD=$(cat <<EOF

import os
from huggingface_hub import hf_hub_download
from array import *

link_array = []

link_array.insert(0, ["stabilityai/stable-diffusion-2-1", "v2-1_768-nonema-pruned.ckpt"])
link_array.insert(1, ["runwayml/stable-diffusion-v1-5", "v1-5-pruned-emaonly.ckpt"])
link_array.insert(2, ["runwayml/stable-diffusion-v1-5", "v1-5-pruned.ckpt"])
link_array.insert(3, ["stabilityai/stable-diffusion-2-base", "512-base-ema.ckpt"])
link_array.insert(4, ["runwayml/stable-diffusion-inpainting", "sd-v1-5-inpainting.ckpt"])
link_array.insert(5, ["stabilityai/stable-diffusion-x4-upscaler", "x4-upscaler-ema.ckpt"])
link_array.insert(6, ["Fictiverse/Stable_Diffusion_PaperCut_Model", "PaperCut_v1.ckpt"])
link_array.insert(7, ["Fictiverse/Stable_Diffusion_Microscopic_model", "Microscopic_v1.ckpt"])


DIR = "models"
CONFIG = "config"


if os.path.exists(DIR) == False:
    os.mkdir(DIR)
    print("Ordner " + DIR + " wurde erstellt.")
    print("Modelle werden im Ordner " + DIR + " gespeichert.")
else:
    print("Modelle werden im Ordner " + DIR + " gespeichert.")

if os.path.exists(CONFIG) == False:
    os.mkdir(CONFIG)
    print("Ordner " + CONFIG + " wurde erstellt.")
    print("Konfigurationsdatein werden im Ordner " + CONFIG + " gespeichert.")
else:
    print("Konfigurationsdatein werden im Ordner " + CONFIG + " gespeichert.")


os.system('wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/x4-upscaling.yaml -P ./' + CONFIG)
os.system('wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference-v.yaml -P ./' + CONFIG)
os.system('wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference.yaml -P ./' + CONFIG)
os.system('wget https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inpainting-inference.yaml -P ./' + CONFIG)

os.system('cp ./' + CONFIG + '/v2-inference-v.yaml ./stable-diffusion-webui/models/Stable-diffusion/v2-1_768-nonema-pruned.yaml')
os.system('cp ./' + CONFIG + '/v2-inference-v.yaml ./stable-diffusion-webui/models/Stable-diffusion/512-base-ema.yaml')
os.system('cp ./' + CONFIG + '/x4-upscaling.yaml ./stable-diffusion-webui/models/Stable-diffusion/x4-upscaler-ema.yaml')



for i in link_array:
    print("Download Model:")
    print(i[0])    
    print(i[1])
    print(" ")
    return_val = hf_hub_download(repo_id=i[0], filename=i[1], cache_dir="./"+DIR)
    os.system('cp '+ return_val +' ./stable-diffusion-webui/models/Stable-diffusion/'+i[1])  
    print("Modell "+ i[1] +" wird in den Ordner /stable-diffusion-webui/models/Stable-diffusion/ kopiert.")
    print(" ")

EOF
)

python3 -c "$PYCMD"

chmod +x ./stable-diffusion-webui/webui.sh
./stable-diffusion-webui/webui.sh --no-half --share
