# torch install in virtual environment

## precondition for cuda version : cuda, cuda-toolkit with "nvidia-smi", "nvcc --version"

## NVIDIA-SMI 570.211.01             Driver Version: 570.211.01     CUDA Version: 12.8

## Cuda compilation tools, release 13.1, V13.1.115
## Build cuda_13.1.r13.1/compiler.37061995_0


sudo apt update
sudo apt install python3-pip python3-venv -y

# uv install
curl -LsSf https://astral.sh/uv/install.sh | sh


uv venv venv
source venv/bin/activate


python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu128
python -m pip install torch==2.10.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128


python3 -c "import torch; print(f'PyTorch 버전: {torch.__version__}'); print(f'GPU 사용 가능 여부: {torch.cuda.is_available()}'); print(f'장치 이름: {torch.cuda.get_device_name(0)}')"


export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"

python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"
python -c "import torch; print(torch.cuda.is_available(), torch.cuda.device_count())"

