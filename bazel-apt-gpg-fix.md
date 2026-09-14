# Bazel APT 저장소 GPG 오류 해결

## 증상

다음과 같은 오류가 발생할 때 사용합니다.

```text
W: GPG error: https://storage.googleapis.com/bazel-apt stable InRelease:
The following signatures couldn't be verified because the public key is not available:
NO_PUBKEY 3D5919B448457EE0
```

원인은 Bazel APT 저장소의 공개키가 설치되어 있지 않거나, 저장소 설정에 해당 keyring이 지정되어 있지 않기 때문입니다.

## 1. Bazel signing key 설치

```bash
sudo install -d -m 0755 /etc/apt/keyrings

tmpdir=$(mktemp -d)
GNUPGHOME="$tmpdir" gpg --batch --keyserver hkps://keyserver.ubuntu.com \
  --recv-keys 3D5919B448457EE0
GNUPGHOME="$tmpdir" gpg --batch --export 3D5919B448457EE0 \
  | sudo tee /etc/apt/keyrings/bazel-archive-keyring.gpg >/dev/null
rm -rf "$tmpdir"

sudo chmod 0644 /etc/apt/keyrings/bazel-archive-keyring.gpg
```

키가 정상적으로 설치되었는지 확인합니다.

```bash
gpg --show-keys --with-fingerprint \
  /etc/apt/keyrings/bazel-archive-keyring.gpg
```

출력에 다음 fingerprint가 포함되어야 합니다.

```text
3D59 19B4 4845 7EE0
```

## 2. Bazel 저장소 설정 수정

기존 Bazel repository 설정을 `signed-by` 방식으로 교체합니다.

```bash
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8' \
  | sudo tee /etc/apt/sources.list.d/bazel.list
```

설정을 확인합니다.

```bash
cat /etc/apt/sources.list.d/bazel.list
```

정상적인 결과:

```text
deb [arch=amd64 signed-by=/etc/apt/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8
```

## 3. APT cache 갱신

```bash
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
```

이제 다음 오류가 없어야 합니다.

```text
NO_PUBKEY 3D5919B448457EE0
```

## 4. Bazel 설치 또는 확인

이미 설치되어 있는지 확인합니다.

```bash
bazel --version
bazelisk --version
```

설치되어 있지 않다면 다음과 같이 설치할 수 있습니다.

```bash
sudo apt-get install bazel
```

이 프로젝트의 `Makefile`은 기본적으로 `bazelisk`를 사용하므로 Bazelisk가 필요한 경우 다음 명령을 사용합니다.

```bash
sudo apt-get install bazelisk
```

설치 확인:

```bash
bazelisk version
```

## 한 번에 실행하기

```bash
sudo install -d -m 0755 /etc/apt/keyrings

tmpdir=$(mktemp -d)
GNUPGHOME="$tmpdir" gpg --batch --keyserver hkps://keyserver.ubuntu.com \
  --recv-keys 3D5919B448457EE0
GNUPGHOME="$tmpdir" gpg --batch --export 3D5919B448457EE0 \
  | sudo tee /etc/apt/keyrings/bazel-archive-keyring.gpg >/dev/null
rm -rf "$tmpdir"

sudo chmod 0644 /etc/apt/keyrings/bazel-archive-keyring.gpg

echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8' \
  | sudo tee /etc/apt/sources.list.d/bazel.list

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
```

## 사용하지 말아야 할 우회 방법

다음 방법은 저장소 서명 검증을 약화시키므로 사용하지 마세요.

```text
trusted=yes
[trusted=yes]
apt-key add
```

`apt-key`는 deprecated 되었으며, 별도의 keyring과 `signed-by` 옵션을 사용하는 방식이 권장됩니다.
