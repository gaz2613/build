# advanced_patch
# process_patch_file
	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} ${CROSS_COMPILE}gcc --version | head -1 | tee -a $DEST/debug/install.log
	echo
	local cthreads=$CTHREADS
	[[ $LINUXFAMILY == "marvell" ]] && local MAKEPARA="u-boot.mmc"
	[[ $BOARD == "odroidc2" ]] && local MAKEPARA="ARCH=arm" && local cthreads=""
	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} 'make $CTHREADS $BOOTCONFIG CROSS_COMPILE="$CROSS_COMPILE"' 2>&1 \
		${PROGRESS_LOG_TO_FILE:+' | tee -a $DEST/debug/compilation.log'} \
		${OUTPUT_VERYSILENT:+' >/dev/null 2>/dev/null'}
	[ -f .config ] && sed -i 's/CONFIG_LOCALVERSION=""/CONFIG_LOCALVERSION="-armbian"/g' .config
	[ -f .config ] && sed -i 's/CONFIG_LOCALVERSION_AUTO=.*/# CONFIG_LOCALVERSION_AUTO is not set/g' .config
	[ -f $SOURCES/$BOOTSOURCEDIR/tools/logos/udoo.bmp ] && cp $SRC/lib/bin/armbian-u-boot.bmp $SOURCES/$BOOTSOURCEDIR/tools/logos/udoo.bmp
	touch .scmversion
	
	# patch mainline uboot configuration to boot with old kernels
	if [[ $BRANCH == "default" && $LINUXFAMILY == sun*i ]] ; then
		if [ "$(cat $SOURCES/$BOOTSOURCEDIR/.config | grep CONFIG_ARMV7_BOOT_SEC_DEFAULT=y)" == "" ]; then
			echo "CONFIG_ARMV7_BOOT_SEC_DEFAULT=y" >> $SOURCES/$BOOTSOURCEDIR/.config
			echo "CONFIG_OLD_SUNXI_KERNEL_COMPAT=y" >> $SOURCES/$BOOTSOURCEDIR/.config
	fi
	eval ${UBOOT_TOOLCHAIN:+env PATH=$UBOOT_TOOLCHAIN:$PATH} 'make $MAKEPARA $cthreads CROSS_COMPILE="$CROSS_COMPILE"' 2>&1 \
	local uboot_name=${CHOSEN_UBOOT}_${REVISION}_${ARCH}
if [[ \$DEVICE == "/dev/null" ]]; then exit 0; fi
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=1 count=442 conv=fsync ) > /dev/null 2>&1	
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1	
elif [[ \$DPKG_MAINTSCRIPT_PACKAGE == *odroidc2* ]] ; then
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=1 count=442 conv=fsync ) > /dev/null 2>&1
	( dd if=/usr/lib/$uboot_name/bl1.bin.hardkernel of=\$DEVICE bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1
	( dd if=/usr/lib/$uboot_name/u-boot.bin of=\$DEVICE bs=512 seek=97 conv=fsync ) > /dev/null 2>&1
	( dd if=/dev/zero of=\$DEVICE seek=1249 count=799 bs=512 conv=fsync ) > /dev/null 2>&1 
	( dd if=/dev/zero of=\$DEVICE bs=1k count=1023 seek=1 status=noxfer ) > /dev/null 2>&1
Architecture: $ARCH
		[ ! -f "sd_fuse/u-boot.bin" ] || cp sd_fuse/u-boot.bin $DEST/debs/$uboot_name/usr/lib/$uboot_name
	elif [[ $BOARD == odroidc2 ]] ; then
		[ ! -f "sd_fuse/bl1.bin.hardkernel" ] || cp sd_fuse/bl1.bin.hardkernel $DEST/debs/$uboot_name/usr/lib/$uboot_name		
		[ ! -f "sd_fuse/u-boot.bin" ] || cp sd_fuse/u-boot.bin $DEST/debs/$uboot_name/usr/lib/$uboot_name
	# NOTE: Fix CC=$CROSS_COMPILE"gcc" before reenabling
	# make $CTHREADS 'sunxi-nand-part' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	# make $CTHREADS 'sunxi-fexc' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	# make $CTHREADS 'meminfo' CC=$CROSS_COMPILE"gcc" >> $DEST/debug/install.log 2>&1
	grab_version "$SOURCES/$LINUXSOURCEDIR" "VER"
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} ${CROSS_COMPILE}gcc --version | head -1 | tee -a $DEST/debug/install.log
	echo
	
	if [[ $ARCH == *64* ]]; then ARCHITECTURE=arm64; else ARCHITECTURE=arm; fi
			eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" silentoldconfig'
			eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" olddefconfig'
		eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" oldconfig'
		eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" menuconfig'
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make $CTHREADS ARCH=$ARCHITECTURE CROSS_COMPILE="$CROSS_COMPILE" $TARGETS modules dtbs 2>&1' \
	if [ ${PIPESTATUS[0]} -ne 0 ] || [ ! -f arch/$ARCHITECTURE/boot/$TARGETS ]; then
	# produce deb packages: image, headers, firmware, dtb
	eval ${KERNEL_TOOLCHAIN:+env PATH=$KERNEL_TOOLCHAIN:$PATH} 'make -j1 $KERNEL_PACKING KDEB_PKGVERSION=$REVISION LOCALVERSION="-"$LINUXFAMILY \
		KBUILD_DEBARCH=$ARCH ARCH=$ARCHITECTURE DEBFULLNAME="$MAINTAINER" DEBEMAIL="$MAINTAINERMAIL" CROSS_COMPILE="$CROSS_COMPILE" 2>&1 ' \
