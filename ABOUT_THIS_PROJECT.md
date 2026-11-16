# Project Handoff: `minsktoo` Overlay (Gentoo `arm64` for Motorola `minsk`)

## 1. Repository & Versioned Binhost Layout
- **Overlay Location:** `/var/db/repos/minsktoo` (registered in `/etc/portage/repos.conf/minsktoo.conf`).
- **Cross-Compile Target:** `aarch64-unknown-linux-gnu` via `sys-devel/crossdev` on the x86_64 desktop binhost.
- **Versioned Binhost Directory:** `/var/cache/binpkgs/minsktoo/0.1.0`.

## 2. Planned Reverse-Engineering & Kernel Porting Pipeline
1. **Extract Stock Boot & Firmware Artifacts:**
   - Pull `boot.img`, `dtbo.img`, `vendor_boot.img`, and `/vendor/firmware` + `/modem` blobs from `minsk`.
   - Run `unpack_bootimg`, `extract-ikconfig`, and `extract-dtb` + `dtc -I dtb -O dts` to recover the stock `.config`, `BOARD_KERNEL_CMDLINE`, and Device Tree (`DTS`).
2. **Modular Kernel Patch Set (`sys-kernel/gentoo-sources` or `sys-kernel/minsk-sources`):**
   - Clone Motorola's published GPL kernel source tree for `minsk` and match its exact `VERSION.PATCHLEVEL.SUBLEVEL` base tag.
   - Slice the diff into modular subsystem patches (`arch/arm64/boot/dts/qcom`, display panel, touchscreen, power/battery, WLAN/audio `techpack`) under `/etc/portage/patches/sys-kernel/gentoo-sources/`.
   - Apply a Gentoo kernel config fragment (`CONFIG_DEVTMPFS=y`, `CONFIG_CGROUPS=y`, `CONFIG_NAMESPACES=y`, `CONFIG_ANDROID_PARANOID_NETWORK=n`).
3. **Pack Bootable Rootfs & `boot.img`:**
   - Cross-build a lean `arm64` Gentoo userspace (`Phosh`, `Plasma Mobile`, or `Sway`) into `/var/cache/binpkgs/minsktoo/0.1.0` and pack `boot.img` with `mkbootimg` using the extracted offsets and cmdline.

## 3. Sequencing Note
- Scheduled for **Phase 3** after Phase 1 (desktop `WakStab` `wakstab-emptytree` completion + `/etc/portage/env` tuning + `ABI_X86` trim) and Phase 2 (`fragtoo` Steam Deck LCD `0.1.0` build).
