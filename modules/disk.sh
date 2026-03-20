get_disk_usage(){

	df / | awk 'ND==2 {print $5}'| tr -d %

}
