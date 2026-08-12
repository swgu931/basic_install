# 전체 논리 코어 수 확인: 
echo "grep -c processor /proc/cpuinfo"
grep -c processor /proc/cpuinfo

# 물리 CPU 칩 개수 확인: 
echo "grep "physical id" /proc/cpuinfo | sort -u | wc -l"
grep "physical id" /proc/cpuinfo | sort -u | wc -l

# CPU당 물리 코어 수 확인: 
echo "grep "cpu cores" /proc/cpuinfo"
grep "cpu cores" /proc/cpuinfo
