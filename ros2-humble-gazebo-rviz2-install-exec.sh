# 1. 최신 ROS 2 GPG 키를 다운로드하여 키링 업데이트
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# 2. apt 리스트 다시 업데이트
sudo apt update


# 필수 패키지 설치 (설치되어 있지 않은 경우)
sudo apt update
sudo apt install ros-humble-gazebo-* ros-humble-navigation2 ros-humble-nav2-bringup ros-humble-turtlebot3-gazebo ros-humble-turtlebot3-navigation2 ros-humble-turtlebot3-simulations ros-humble-turtlebot3-teleop


# Terminal 1
# 로봇 모델 설정 (waffle 추천)
export TURTLEBOT3_MODEL=waffle_pi
# Gazebo 실행
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py


# Terminal 2
# 로봇 모델 설정
export TURTLEBOT3_MODEL=waffle_pi
# Nav2와 RViz2 실행 (가상 시간 사용)
ros2 launch turtlebot3_navigation2 navigation2.launch.py use_sim_time:=True map:=/opt/ros/humble/share/turtlebot3_navigation2/map/map.yaml


# Terminal 3
export TURTLEBOT3_MODEL=waffle_pi
ros2 run turtlebot3_teleop teleop_keyboard
