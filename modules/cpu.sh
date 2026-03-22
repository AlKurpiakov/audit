get_cpu_usage(){

	top -bn2 -d 0.2 | grep "Cpu(s)" | tail -1 | awk '{print 100 - $8}'

}
