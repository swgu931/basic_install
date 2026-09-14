# `main` 브랜치 내용을 `wan-v1`에 머지하는 명령어

현재 작업 트리는 `cloi_entropos_sdk` 저장소의 `wan-v1` 브랜치입니다. 아래 명령은 원격 `origin/main`의 최신 내용을 현재 `wan-v1` 브랜치로 가져와 머지합니다.

> 주의: 현재 작업 트리에 추적되지 않은 `bazel-bin`, `bazel-out`, `bazel-testlogs`가 있습니다. 머지 전에 이 파일/디렉터리를 삭제하거나 별도 보관하고, 실제 명령 실행 전 `git status`로 확인하세요.

```bash
# 저장소로 이동
cd /home/gusewan/workspace-cloid/cloi_entropos_sdk

# 현재 상태 확인
 git status

# 원격 브랜치 최신 정보 가져오기
git fetch origin

# 대상 브랜치로 이동
git switch wan-v1

# 안전을 위해 현재 wan-v1의 백업 태그 생성 (필요하면 태그 이름 변경)
git tag wan-v1-before-merge-main-$(date +%Y%m%d-%H%M%S)

# origin/main의 변경사항을 wan-v1에 머지
git merge --no-ff origin/main -m "Merge origin/main into wan-v1"

# 결과 확인
git status
git log --oneline --graph --decorate -20

# 충돌이 발생한 경우:
# 1. 충돌 파일을 수정한 뒤
 git add <수정한-파일>
# 2. 모든 충돌 파일을 추가하고 머지 완료
 git commit

# 머지를 취소해야 하는 경우 (머지 중일 때만)
git merge --abort

# 검증이 끝난 뒤 원격 wan-v1에 반영할 때
# 실제 push 전 반드시 변경사항과 테스트 결과를 확인하세요.
git push origin wan-v1
```

## 로컬 `main`을 기준으로 머지해야 하는 경우

원격 최신 브랜치가 아니라 로컬 `main` 브랜치의 내용을 기준으로 해야 한다면 다음처럼 실행합니다.

```bash
cd /home/gusewan/workspace-cloid/cloi_entropos_sdk
git fetch origin
git switch wan-v1
git merge --no-ff main -m "Merge main into wan-v1"
```

단, 일반적으로는 오래된 로컬 `main`을 실수로 머지하지 않도록 `origin/main`을 직접 지정하는 첫 번째 방법을 권장합니다.

