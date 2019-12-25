#!/bin/bash
#code jshint using jshint, runs on linux shell base system

#instalation of jshint has more then one step
#1# Donwload npm/node and https://nodejs.org/en/
# extract the download file then do the bellow on the terminal

# sudo mkdir /usr/lib/nodejs
# sudo mv /path_of_extracted_node_version /usr/lib/nodejs/node

# after OK on the terminal commands export the variable past the below at the end of yours .bashrc file (remove the #)
# export NODEJS_HOME=/usr/lib/nodejs/node
# export PATH=$NODEJS_HOME/bin:$PATH

# now install jshint via terminal
# npm install jshint -g

#to exec this file or drag this .sh file to terminal to generate a released

#timer counter
START=$(date +%s.%N);
#colors
txtbld=$(tput bold) # Bold
bldbldred=${txtbld}$(tput setaf 1) # bldred
bldgrn=${txtbld}$(tput setaf 2) # bldgrn
bldyel=${txtbld}$(tput setaf 3) # yellow
bldblu=${txtbld}$(tput setaf 4) # blue
NC='\033[1m'

# add js folders here
js_folders=("app/languages/" "app/general/" "app/specific/" "app/thirdparty/");

# no changes needed to be done bellow this line
mainfolder="$(dirname ""$(dirname "$0")"")";

cd "$mainfolder" || exit

master_start=$(echo "$a" | sed -n '/APISTART/,/APIMID/p' release/api.js);
master_end=$(echo "$a" | sed -n '/APICENTER/,/APIEND/p' release/api.js);

# jshint indent all the *.js code
js_jshint() {
	array=( "$@" );
	for i in "${array[@]}"; do
		cd "$i" || exit;
		for x in *.js; do
			cat "$x" >> "$mainfolder"/release/master.js
		done
		cd - &> /dev/null || exit;
	done

	echo "$master_end" >> "$mainfolder"/release/master.js;

	jsh_check="$(jshint "$mainfolder"/release/master.js)";
	if [ ! -z "$jsh_check" ]; then
		echo -e "${bldred}	JSHint erros or warnings found:\\n"
		echo -e "${bldred}	$jsh_check"
		echo -e "\\n${bldred}	Fix the problems and try the release maker again\\n"
		exit;
	else
		echo -e "${bldblu}	JSHint Test finished no errors or warnings found"
	fi;
}

if which 'jshint' >/dev/null ; then
	if [ "$1" == 1 ]; then
		npm install jshint -g
	fi;
	echo -e "${bldgrn}\nJSHint Test started...\\n";
	echo -e '/* jshint eqeqeq: true, undef: true, unused: true, node: true, browser: true */\n/*globals tizen, webapis, ReconnectingWebSocket, punycode, smartTwitchTV */' > "$mainfolder"/release/master.js;
	echo "$master_start" >> "$mainfolder"/release/master.js;
	js_jshint "${js_folders[@]}";
else
	echo -e "\\n${bldred}can't run jshint because it is not installed";
        echo -e "${bldred}To install jshint read the jshint.sh notes on the top of the file\\n";
	echo -e "${bldred}.js files not checked.\\n";
	exit;
fi;

END=$(date +%s.%N);
echo -e "${bldgrn}Total elapsed time of the script: ${bldbldred}$(echo "($END - $START) / 60"|bc ):$(echo "(($END - $START) - (($END - $START) / 60) * 60)"|bc ) ${bldyel}(minutes:seconds).\n${NC}";
exit;
