# Script for cudart, torch, vllm and environment setup

sudo apt update
sudo apt install -y libcudart12

ldconfig -p | grep libcudart

sudo apt install -y libnuma-dev

pip uninstall -y vllm

# uv install
curl -LsSf https://astral.sh/uv/install.sh | sh

uv python install 3.12
uv venv --python 3.12 vllm_env
cd vllm_env
source vllm_env/bin/activate

python -m pip uninstall -y vllm


python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

python -m pip install torch==2.9.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130


python - <<'PY'
import torch, os
torch_lib = os.path.join(os.path.dirname(torch.__file__), "lib")
print("torch lib dir =", torch_lib)
PY


export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"

# 로더가 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"
python -c "import torch; print(torch.cuda.is_available(), torch.cuda.device_count())"


## 영구 적용
sudo tee /etc/ld.so.conf.d/torch.conf >/dev/null <<EOF
$TORCH_LIB
EOF
sudo ldconfig
ldconfig -p | grep libtorch_cuda || true




python -m pip install "numpy==1.26.4" "scipy==1.11.4" 
python -m pip install setuptools_scm
python -m pip uninstall -y opencv-python-headless opencv-python opencv-contrib-python opencv-contrib-python-headless





# ## vllm intall

# https://docs.vllm.ai/en/latest/getting_started/installation/gpu/index.html#full-build
# install PyTorch first, either from PyPI or from source
git clone https://github.com/vllm-project/vllm.git
cd vllm
# pip install -e . does not work directly, only uv can do this

python -m pip install grpcio-tools
export PIP_NO_BUILD_ISOLATION=0
unset PIP_NO_BUILD_ISOLATION
sudo apt install -y ninja-build
export CMAKE_MAKE_PROGRAM=$(which ninja)

rm -rf build/ dist/ *.egg-info .eggs/ cmake-build-debug/ .deps/

python -c "import os; print('cpu core number : ', os.cpu_count())"

MAX_JOBS=8 

python -m pip install -e . --no-build-isolation --no-cache-dir --no-deps

python -m pip install "numpy==1.26.4" "scipy==1.11.4" 