# advanced_patch <dest> <family> <device> <description>
#
# parameters:
# <dest>: u-boot, kernel
# <family>: u-boot: u-boot, u-boot-neo; kernel: sun4i-default, sunxi-next, ...
# <device>: cubieboard, cubieboard2, cubietruck, ...
# <description>: additional description text
#
# priority:
# $SRC/userpatches/<dest>/<family>/<device>
# $SRC/userpatches/<dest>/<family>
# $SRC/lib/patch/<dest>/<family>/<device>
# $SRC/lib/patch/<dest>/<family>
#
advanced_patch () {

	local dest=$1
	local family=$2
	local device=$3
	local description=$4

	display_alert "Started patching process for" "$dest $description" "info"
	display_alert "Looking for user patches in" "userpatches/$dest/$family" "info"

	local names=()
	local dirs=("$SRC/userpatches/$dest/$family/$device" "$SRC/userpatches/$dest/$family" "$SRC/lib/patch/$dest/$family/$device" "$SRC/lib/patch/$dest/$family")

	# required for "for" command
	shopt -s nullglob dotglob
	# get patch file names
	for dir in "${dirs[@]}"; do
		for patch in $dir/*.patch; do
			names+=($(basename $patch))
		done
	done
	# remove duplicates
	local names_s=($(echo "${names[@]}" | tr ' ' '\n' | LC_ALL=C sort -u | tr '\n' ' '))
	# apply patches
	for name in "${names_s[@]}"; do
		for dir in "${dirs[@]}"; do
			if [[ -f $dir/$name || -L $dir/$name ]]; then
				if [[ -s $dir/$name ]]; then
					process_patch_file "$dir/$name" "$description"
				else
					display_alert "... $name" "skipped" "info"
				fi
				break # next name
			fi
		done
	done
}

# process_patch_file <file> <description>
#
# parameters:
# <file>: path to patch file
# <description>: additional description text
#
process_patch_file() {

	local patch=$1
	local description=$2

	# detect and remove files which patch will create
	LANGUAGE=english patch --batch --dry-run -p1 -N < $patch | grep create \
		| awk '{print $NF}' | sed -n 's/,//p' | xargs -I % sh -c 'rm %'

	# main patch command
	echo "$patch $description" >> $DEST/debug/install.log
	patch --batch --silent -p1 -N < $patch >> $DEST/debug/install.log 2>&1

	if [ $? -ne 0 ]; then
		display_alert "... $(basename $patch)" "failed" "wrn";
		if [[ $EXIT_PATCHING_ERROR == "yes" ]]; then exit_with_error "Aborting due to" "EXIT_PATCHING_ERROR"; fi
	else
		display_alert "... $(basename $patch)" "succeeded" "info"
	fi
}
install_external_applications ()
{
display_alert "Installing extra applications and drivers" "" "info"

# cleanup for install_kernel and install_board_specific
umount $CACHEDIR/sdcard/tmp >/dev/null 2>&1
for plugin in $SRC/lib/extras/*.sh; do
	source $plugin
done
	make clean >/dev/null
	make ARCH=$ARCHITECTURE CC="${CROSS_COMPILE}gcc" KSRC="$SOURCES/$LINUXSOURCEDIR/" >> $DEST/debug/compilation.log 2>&1

	make ARCH=$ARCHITECTURE CC="${CROSS_COMPILE}gcc" KSRC="$SOURCES/$LINUXSOURCEDIR/" >> $DEST/debug/compilation.log 2>&1
# h3disp/sun8i-corekeeper.sh for sun8i/3.4.x
if [ "${LINUXFAMILY}" = "sun8i" -a "${BRANCH}" = "default" ]; then
	install -m 755 "$SRC/lib/scripts/sun8i-corekeeper.sh" "$CACHEDIR/sdcard/usr/local/bin"
	sed -i 's|^exit\ 0$|/usr/local/bin/sun8i-corekeeper.sh \&\n\n&|' "$CACHEDIR/sdcard/etc/rc.local"
	dpkg -x ${DEST}/debs/${CHOSEN_UBOOT}_${REVISION}_${ARCH}.deb /tmp/
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/SPL of=$LOOP bs=512 seek=2 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.img of=$LOOP bs=1K seek=42 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.mmc of=$LOOP bs=512 seek=1 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/SPL of=$LOOP bs=1k seek=1 status=noxfer >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.img of=$LOOP bs=1k seek=69 conv=fsync >/dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bootloader.bin of=$LOOP bs=512 seek=4097 conv=fsync > /dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot-dtb.bin of=$LOOP bs=512 seek=6144 conv=fsync > /dev/null 2>&1)
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP seek=1 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl2.bin.hardkernel of=$LOOP seek=31 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=63 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/tzsw.bin.hardkernel of=$LOOP seek=719 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=1 count=442 conv=fsync ) > /dev/null 2>&1	
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1	
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=64 conv=fsync ) > /dev/null 2>&1	
		( dd if=/dev/zero of=$LOOP seek=1024 count=32 bs=512 conv=fsync ) > /dev/null 2>&1
	elif [[ $BOARD == *odroidc2* ]] ; then
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=1 count=442 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/bl1.bin.hardkernel of=$LOOP bs=512 skip=1 seek=1 conv=fsync ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot.bin of=$LOOP bs=512 seek=97 conv=fsync ) > /dev/null 2>&1
		( dd if=/dev/zero of=$LOOP seek=1249 count=799 bs=512 conv=fsync ) > /dev/null 2>&1
		( dd if=/dev/zero of=$LOOP bs=1k count=1023 seek=1 status=noxfer ) > /dev/null 2>&1
		( dd if=/tmp/usr/lib/${CHOSEN_UBOOT}_${REVISION}_${ARCH}/u-boot-sunxi-with-spl.bin of=$LOOP bs=1024 seek=8 status=noxfer >/dev/null 2>&1)