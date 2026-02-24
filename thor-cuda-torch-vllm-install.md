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

sudo apt-get install -y libnuma-dev

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
-rwxrwxr-x  1 lge lge 249319081 Jan 28 14:19 libtorch_cpu.souv python install 3.12
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


rm -rf build/ dist/ *.egg-info .eggs/ cmake-build-debug/ .deps/
python -m pip install -e . --no-build-isolation --no-cache-dir --no-deps


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
LD_LIBRARY_PATH
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



# LD_LIBRARY_PATH 설정
export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"

### 로더가 이제 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"



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
  --max-model-len 32768 \VLLM_ATTENTION_BACKEND=FLASHINFER vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85 \
  --enforce-eager
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
  --max-model-len 65536 \
  --gpu-memory-utilization 0.85 \
  --served-model-name LGAI-EXAONE/EXAONE-4.0-32B-FP8
  --enforce-eager



# 1. FlashInfer 사용 (Thor에서 권장됨)
VLLM_ATTENTION_BACKEND=FLASHINFER vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85 \
  --enforce-eager
# 2. 만약 위 방법이 안 되면 Xformers 사용
# VLLM_ATTENTION_BACKEND=XFORMERS vllm serve ...  



## 
```
1. max-model-len의 의미
max-model-len은 모델이 한 번에 처리할 수 있는 입력(프롬프트) + 출력(생성) 토큰의 최대 길이를 의미합니다.

예시: 32768로 설정하면, 프롬프트가 30000 토큰일 때 최대 2768 토큰까지만 생성할 수 있습니다.
이 값을 넘어서는 입력이 들어오면 에러가 발생하거나 뒷부분이 잘립니다.
값을 크게 잡을수록 메모리(KV Cache)를 많이 미리 예약합니다.
2. EXAONE-4.0-32B-FP8 + 32k(32768) 메모리 사용량 예측
EXAONE 4.0 32B는 GQA (Grouped Query Attention) 기술을 사용하여 메모리 효율이 좋습니다 (Head 40개, KV Head 8개).

설정하신 32768 (32k) 길이에 따른 메모리 사용량은 다음과 같습니다:

모델 가중치 (고정): 약 34 GB (FP8 모델 기준)
KV Cache (context 길이에 비례):
FP16 Cache 사용 시: 약 8.6 GB
FP8 Cache 사용 시: 약 4.3 GB (vLLM 기본값, 또는 --kv-cache-dtype fp8 옵션)
기타 오버헤드 (CUDA Context 등): 약 1~2 GB
🔹 총 예상 소요 메모리 (VRAM)
약 40GB ~ 44GB
만약 NVIDIA Thor의 가용 메모리가 이를 충족한다면 안정적으로 실행될 것입니다. 만약 메모리가 부족하다면, max-model-len을 8192 (약 1GB Cache) 나 16384 (약 2GB Cache) 정도로 줄이거나, --gpu-memory-utilization 옵션을 조절하여 컨텍스트 공간을 줄여야 합니다.




*32768(32k)보다 더 늘리신다면, **2배 단위(Powers of 2)**로 늘리는 것이 가장 효율적이고 일반적입니다.

추천 설정: 65536 (64k) 또는 131072 (128k)
1. 왜 2배 단위인가요?
메모리 관리 효율성: 컴퓨터 시스템(특히 GPU 및 vLLM의 PagedAttention)은 메모리 블록을 할당할 때 2의 거듭제곱 단위로 관리하는 것이 오버헤드가 가장 적습니다.
RoPE (위치 인코딩): LLM의 위치 정보 처리(Rotary Positional Embedding) 알고리즘들이 보통 2k, 4k, 8k, 16k, 32k 단위로 학습되거나 테스트됩니다. 뜬금없는 숫자(예: 40000, 50000)보다는 65536(64k)이 수치적 안정성이 더 높습니다.
2. 메모리 증가량 예측 (EXAONE-32B F8 Cache 기준)
길이를 늘리면 **KV Cache 메모리 사용량은 길이에 정비례(Linear)**해서 늘어납니다.

32,768 (32k): ~4.3 GB (현재)
65,536 (64k): ~8.6 GB (추천)
131,072 (128k): ~17.2 GB
3. 결론 및 주의사항
EXAONE 4.0 모델은 최대 128k까지 지원하므로, Thor 장비의 메모리에 여유가 있다면 65536으로 설정하여 테스트해보시는 것을 권장합니다.



* --enforce-eager 옵션은 vLLM이 CUDA Graph 최적화를 사용하지 않고, PyTorch의 Eager Execution 모드(즉시 실행 모드)로 동작하도록 강제하는 옵션입니다.

1. 역할
CUDA Graph 비활성화: vLLM은 기본적으로 성능을 위해 CUDA Graph(연산 그래프를 미리 캡처해서 재사용하는 기술)를 사용합니다. 이 옵션은 그 기능을 끕니다.
즉시 실행: 연산을 미리 컴파일하거나 캡처하지 않고, 파이썬 코드가 실행되는 순서대로 GPU에 즉시 명령을 보냅니다.
2. 언제/왜 사용하나?
호환성 문제 해결 (주된 이유): 일부 GPU(특히 Thor 같은 최신/임베디드 SoC나 구형 GPU)나 특정 모델 아키텍처에서 CUDA Graph 캡처가 실패하거나 버그가 있을 때, 이 옵션을 켜면 속도는 조금 느려져도 안정적으로 실행됩니다.
디버깅: 에러가 어디서 나는지 정확한 스택 트레이스를 보고 싶을 때 유용합니다.
메모리 절약: CUDA Graph는 그래프 캡처를 위해 추가적인 GPU 메모리를 필요로 합니다. 메모리가 정말 부족할 때 이 옵션을 켜면 약간의 메모리를 아낄 수 있습니다.
3. 단점
성능 저하: CUDA Graph를 쓰지 않으면 작은 배치를 처리할 때 오버헤드가 커져서 **토큰 생성 속도(TPS)**가 약 10~30% 정도 느려질 수 있습니다.
요약하자면: 지금 Thor 환경에서 CUDA Graph 관련 호환성 문제나 에러가 발생했을 가능성이 있어, 안전하게 실행하기 위해 해당 옵션을 켜둔 것으로 보입니다. (만약 에러 없이 잘 돌아간다면 끄는 것이 성능상 유리합니다.)

```




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


curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
    "messages": [{"role": "user", "content": "안녕하세요, 한국어로 대화할 수 있나요?"}],
    "temperature": 0.1
  }'

curl http://10.231.182.159:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
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
