# 1. 최신 ROS 2 GPG 키를 다운로드하여 키링 업데이트
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# 2. apt 리스트 다시 업데이트
sudo apt update


```
● sudo apt update itself succeeded — everything except the Intel RealSense repo refreshed. The only failure is that the RealSense signing key (FB0B24895113F120) isn't in any trusted
  keyring on that machine, so its index was skipped and the cached one reused.

  One thing worth flagging: this workstation has no librealsense entry at all (/etc/apt/sources.list.d/ here holds only docker, chrome, task, vscode, ubuntu), and no ros2/gh/nodesource
  entries either — so that output came from a different host (presumably the robot). Run the fix there.

  Fix — re-add the repo with a proper keyring (Intel's current instructions; the old apt-key-style setup is what broke):

  sudo mkdir -p /etc/apt/keyrings
  curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp \
    | sudo tee /etc/apt/keyrings/librealsense.pgp > /dev/null

  echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/librealsense.list

  sudo apt update

  If an older duplicate entry exists (e.g. in /etc/apt/sources.list or another .list file), remove it first or you'll get a "configured multiple times" warning:

  grep -rn librealsense /etc/apt/sources.list /etc/apt/sources.list.d/

  Alternative if the .pgp fetch is blocked — pull the key from a keyserver into its own keyring:

  sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/librealsense.gpg \
    --keyserver keyserver.ubuntu.com --recv-keys FB0B24895113F120
  (then point signed-by= at /etc/apt/keyrings/librealsense.gpg)

  If you don't actually need RealSense packages on that host, the cleanest fix is to drop the repo so the warning stops:

  sudo rm /etc/apt/sources.list.d/librealsense.list   # confirm the filename with the grep above first
  sudo apt update

  I can't run any of these for you — sudo/apt is outside my sandbox and the target is another machine. Type ! <command> in the prompt to run them here, or paste the output from the
  robot and I'll take it from there.

```
