################################################################################
## Inheriting configs from ACK
. ${ROOT_DIR}/common/build.config.common
. ${ROOT_DIR}/common/build.config.aarch64

################################################################################
## Variant setup
MSM_ARCH=parrot
VARIANTS=(consolidate gki)
[ -z "${VARIANT}" ] && VARIANT=consolidate

if [ -e "${ROOT_DIR}/msm-kernel" -a "${KERNEL_DIR}" = "common" ]; then
	KERNEL_DIR="msm-kernel"
fi

BOOT_IMAGE_HEADER_VERSION=3
BASE_ADDRESS=0x80000000
PAGE_SIZE=4096
BUILD_VENDOR_DLKM=1
#ifdef USING_ODM_DLKM
BUILD_ODM_DLKM=1
#endif USING_ODM_DLKM
SUPER_IMAGE_SIZE=0x10000000
TRIM_UNUSED_MODULES=1

MODULES_LIST_ORDER="1"
[ -z "${DT_OVERLAY_SUPPORT}" ] && DT_OVERLAY_SUPPORT=1

if [ "${KERNEL_CMDLINE_CONSOLE_AUTO}" != "0" ]; then
	KERNEL_VENDOR_CMDLINE+=' console=ttyMSM0,115200n8 earlycon msm_geni_serial.con_enabled=1'
fi

################################################################################
## Inheriting MSM configs
. ${KERNEL_DIR}/build.config.msm.common
. ${KERNEL_DIR}/build.config.msm.gki
set -x
if [ -f "${ROOT_DIR}/oplus/config/build.config.msm.wapio.oplus" ]; then
  echo "  set  ${ROOT_DIR}/oplus/config/build.config.msm.wapio.oplus build script"
. ${ROOT_DIR}/oplus/config/build.config.msm.wapio.oplus
fi

#ifdef USING_ODM_DLKM
if [ -f "${ROOT_DIR}/oplus/config/modules.list.oplus" ]; then
	ODM_MODULES_LIST=${ROOT_DIR}/oplus/config/modules.list.oplus
fi
#endif USING_ODM_DLKM

# disable KMI symbol list and white list test in aging mode
if [ -n "${AGING_DEBUG_MASK}" ]; then
  echo " Detect aging mode, AGING_DEBUG_MASK is ${AGING_DEBUG_MASK}"
  GKI_TRIM_NONLISTED_KMI=0
  GKI_KMI_SYMBOL_LIST_STRICT_MODE=0
fi

set +x
