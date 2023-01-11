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

if os.path.exists(DIR) == False:
    os.mkdir(DIR)
    print("Ordner " + DIR + " wurde erstellt.")
else:
    print("Modelle werden im Ordner " + DIR + " gespeichert.")

for i in link_array:
    print("Download Model:")
    print(i[0])    
    print(i[1])
    print(" ")
    return_val = hf_hub_download(repo_id=i[0], filename=i[1], cache_dir="./"+DIR)
    os.system('cp '+ return_val +' ./stable-diffusion-webui/models/Stable-diffusion/'+i[1])  
    print("Modell "+ i[1] +" wird in den Ordner /stable-diffusion-webui/models/Stable-diffusion/ kopiert.")
    print(" ")

os.system('cp ./stable-diffusion-webui/v2-inference-v.yaml ./stable-diffusion-webui/models/Stable-diffusion/v2-1_768-nonema-pruned.yaml')

EOF
)

python3 -c "$PYCMD"

chmod +x ./stable-diffusion-webui/webui.sh
./stable-diffusion-webui/webui.sh --share
