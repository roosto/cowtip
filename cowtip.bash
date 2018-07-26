#!/bin/bash

#  ________________________ 
# / Author: Dustin Goldman \
# \ <dusto@goldmans.net>   /
#  ------------------------ 
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||


_cowtip_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # like FindBin in Perl

backdoor="$1"

. $_cowtip_dir/.cowtip.conf

if $cowsay_random
then
	cow_files="$(find ${cowsay_cowpath//:/ } -maxdepth 1 -type f -name '*.cow')"
	cow_count=$(echo ${cow_files//:/ } | tr ' ' '\n' | wc -l)
	target_cow=$(perl -e "print (int rand $cow_count)") # returns random within 0 to $cow_count -1, inclusive
else
	target_cow=$(perl -e 'print (int rand 2);') # randomly 0 or 1
fi

function do_output {

	cowsay_bin_do=$cowsay_bin
	if $cowsay_cowthink_random && [[ $(( $target_cow % 2 )) == 0 ]]
	then
		cowsay_bin_do=$(dirname $cowsay_bin)/cowthink
	fi

	cowfile_arg=''
	if [[ -n "$1" ]]
	then
		cowfile_arg="-f $1"
	fi

	$fortune_bin $fortune_user_defined_args $fortune_paths > $_cowtip_dir/last.txt || return $?
	$cowsay_bin_do $cowsay_user_defined_args -n $cowfile_arg < $_cowtip_dir/last.txt || return $?
	return 0
}

function check_cookie_file {
	cookie_file="$1"
	dat_file_tho=$cookie_file.dat
	regenerate_reason=''

	if [[ ! -e $dat_file_tho ]]
	then
		regenerate_reason='does not exist'
	elif [[ $cookie_file -nt $dat_file_tho ]]
	then
		regenerate_reason="older than $cookie_file"
	fi

	if [[ -n "$regenerate_reason" ]]
	then
		echo "$dat_file_tho: $regenerate_reason" 1>&2
		echo "strfile $cookie_file"
		return 1
	fi

	return 0
}

function check_setup {
	strfile_script=$_cowtip_dir/setup.sh
	echo -e '#!/bin/sh\n' > $strfile_script
	echo -e 'if ! which strfile > /dev/null \nthen' >> $strfile_script
	echo -e '\techo "I cannot find the strfile binary (it should have been installed with fortune)" 1>&2' >> $strfile_script
	echo -e '\texit 1' >> $strfile_script
	echo -e 'fi\n' >> $strfile_script

	for path_entry in $fortune_paths
	do
		if [[ $path_entry =~ .dat$ ]] && [[ -f $path_entry ]]
		then
			check_cookie_file $(basename -s .dat $path_entry) >> $strfile_script && \
				echo "$path_entry: up to date" 1>&2
		elif [[ -d $path_entry ]]
		then
			for cookie_file in $(find $path_entry -maxdepth 1 -type f -and -not -name '*.dat')
			do
				check_cookie_file $cookie_file >> $strfile_script && \
					echo "$cookie_file.dat: up to date" 1>&2
			done
		fi
	done

	echo '' 1>&2
	if grep -q '^strfile' $strfile_script
	then
		chmod a+x $strfile_script
		echo "Some fortune files are not up to date or do not exist" 1>&2
		echo 'I generated a script for you get these files up to date' 1>&2
		echo '' 1>&2
		echo "Script is at: $strfile_script" 1>&2
		return 1
	fi

	rm $strfile_script
	echo "OK. All fortune files are up to date" 1>&2
	return 0
}

if [[ $backdoor =~ 'validate' ]]
then
	check_setup
	exit $?
elif [[ $# -gt 0 ]]
then
	output_redir='1>&2'
	if [[ "$@" =~ 'help' ]]
	then
		output_redir=''
	fi

	eval "echo Usage: $(basename $0) [--validate] $output_redir"

	[[ -z $output_redir ]] # exit 0 for --help
	exit $?
fi

if $cowsay_random
then
	i=0
	for cow in $cow_files
	do
		if [[ $i == $target_cow ]]
		then
			do_output $cow
			exit $?
		fi

		i=$(( $i + 1 ))
	done
fi

# no random cow, means we have to set COWPATH so as it can find default.cow
export COWPATH="$cowsay_cowpath"
do_output
exit $?
