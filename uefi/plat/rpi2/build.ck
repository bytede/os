/*++

Copyright (c) 2015 Minoca Corp. All Rights Reserved

Module Name:

    Raspberry Pi 2 UEFI Firmware

Abstract:

    This module implements UEFI firmware for the Raspberry Pi 2.

Author:

    Chris Stevens 19-Mar-2015

Environment:

    Firmware

--*/

function build() {
    plat = "rpi2";
    text_address = "0x00008000";
    sources = [
        "armv7/entry.S",
        "armv7/smpa.S",
        "debug.c",
        "fwvol.c",
        "intr.c",
        "main.c",
        "memmap.c",
        "ramdenum.c",
        ":" + plat + "fwv.o",
        "smbios.c",
        "smp.c",
        "timer.c",
    ];

    //
    // TODO: Figure out the build date and revision.
    //

    fw_cppflags = [
        "-I$///uefi/include",
        "-DFIRMWARE_BUILD_DATE=\\\"01/01/2016\\\"",
        "-DFIRMWARE_VERSION_MAJOR=1",
        "-DFIRMWARE_VERSION_MINOR=0",
        "-DFIRMWARE_VERSION_STRING=\\\"1.0.0\\\""
    ];

    sources_config = {
        "CFLAGS": ["$CFLAGS", "-fshort-wchar"],
        "CPPFLAGS": ["$CPPFLAGS"] + fw_cppflags
    };

    link_ldflags = [
        "-nostdlib",
        "-Wl,--no-wchar-size-warning",
        "-static"
    ];

    link_config = {
        "LDFLAGS": ["$LDFLAGS"] + link_ldflags
    };

    common_libs = [
        "//uefi/core:ueficore",
        "//kernel/kd:kdboot",
        "//uefi/core:ueficore",
        "//uefi/archlib:uefiarch",
        "//lib/fatlib:fat",
        "//lib/basevid:basevid",
        "//lib/rtl/kmode:krtl",
        "//lib/rtl/base:basertlb",
        "//kernel/kd/kdusb:kdnousb",
        "//kernel:archboot",
        "//uefi/core:emptyrd",
    ];

    libs = [
        "//uefi/dev/pl11:pl11",
        "//uefi/dev/bcm2709:bcm2709",
        "//uefi/dev/sd/core:sd",
    ];

    libs += common_libs;
    platfw = plat + "fw";
    elf = {
        "label": platfw + ".elf",
        "inputs": sources + libs,
        "sources_config": sources_config,
        "config": link_config
    };

    entries = executable(elf);

    //
    // Build the firmware volume.
    //

    ffs = [
        "//uefi/core/runtime:rtbase.ffs",
        "//uefi/plat/" + plat + "/runtime:" + plat + "rt.ffs",
        "//uefi/plat/" + plat + "/acpi:acpi.ffs"
    ];

    fw_volume = uefi_fwvol_o(plat, ffs);
    entries += fw_volume;

    //
    // Flatten the firmware image.
    //

    flattened = {
        "label": platfw,
        "inputs": [":" + platfw + ".elf"]
    };

    flattened = flattened_binary(flattened);
    entries += flattened;
    return entries;
}

return build();
