/*++

Copyright (c) 2014 Minoca Corp. All Rights Reserved

Module Name:

    AM335x CPSW Ethernet Controller

Abstract:

    This module implements the TI CPSW Ethernet Controller driver found on
    TI AM335x devices

Author:

    Evan Green 20-Mar-2015

Environment:

    Kernel

--*/

function build() {
    name = "am3eth";
    sources = [
        "am3eth.c",
        "am3ethhw.c"
    ];

    dynlibs = [
        "//drivers/net/netcore:netcore"
    ];

    drv = {
        "label": name,
        "inputs": sources + dynlibs,
    };

    entries = driver(drv);
    return entries;
}

return build();
