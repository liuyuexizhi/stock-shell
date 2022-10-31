#! /bin/sh


function get_q_list() {
		q_list=''

		OLD_IFS=$IFS
		IFS=$'\n'
		for each in $(cat stock.cnf)
		do
				[[ -z ${q_list} ]] && q_list=$(grep "${each}"'"$' data/all_*_list.txt | awk -F '"' '{print $2}') || q_list=${q_list},$(grep "${each}"'"$' data/all_*_list.txt | awk -F '"' '{print $2}')
		done
		IFS=$OLD_IFS

		echo ${q_list}
}

function print_info() {
    q_list=$(get_q_list)
    curl -sL https://hq.sinajs.cn/list=${q_list} -e "https://finance.sina.com.cn/realstock" | iconv -f GB2312 -t UTF-8 > temp.txt

    OLD_IFS=$IFS
    IFS=$'\n'
		
		echo "股票名称 当前价格 涨跌幅度 更新时间"
		echo "-------- -------- -------- --------"
    for line in $(cat temp.txt)
    do
        name=$(echo ${line} | awk -F '"' '{print $2}' | awk -F ',' '{print $1}')
        last_price=$(echo ${line} | awk -F '"' '{print $2}' | awk -F ',' '{print $3}')
        now_price=$(echo ${line} | awk -F '"' '{print $2}' | awk -F ',' '{print $4}')
        now_time=$(echo ${line} | awk -F '"' '{print $2}' | awk -F ',' '{if ($(NF-1)=='00'){ print $(NF-2) } else { print $(NF-1)} }')
        percent=$(echo """scale=3;result=(${now_price}-${last_price})/${last_price}*100;if (result < 0) {if (length(result)==scale(result)) {print "-0";print -result} else { print result}} else {if (length(result)==scale(result)) {print 0;print result} else {print result}}""" | bc)
        [[ "${percent}" =~ '-' ]] || percent="+${percent}"
        echo "`echo ${name} | sed 's/ //g'` ${now_price} ${percent}% ${now_time}"
    done
    IFS=$OLD_IF
}


function main() {
		while true
		do
				clear
				print_info | column -t
				sleep 5
		done
}

main 
