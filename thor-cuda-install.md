
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
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# vLLM 0.13.0 + CUDA 13.0 + Python 3.12용 휠 설치 : 실패
## pip install https://github.com/vllm-project/vllm/releases/download/v0.13.0/vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl
## wget -O vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl \
##  https://github.com/vllm-project/vllm/releases/download/v0.13.0/vllm0.13.0+cu130-cp312-abi3-manylinux_2_35_aarch64.whl

pip install vllm==0.13.0


huggingface-cli login
vllm serve LGAI-EXAONE/EXAONE-4.0-32B-FP8 --port 8080


# libcudart.12.so 없는 문제 발생 시


ldconfig -p | grep libcudart  
ls -al /usr/local/cuda/lib64/libcudart.so* 


sudo apt update
sudo apt install -y libcudart12

ldconfig -p | grep libcudart


pip uninstall -y torch torchvision torchaudio 
pip cache purge

# 버전 확인
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu129
python -m pip index versions torch --index-url https://download.pytorch.org/whl/cu130

pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124



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
   
