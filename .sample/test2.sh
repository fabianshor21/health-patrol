#!/bin/bash
a="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur"
printf "| %-50s |\n\n" "$a"

while IFS= read -r each_row; do
	idx_dis=$(echo "$each_row" | tr -s '\t' '@' | cut -d '@' -f 4)
	acc_dis=$(echo "$each_row" | tr -s '\t' '@' | cut -d '@' -f 1)
	echo "$idx_dis - $acc_dis"
done < "database/health_info/fetch_results.more"
