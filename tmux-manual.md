
$ tmux

# 이름을 지정하여 세션 생성
$ tmux new -s <session_name>
$ tmux new-session -s <session_name>

# 세션 이름 수정
[Ctrl] + b, $

# 세션 detach
[Ctrl] + b, d

# 세션 리스트보기
$ tmux ls

# 세션 attach
$ tmux attach -t <session number 혹은 session name>

# 세션 종료, 세션의 마지막 윈도우, 마지막 팬에서 실행
$ exit

# 세션 종료, 세션 밖에서 실행
$ tmux kill-session -t session_name


-------------

# 윈도우 생성
[Ctrl] + b, c

# 세션 생성과 함께 윈도우 생성
$ tmux new -s -n

# 윈도우 이름 변경
[Ctrl] + b, ,

# 윈도우 종료
[Ctrl] + b, &
[Ctrl] + d

# 다음 윈도우(Next Window)로 이동
[Ctrl] + b, n

# 이전 윈도우(Previous Window)로 이동
[Ctrl] + b, p

# 마지막 윈도우(Last Window)로 이동
[Ctrl] + b, l

# 특정 윈도우로 이동 (몇 번째 윈도우인지)
[Ctrl] + b, 0-9

# 특정 윈도우로 이동 (이름으로 이동)
[Ctrl] + b, f

# 윈도우 리스트 보기
[Ctrl] + b, w

-------------

# 세로 화면 분할
[Ctrl] + b, %

# 가로 화면 분할
[Ctrl] + b, "

# 팬 이동 - 화면에 나오는 숫자로 이동
[Ctrl] + b, q

# 팬 이동 - 순서대로 이동
[Ctrl] + b, o

# 팬 이동 - 방향키로 이동
[Ctrl] + b, <방향키>

# 팬 삭제
[Ctrl] + d
[Ctrl] + b, x

# 팬 사이즈 조절 - 현재 포커스된 팬 전체화면(한번 더 실행하면 윈상복구)
[Ctrl] + b, z

# 팬 사이즈 조절 [Ctrl] + b 를 누른 후 :
[Ctrl] + b, :
resize-pane -L or -R or -U -D

# 팬 레이아웃 변경 (다양한 레이아웃으로 자동 전환)
[Ctrl] + b, spacebar


--------------------------------------------


# 단축키 목록
$ [Ctrl] + b, ?

# 키 바인딩 및 언바인딩
[Ctrl] + b, :
bind-key [-cnr] [-t key-table] key command [arguments]
unbind-key [-acn] [-t key-table] key

# 옵션 설정 - set-option
[Ctrl] + b, :
set -g

# 옵션 설정 - set-window-option
[Ctrl] + b, :
setw -g

# 열려있는 모든 팬에 동시 입력하기
[Ctrl] + b, :
setw synchronize-panes on

------------------------------
[Ctrl] + b, :

set -g status-bg white



[Ctrl] + b, :

setw -g window-status-current-bg red



# Copy 모드로 들어가기
[Ctrl] + b, [

# 빠져나오기
[ESC]
q


------------------------------


