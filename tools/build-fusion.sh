#!/bin/bash

usage()
{
	echo -e ""
	echo -e ${txtbld}"Usage:"${txtrst}
	echo -e "  build-fusion.sh [options] device"
	echo -e ""
	echo -e ${txtbld}"  Options:"${txtrst}
	echo -e "    -c  Clean before build"
	echo -e "    -d  Use dex optimizations"
	echo -e "    -i  Static Initlogo"
	echo -e "    -j# Set jobs"
	echo -e "    -s  Sync before build"
	echo -e "    -p  Build using pipe"
        echo -e "    -o# Select GCC O Level"
        echo -e "        Valid O Levels are"
        echo -e "        1 (Os) or 3 (O3)"
        echo -e "    -v  Verbose build output"
	echo -e ""
	echo -e ${txtbld}"  Example:"${txtrst}
	echo -e "    ./build-fusion.sh -c mako"
	echo -e ""
	exit 1
}

# colors
. ./vendor/fusion/tools/colors

if [ ! -d ".repo" ]; then
	echo -e ${red}"No .repo directory found.  Is this an Android build tree?"${txtrst}
	exit 1
fi
if [ ! -d "vendor/fusion" ]; then
	echo -e ${red}"No vendor/fusion directory found.  Is this a FUSION build tree?"${txtrst}
	exit 1
fi

# figure out the output directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
thisDIR="${PWD##*/}"

findOUT() {
if [ -n "${OUT_DIR_COMMON_BASE+x}" ]; then
return 1; else
return 0
fi;}

findOUT
RES="$?"

if [ $RES = 1 ];then
    export OUTDIR=$OUT_DIR_COMMON_BASE/$thisDIR
    echo -e ""
    echo -e ${cya}"External out DIR is set ($OUTDIR)"${txtrst}
    echo -e ""
elif [ $RES = 0 ];then
    export OUTDIR=$DIR/out
    echo -e ""
    echo -e ${cya}"No External out, using default ($OUTDIR)"${txtrst}
    echo -e ""
else
    echo -e ""
    echo -e ${red}"NULL"${txtrst}
    echo -e ${red}"Error wrong results; blame tyler"${txtrst}
    echo -e ""
fi

# get OS (linux / Mac OS x)
IS_DARWIN=$(uname -a | grep Darwin)
if [ -n "$IS_DARWIN" ]; then
	CPUS=$(sysctl hw.ncpu | awk '{print $2}')
	DATE=gdate
else
	CPUS=$(grep "^processor" /proc/cpuinfo | wc -l)
	DATE=date
fi

export USE_CCACHE=1

opt_clean=0
opt_dex=0
opt_initlogo=0
opt_jobs="$CPUS"
opt_sync=0
opt_pipe=0
opt_olvl=0
opt_verbose=0

while getopts "cdfij:pso:v" opt; do
	case "$opt" in
	c) opt_clean=1 ;;
	d) opt_dex=1 ;;
	i) opt_initlogo=1 ;;
	j) opt_jobs="$OPTARG" ;;
	s) opt_sync=1 ;;
	p) opt_pipe=1 ;;
        o) opt_olvl="$OPTARG" ;;
        v) opt_verbose=1 ;;
	*) usage
	esac
done
shift $((OPTIND-1))
if [ "$#" -ne 1 ]; then
	usage
fi
device="$1"

# get current version
eval $(grep "^FUSION_VERSION_" vendor/fusion/config/fusion_common.mk | sed 's/ *//g')
VERSION="$FUSION_VERSION_MAJOR.$FUSION_VERSION_MINOR.$FUSION_VERSION_MAINTENANCE"

echo -e ${cya}"Building ${bldgrn}F ${bldppl}U ${bldblu}S ${bldgrn}I ${bldppl}O ${bldblu}N ${bldylw}v$VERSION"${txtrst}

# FUSION device dependencies
echo -e ""
echo -e ${bldblu}"Looking for FUSION product dependencies${txtrst}"${cya}
vendor/fusion/tools/getdependencies.py "$device"
echo -e "${txtrst}"

if [ "$opt_clean" -ne 0 ]; then
	make clean >/dev/null
fi

# download prebuilt files
if [ -x "vendor/cm/get-prebuilts" -a ! -d "vendor/cm/proprietary" ]; then
	echo -e ""
	echo -e ${bldblu}"Downloading prebuilts"${txtrst}
	vendor/cm/get-prebuilts
	echo -e ""
fi

# sync with latest sources
if [ "$opt_sync" -ne 0 ]; then
	echo -e ""
	echo -e ${bldblu}"Fetching latest sources"${txtrst}
	repo sync -j"$opt_jobs"
	echo -e ""
fi

rm -f $OUTDIR/target/product/$device/obj/KERNEL_OBJ/.version

# get time of startup
t1=$($DATE +%s)

# setup environment
echo -e ${bldblu}"Setting up environment"${txtrst}
. build/envsetup.sh

# Remove system folder (this will create a new build.prop with updated build time and date)
rm -f $OUTDIR/target/product/$device/system/build.prop
rm -f $OUTDIR/target/product/$device/system/app/*.odex
rm -f $OUTDIR/target/product/$device/system/framework/*.odex

# initlogo
if [ "$opt_initlogo" -ne 0 ]; then
	export BUILD_WITH_STATIC_INITLOGO=true
fi

# lunch device
echo -e ""
echo -e ${bldblu}"Lunching device"${txtrst}
lunch "fusion_$device-userdebug";

echo -e ""
echo -e ${bldblu}"Starting compilation"${txtrst}

# start compilation
if [ "$opt_dex" -ne 0 ]; then
	export WITH_DEXPREOPT=true
fi

if [ "$opt_pipe" -ne 0 ]; then
	export TARGET_USE_PIPE=true
fi

if [ "$opt_olvl" -eq 1 ]; then
    export TARGET_USE_O_LEVEL_S=true
    echo -e ""
    echo -e ${bldgrn}"Using Os Optimization"${txtrst}
    echo -e ""
elif [ "$opt_olvl" -eq 3 ]; then
    export TARGET_USE_O_LEVEL_3=true
    echo -e ""
    echo -e ${bldgrn}"Using O3 Optimization"${txtrst}
    echo -e ""
else
    echo -e ""
    echo -e ${bldgrn}"Using the default GCC Optimization Level, O2"${txtrst}
    echo -e ""
fi

if [ "$opt_verbose" -ne 0 ]; then
make -j"$opt_jobs" showcommands bacon
else
make -j"$opt_jobs" bacon
fi
echo -e ""

# squisher
vendor/fusion/tools/squisher

# cleanup unused built
rm -f $OUTDIR/target/product/$device/cm-*.*
rm -f $OUTDIR/target/product/$device/fusion_*-ota*.zip

# finished? get elapsed time
t2=$($DATE +%s)

tmin=$(( (t2-t1)/60 ))
tsec=$(( (t2-t1)%60 ))

echo -e ${bldgrn}"Total time elapsed:${txtrst} ${grn}$tmin minutes $tsec seconds"${txtrst}