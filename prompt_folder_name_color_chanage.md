# Prompt color change

```
1. .bashrc 파일 열기
터미널에서 다음 명령어를 입력하여 .bashrc 파일을 엽니다.

nano -/.bashrc
텍스트 편집기가 열리면, 아래에 있는 PS1 설정 부분을 찾거나, 새로운 줄에 색상 코드를 추가할 수 있습니다.

2. 색상 코드 추가
터미널 프롬프트에서 원하는 부분에 색상을 적용하려면 ANSI 색상 코드를 사용할 수 있습니다. 색상 코드는 다음과 같습니다:

  -녹색(Green): \033[0;32m
  -노란색(Yellow): \033[0;33m
  -기본 색상(Reset): \033[0m

이 색상 코드를 PS1에 적용하려면 다음과 같이 작성할 수 있습니다.

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[0;32m\]\u@\h\[\033[0m\]:\[\033[0;33m\]\w\[\033[0m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

위 코드에서:

\u: 사용자 이름(username)
\h: 호스트 이름(hostname)
\w: 현재 작업 디렉토리(current directory)
\033[0;32m: 녹색으로 설정
\033[0;33m: 노란색으로 설정
\033[0m: 색상 초기화(reset)

```


# 폴더명 색상 변경
```
LS_COLORS=$LS_COLORS:'di=33:' ; export LS_COLORS
```

