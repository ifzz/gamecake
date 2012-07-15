cd `dirname $0`
build/premake4 gmake
cd build-gmake

if [ "$1" == "release" ] ; then
	make config=release
elif [ "$1" == "clean" ] ; then
	cd ..
	rm -Rf build-gmake
else
	make $*
fi

cd ..

