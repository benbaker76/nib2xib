#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
rm -R "./Temp"
rm -R "./Compiled Nib Opener"
mkdir "./Temp"

for f in *.nib;
do
	# ===========================================================================
	# *** Replace NSIBUserDefinedRuntimeAttributesConnector with NSIBObjectData ***
	#
	# NOTE: Fixes error "NSIBUserDefinedRuntimeAttributesConnector connections are not supported by Interface Builder 3.0."
	#
	# sed -i '' 's/NSIBUserDefinedRuntimeAttributesConnector/NSIBObjectData/g'
	# ===========================================================================
	sed -i '' 's/NSIBUserDefinedRuntimeAttributesConnector/NSIBObjectData/g' ./$f

	# ===========================================================================
	# *** Convert xml plist to binary plist ***
	#
	# plutil -convert binary1 MyFile.nib
	# ===========================================================================
	plutil -convert binary1 ./$f

	# ===========================================================================
	# *** Unzip Compiled Nib Opener.zip ***
	#
	# unzip -o Compiled Nib Opener -d Output Path
	# ===========================================================================
	unzip -o "./Compiled Nib Opener.zip" -d .

	# ===========================================================================
	# *** Delete Compiled Nib Opener/keyedobjects.nib ***
	# ===========================================================================
	rm "./Compiled Nib Opener/keyedobjects.nib"

	# ===========================================================================
	# *** Copy MyFile.nib to Compiled Nib Opener/keyedobjects.nib ***
	# ===========================================================================
	cp $f "./Compiled Nib Opener/keyedobjects.nib"
	
	# ===========================================================================
	# *** Move Compiled Nib Opener to MyFile.nib ***
	# ===========================================================================
	mv "./Compiled Nib Opener" ./Temp/$f

	# ===========================================================================
	# *** NIB to XIB ***
	#
	# ibtool MyFile.nib --upgrade --write new MyFile.xib
	# ===========================================================================
	ibtool ./Temp/$f --upgrade --write "./${f%%.*}.xib"
	chown -R $(whoami) "./${f%%.*}.xib"
done
