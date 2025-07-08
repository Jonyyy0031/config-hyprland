GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
GPU_MEM=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F', ' '{printf "%.0f/%.0f", $1/1024, $2/1024}')
echo "${GPU_USAGE}% ${GPU_MEM}GB"