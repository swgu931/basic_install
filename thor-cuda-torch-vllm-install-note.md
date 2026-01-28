# howto do cuda, torch, vllm





# NVIDIA Thor는 기본적으로 CUDA 13이 설치되어 있음
# CUDA 12를 별도로 설치해야 함

# 1. CUDA 12 다운로드 (aarch64용)
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/aarch64/cuda-12-6_12.6.85-1_aarch64.deb

# 2. 설치
sudo dpkg -i cuda-12-6_12.6.85-1_aarch64.deb
sudo apt-get install -f

# 3. 환경 변수 설정
echo 'export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}' >> -/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> -/.bashrc
source ~/.bashrc

# 4. 확인
which nvcc
nvcc --version



# howto install vllm on nvidia thor


sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-venv python3-dev python3.12-dev uv

python3.12 -m venv vllm_env
source vllm_env/bin/activate

pip install --upgrade pip

# PyTorch + CUDA 13.0 설치
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130

# vLLM 0.13.0 + CUDA 13.0 + Python 3.12용 휠 설치 : 실패
## pip install https://github.com/vllm-project/vllm/releases/download/v0.13.0/vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl
## wget -O vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl \
##  https://github.com/vllm-project/vllm/releases/download/v0.13.0/vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl



# #############################

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


여기서 libtorch_cuda.so가 아예 없으면: 지금 설치된 torch는 CUDA 패키지처럼 보이더라도 실제로 CUDA lib가 빠진 빌드일 수 있습니다(그 경우 vLLM은 절대 못 뜹니다). “torch/lib에 libtorch_cuda.so가 있어야 CUDA 설치가 맞다”는 확인법도 동일하게 안내됩니다.

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

# vllm 다시 실행
vllm serve LGAI-EXAONE/EXAONE-4.0-32B-FP8 --port 8080


이걸로 바로 뜨면, 원인은 100% “경로”입니다.

(B) 영구 적용(권장)

(매번 export 하기 싫으면)

sudo tee /etc/ld.so.conf.d/torch.conf >/dev/null <<EOF
$TORCH_LIB
EOF
sudo ldconfig
ldconfig -p | grep libtorch_cuda || true



# ###########################  torch &libcudart.12.so 없는 문제 발생 시


ldconfig -p | grep libcudart  
ls -al /usr/local/cuda/lib64/libcudart.so

sudo apt update
sudo apt install -y libcudart12

ldconfig -p | grep libcudart


pip uninstall -y torch torchvision torchaudio 
pip cache purge

python -m ensurepip --upgrade
python -m pip install --upgrade pip setuptools wheel

# 버전 확인
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu129
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu130

pip install torch==2.9.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130






# ################################################################

pip install "numpy==1.26.4" "scipy==1.11.4"

pip uninstall -y opencv-python-headless opencv-python opencv-contrib-python opencv-contrib-python-headless


rsync -avh --progress /tmp/EXAONE-4.0-32B-FP8 lge@10.231.182.159:~/ai-models/



# (중요) Hugging Face 네트워크 접근 완전 차단
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
export HF_DATASETS_OFFLINE=1


# ptxas 경로 없어서 에러
export CUDA_HOME=/usr/local/cuda
export PATH="${CUDA_HOME}/bin:${PATH}"
export TRITON_PTXAS_PATH="${CUDA_HOME}/bin/ptxas"

vllm serve ~/ai-models/EXAONE-4.0-32B-FP8 --port 8080

vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85








## To test service


curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \  # 없으면 생략 가능
  -d '{
    "model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
    "messages": [{"role": "user", "content": "안녕하세요, 한국어로 대화할 수 있나요?"}],
    "temperature": 0.1
  }'
  
   YOUR_API_KEY는 기본값으로 secret이며, --api-key 옵션으로 변경 가능
   
   
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
   
