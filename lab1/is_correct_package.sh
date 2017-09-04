#!/bin/bash

i=0
packages=""
for arg in $@; do
	if (( i == 0 )); then
		current_dir=$arg/src
	else
		packages=" $arg"
	fi
	let "i=i+1"
done

if [[ $packages == "" ]] || [[ $packages == " " ]]; then
	(>&2 echo -e "Error: no packages are matched to be recognized")
	exit 1
fi

for package in $packages; do
	package=${package##*/}
	if [[ $(find $current_dir -maxdepth 1 -mindepth 1 -name "$package" ) == "" ]]; then
		(>&2 echo -e "Error: Couldn't find $package in $current_dir directory")
	xml=$(find $current_dir/$package -maxdepth 1 -mindepth 1 -name "package.xml")
	if [[ "$xml" == "" ]]; then
		(>&2 echo -e "Error: no package.xml file in a package directory")
		(>&2 echo -e "       package directory: $current_dir/$package")
		exit 1
	fi
	project_xml=$(cat $xml | grep "<name>")
	project_xml=${project_xml#*<name>}
	project_xml=${project_xml%</name>*}

	cmake=$(find $current_dir/$package -maxdepth 1 -mindepth 1 -name "CMakeLists.txt")
	if [[ "$cmake" == "" ]]; then
		(>&2 echo -e "Error: no CMakeLists.txt file in a package directory")
		(>&2 echo -e "       package directory: $current_dir/$package")
		exit 1
	fi
	project_cmake=$(cat $cmake | grep "project(")
	project_cmake=${project_cmake#*project(}
	project_cmake=${project_cmake%%)*}

	if [[ "$project_xml" != "$project_cmake" ]]; then
		(>&2 echo -e "Error: project name is not defined")
		(>&2 echo -e "       package.xml contains:    $project_xml")
		(>&2 echo -e "       CMakeLists.txt contains: $project_cmake")
		exit 1
	fi
	
done
echo -e "packages are correct!"
exit 0
