#!/bin/bash

for i in $(seq 1 22);do echo curl -sL "https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=$i&num=100&sort=volume&asc=0&node=sh_a&symbol=" -e 'https://vip.stock.finance.sina.com.cn/mkt/' > sh_$i.json;done

for i in $(seq 1 28);do curl -sL "https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/Market_Center.getHQNodeData?page=$i&num=100&sort=volume&asc=0&node=sz_a&symbol=" -e 'https://vip.stock.finance.sina.com.cn/mkt/' > sz_$i.json;done

for i in $(seq 1 10);do curl -sL https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/Market_Center.getHQNodeDataSimple?page=$i&num=80&sort=volume&asc=0&node=etf_hq_fund&_s_r_a=setlen -e https://vip.stock.finance.sina.com.cn/mkt/ > etf_$i.json;done

jq '.' -s sh_*.json > all_sh.json
jq '.' -s sz_*.json > all_sz.json
jq '.' -s etf_*.json > all_etf.json
