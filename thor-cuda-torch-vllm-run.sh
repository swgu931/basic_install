# howto run vllm on thor/cuda/torch


# run virtual envrionment
### 가상환경에서 시작할 것 (python 3.12이어야 함)
### uv venv --python 3.12 vllm_env
source vllm_env/bin/activate



# LD_LIBRARY_PATH 설정
export TORCH_LIB="$(python - <<'PY'
import torch, os
print(os.path.join(os.path.dirname(torch.__file__), "lib"))
PY
)"
export LD_LIBRARY_PATH="$TORCH_LIB:$LD_LIBRARY_PATH"

export PATH=/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH
export CUDA_HOME=/usr/local/cuda-13.0


### 로더가 이제 찾는지 테스트
python -c "import ctypes; ctypes.CDLL('libtorch_cuda.so'); print('libtorch_cuda.so load OK')"
python -c "import torch; print(torch.cuda.is_available(), torch.cuda.device_count())"



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
  --max-model-len 16384 \
  --gpu-memory-utilization 0.85 \
  --served-model-name LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --dtype bfloat16 \
  --enforce-eager

# 4096 8192  16384  32768 65536 

# 아래 명령어로 성공함.
python -m vllm.entrypoints.openai.api_server \
  --model /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.85 \
  --served-model-name LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --enforce-eager

# 지금 에러는 “컴파일된 PTX가 문제”라서, vLLM 컴파일 모드를 꺼서 PTX 생성/로딩을 최소화하면 우회되는 경우가 있습니다.
VLLM_ATTENTION_BACKEND=FLASHINFER
vllm serve /home/lge/ai-models/exaone-4.0-32b-fp8/ \
  --port 8080 \
  --max-model-len 65536 \
  --gpu-memory-utilization 0.85 \
  --served-model-name LGAI-EXAONE/EXAONE-4.0-32B-FP8 \
  --enforce-eager


curl http://10.231.182.159:8080/v1/chat/completions   -H "Content-Type: application/json"   -d '{
    "model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
    "messages": [{"role": "user", "content": "안녕하세요, 한국어로 대화할 수 있나요?"}],
    "temperature": 0.1
  }'

curl http://10.231.182.159:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
    "messages": [{"role": "user", "content": "안녕하세요, 한국어로 대화할 수 있나요?"}],
    "temperature": 0.1,
    "max_tokens": 128,
    "stream": true
  }'


curl -X POST "http://10.231.182.159:8080/v1/chat/completions" \
	-H "Content-Type: application/json" \
	--data '{
		"model": "LGAI-EXAONE/EXAONE-4.0-32B-FP8",
		"messages": [
			{
				"role": "user",
				"content": "What is the capital of France?"
			}
		],
        "temperature": 0.1,
        "max_tokens": 128,
        "stream": true
	}'
