# howto do cuda, torch, vllm

# 1. 확인
```
- Thor 는 기본적으로 jetpack에서 지원, 별도 cuda 설치 불필요

which nvcc
nvcc --version
nvidia-smi
```


# howto check and install libcudart
```
ldconfig -p | grep libcudart  
ls -al /usr/local/cuda/lib64/libcudart.so

sudo apt update
sudo apt install -y libcudart12

ldconfig -p | grep libcudart
```

*가상환경에서 시작할 것 (python 3.12이어야 함)
```
uv venv --python 3.12 vllm_env
source vllm_env/bin/activate
```


# howto install torch
```
pip uninstall -y torch torchvision torchaudio 
pip cache purge

python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# 버전 확인
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu129
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu130

python -m pip install torch==2.9.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130


export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"


# 로더가 이제 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"


# 혹은 아래와 같이 영구적용

sudo tee /etc/ld.so.conf.d/torch.conf >/dev/null <<EOF
$TORCH_LIB
EOF
sudo ldconfig
ldconfig -p | grep libtorch_cuda || true

```



# howto check torch
```
1) 설치된 torch가 “CUDA 빌드”이고 libtorch_cuda.so가 있는지 확인
(1) torch 빌드 확인
python - <<'PY'
import torch
print("torch =", torch.__version__)
print("torch.version.cuda =", torch.version.cuda)
print("cuda available =", torch.cuda.is_available())
PY


torch.__version__에 +cu130 같은 표기가 나오고,

torch.version.cuda가 13.0(또는 13.x) 계열로 찍혀야 “CUDA 빌드”입니다. (cu130 인덱스 자체는 존재합니다. )

(2) libtorch_cuda.so 파일 존재 확인
python - <<'PY'
import torch, os
torch_lib = os.path.join(os.path.dirname(torch.__file__), "lib")
print("torch lib dir =", torch_lib)
PY

ls -al "$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)" | grep -E "libtorch_cuda\.so|libtorch_cpu\.so" || true

아래와 같이 나옴
-rwxrwxr-x  1 lge lge 249319081 Jan 28 14:19 libtorch_cpu.so
-rwxrwxr-x  1 lge lge 509024049 Jan 28 14:19 libtorch_cuda.so

*여기서 libtorch_cuda.so가 아예 없으면: 지금 설치된 torch는 CUDA 패키지처럼 보이더라도 실제로 CUDA lib가 빠진 빌드일 수 있습니다(그 경우 vLLM은 절대 못 뜹니다). “torch/lib에 libtorch_cuda.so가 있어야 CUDA 설치가 맞다”는 확인법도 동일하게 안내됩니다.

2) libtorch_cuda.so가 “있는데도” 못 찾는 경우: 라이브러리 경로 추가 (가장 흔함)
(A) 즉시 테스트(현재 터미널 세션만)
export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"

# 로더가 이제 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"


(B) 영구 적용(권장)

(매번 export 하기 싫으면)

sudo tee /etc/ld.so.conf.d/torch.conf >/dev/null <<EOF
$TORCH_LIB
EOF
sudo ldconfig
ldconfig -p | grep libtorch_cuda || true
```


# howto setup in case of torch installed
```
export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"


# 로더가 이제 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"


# 혹은 아래와 같이 영구적용

sudo tee /etc/ld.so.conf.d/torch.conf >/dev/null <<EOF
$TORCH_LIB
EOF
sudo ldconfig
ldconfig -p | grep libtorch_cuda || true
```




# howto install vllm on nvidia thor (cuda, torch)
```
- https://docs.vllm.ai/en/latest/getting_started/installation/gpu/index.html#full-build

# install PyTorch first, either from PyPI or from source

git clone https://github.com/vllm-project/vllm.git
cd vllm
# pip install -e . does not work directly, only uv can do this
uv pip install -e .


sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-venv python3-dev python3.12-dev uv

```



# #############################





# ###########################  torch &libcudart.12.so 없는 문제 발생 시

```
ldconfig -p | grep libcudart  
ls -al /usr/local/cuda/lib64/libcudart.so

sudo apt update
sudo apt install -y libcudart12

ldconfig -p | grep libcudart


python -m pip uninstall -y torch torchvision torchaudio 
python -m pip cache purge

python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# 버전 확인
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu129
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu130

pip install torch==2.9.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130

```




# ################################################################
```
python -m pip install "numpy==1.26.4" "scipy==1.11.4"

python -m pip uninstall -y opencv-python-headless opencv-python opencv-contrib-python opencv-contrib-python-headless


numpy, scipy version confict 해결


# 확인
which vllm
vllm --version
python -c "import vllm; print(vllm.__file__)"

```




rsync -avh --progress /tmp/EXAONE-4.0-32B-FP8 lge@10.231.182.159:~/ai-models/



# (중요) Hugging Face 네트워크 접근 완전 차단
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
export HF_DATASETS_OFFLINE=1


# ptxas 경로 없어서 에러
export CUDA_HOME=/usr/local/cuda
export PATH="${CUDA_HOME}/bin:${PATH}"
export TRITON_PTXAS_PATH="${CUDA_HOME}/bin/ptxas"

vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85


# 아래 명령어로 성공함.
python -m vllm.entrypoints.openai.api_server \
  --model /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85


# 지금 에러는 “컴파일된 PTX가 문제”라서, vLLM 컴파일 모드를 꺼서 PTX 생성/로딩을 최소화하면 우회되는 경우가 있습니다.
vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85 \
  --enforce-eager



# 에러 : (EngineCore_DP0 pid=31913) ERROR 01-28 18:31:43 [core.py:946] torch.AcceleratorError: CUDA error: the provided PTX was compiled with an unsupported toolchain.
```
nvidia-smi
nvcc --version || true
/usr/local/cuda/bin/ptxas --version || true

 /usr/local/cuda/bin/ptxas --version || true
ptxas: NVIDIA (R) Ptx optimizing assembler
Copyright (c) 2005-2025 NVIDIA Corporation
Built on Tue_Dec_16_07:22:57_PM_PST_2025
Cuda compilation tools, release 13.1, V13.1.115
Build cuda_13.1.r13.1/compiler.37061995_0

export CUDA_HOME=/usr/local/cuda
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
export TRITON_PTXAS_PATH="$CUDA_HOME/bin/ptxas"


rm -rf ~/.cache/torch/inductor ~/.triton ~/.cache/triton
```




# To test service

```
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \  # 없으면 생략 가능
  -d '{
    "model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
    "messages": [{"role": "user", "content": "안녕하세요, 한국어로 대화할 수 있나요?"}],
    "temperature": 0.1
  }'
  
   YOUR_API_KEY는 기본값으로 secret이며, --api-key 옵션으로 변경 가능
```   


# To change option
```
5.1. 양자화(Quantization) 설정
FP8, AWQ, GPTQ 등 다양한 양자화 방식을 지원합니다.

BASH

vllm serve LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --quantization fp8 \
  --dtype fp8
5.2. GPU 메모리 최적화
BASH

vllm serve LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --gpu-memory-fraction 0.9 \  # GPU 메모리의 90% 사용
  --max-num-batched-tokens 4096
5.3. API 키 설정
BASH

vllm serve LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --api-key my-secret-key
```   
