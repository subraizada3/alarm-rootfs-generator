Kernel 5.16, from February 2022, does not boot.

Revert to kernel 5.15.5, from December 2021.
Downloaded from http://tardis.tiny-vps.com/aarm/packages/l/linux-aarch64/

The C4 / HC4 PCBs don't expose the JTAG pins. However, it should be possible to bisect to the commit which causes the issue.

Log of failed boot on 5.16:

```
Starting kernel ...

uboot time: 15800745 us
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x411fd050]
[    0.000000] Linux version 5.16.10-1-aarch64-ARCH (builduser@leming) (aarch64-unknown-linux-gnu-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.38) #1 SMP Wed Feb 16 16:24:17 UTC 2022
[    0.000000] Machine model: Hardkernel ODROID-HC4
[    0.000000] efi: UEFI not found.
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000dd800000, size 256 MiB
[    0.000000] OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x00000000ed7fffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000004ffffff]
[    0.000000]   node   0: [mem 0x0000000005000000-0x00000000052fffff]
[    0.000000]   node   0: [mem 0x0000000005300000-0x00000000ed7fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000000ed7fffff]
[    0.000000] On node 0, zone DMA: 10240 pages in unavailable ranges
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.0 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] percpu: Embedded 20 pages/cpu s44568 r8192 d29160 u81920
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: Virtualization Host Extensions
[    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or 1530923
[    0.000000] alternatives: patching kernel code
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 957600
[    0.000000] Kernel command line: root=/dev/mmcblk0p2 rw rootwait console=ttyAML0,115200n8 console=tty1 no_console_suspend fsck.repair=yes
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 3502172K/3891200K available (19648K kernel code, 3938K rwdata, 9712K rodata, 6336K init, 865K bss, 126884K reserved, 262144K cma-reserved)
[    0.000000] random: get_random_u64 called from cache_random_seq_create+0x84/0x184 with crng_init=0
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:   RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000]  Rude variant of Tasks RCU enabled.
[    0.000000]  Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] arch_timer: cp15 timer(s) running at 24.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x588fe9dc0, max_idle_ns: 440795202592 ns
[    0.000000] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 4398046511097ns
[    0.000318] Console: colour dummy device 80x25
[    0.000586] printk: console [tty1] enabled
[    0.000628] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=24000)
[    0.000649] pid_max: default: 32768 minimum: 301
[    0.000733] LSM: Security Framework initializing
[    0.000756] Yama: becoming mindful.
[    0.000849] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.000907] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.002594] rcu: Hierarchical SRCU implementation.
[    0.006058] EFI services will not be available.
[    0.006596] smp: Bringing up secondary CPUs ...
[    0.007419] Detected VIPT I-cache on CPU1
[    0.007478] CPU1: Booted secondary processor 0x0000000100 [0x411fd050]
[    0.008338] Detected VIPT I-cache on CPU2
[    0.008382] CPU2: Booted secondary processor 0x0000000200 [0x411fd050]
[    0.009233] Detected VIPT I-cache on CPU3
[    0.009271] CPU3: Booted secondary processor 0x0000000300 [0x411fd050]
[    0.009352] smp: Brought up 1 node, 4 CPUs
[    0.009404] SMP: Total of 4 processors activated.
[    0.009415] CPU features: detected: 32-bit EL0 Support
[    0.009423] CPU features: detected: 32-bit EL1 Support
[    0.009432] CPU features: detected: Data cache clean to the PoU not required for I/D coherence
[    0.009443] CPU features: detected: Common not Private translations
[    0.009452] CPU features: detected: CRC32 instructions
[    0.009461] CPU features: detected: RCpc load-acquire (LDAPR)
[    0.009470] CPU features: detected: LSE atomic instructions
[    0.009478] CPU features: detected: Privileged Access Never
[    0.009485] CPU features: detected: RAS Extension Support
[    0.040455] CPU: All CPU(s) started at EL2
[    0.042829] devtmpfs: initialized
[    0.052974] Registered cp15_barrier emulation handler
[    0.053005] Registered setend emulation handler
[    0.053170] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.053198] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.058008] pinctrl core: initialized pinctrl subsystem
[    0.058851] DMI not present or invalid.
[    0.059280] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.060596] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.060796] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.061018] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.061102] audit: initializing netlink subsys (disabled)
[    0.061271] audit: type=2000 audit(0.059:1): state=initialized audit_enabled=0 res=1
[    0.062434] thermal_sys: Registered thermal governor 'fair_share'
[    0.062442] thermal_sys: Registered thermal governor 'bang_bang'
[    0.062457] thermal_sys: Registered thermal governor 'step_wise'
[    0.062467] thermal_sys: Registered thermal governor 'user_space'
[    0.062476] thermal_sys: Registered thermal governor 'power_allocator'
[    0.062967] cpuidle: using governor ladder
[    0.063004] cpuidle: using governor menu
[    0.063223] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.063349] ASID allocator initialised with 65536 entries
[    0.064951] Serial: AMBA PL011 UART driver
[    0.081816] platform ff900000.vpu: Fixing up cyclic dependency with ff600000.hdmi-tx
[    0.090086] platform hdmi-connector: Fixing up cyclic dependency with ff600000.hdmi-tx
[    0.100266] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.100295] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.100307] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.100317] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    0.100758] cryptd: max_cpu_qlen set to 1000
[    0.117982] raid6: neonx8   gen()  2112 MB/s
[    0.135030] raid6: neonx8   xor()  1633 MB/s
[    0.152084] raid6: neonx4   gen()  2167 MB/s
[    0.169137] raid6: neonx4   xor()  1619 MB/s
[    0.186192] raid6: neonx2   gen()  2046 MB/s
[    0.203239] raid6: neonx2   xor()  1478 MB/s
[    0.220299] raid6: neonx1   gen()  1710 MB/s
[    0.237345] raid6: neonx1   xor()  1191 MB/s
[    0.254405] raid6: int64x8  gen()  1335 MB/s
[    0.271449] raid6: int64x8  xor()   763 MB/s
[    0.288502] raid6: int64x4  gen()  1576 MB/s
[    0.305554] raid6: int64x4  xor()   847 MB/s
[    0.322607] raid6: int64x2  gen()  1419 MB/s
[    0.339653] raid6: int64x2  xor()   726 MB/s
[    0.356720] raid6: int64x1  gen()  1060 MB/s
[    0.373782] raid6: int64x1  xor()   496 MB/s
[    0.373792] raid6: using algorithm neonx4 gen() 2167 MB/s
[    0.373801] raid6: .... xor() 1619 MB/s, rmw enabled
[    0.373810] raid6: using neon recovery algorithm
[    0.374492] ACPI: Interpreter disabled.
[    0.377491] iommu: Default domain type: Translated
[    0.377512] iommu: DMA domain TLB invalidation policy: strict mode
[    0.377809] vgaarb: loaded
[    0.378481] SCSI subsystem initialized
[    0.378817] usbcore: registered new interface driver usbfs
[    0.378864] usbcore: registered new interface driver hub
[    0.378899] usbcore: registered new device driver usb
[    0.379483] pps_core: LinuxPPS API ver. 1 registered
[    0.379496] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.379518] PTP clock support registered
[    0.379684] EDAC MC: Ver: 3.0.0
[    0.381013] Advanced Linux Sound Architecture Driver Initialized.
[    0.381549] NetLabel: Initializing
[    0.381562] NetLabel:  domain hash size = 128
[    0.381571] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.381624] NetLabel:  unlabeled traffic allowed by default
[    0.381976] clocksource: Switched to clocksource arch_sys_counter
[    0.382174] VFS: Disk quotas dquot_6.6.0
[    0.382225] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.382642] pnp: PnP ACPI: disabled
[    0.389312] NET: Registered PF_INET protocol family
[    0.389533] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.391486] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    0.391548] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.391736] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    0.392082] TCP: Hash tables configured (established 32768 bind 32768)
[    0.392290] MPTCP token hash table entries: 4096 (order: 4, 98304 bytes, linear)
[    0.392377] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.392442] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    0.392637] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.393129] RPC: Registered named UNIX socket transport module.
[    0.393144] RPC: Registered udp transport module.
[    0.393153] RPC: Registered tcp transport module.
[    0.393161] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.393175] PCI: CLS 0 bytes, default 64
[    0.393522] Trying to unpack rootfs image as initramfs...
[    0.393910] kvm [1]: IPA Size Limit: 40 bits
[    0.400188] kvm [1]: vgic interrupt IRQ9
[    0.400826] kvm [1]: VHE mode initialized successfully
[    0.402410] Initialise system trusted keyrings
[    0.402626] workingset: timestamp_bits=46 max_order=20 bucket_order=0
[    0.407263] zbud: loaded
[    0.409067] NFS: Registering the id_resolver key type
[    0.409107] Key type id_resolver registered
[    0.409118] Key type id_legacy registered
[    0.409196] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.409216] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    0.409242] ntfs3: Max link count 4000
[    0.409252] ntfs3: Read-only LZX/Xpress compression included
[    0.409470] SGI XFS with ACLs, security attributes, quota, no debug enabled
[    0.448140] NET: Registered PF_ALG protocol family
[    0.448183] xor: measuring software checksum speed
[    0.452521]    8regs           :  2288 MB/sec
[    0.456070]    32regs          :  2795 MB/sec
[    0.460005]    arm64_neon      :  2518 MB/sec
[    0.460023] xor: using function: 32regs (2795 MB/sec)
[    0.460042] Key type asymmetric registered
[    0.460053] Asymmetric key parser 'x509' registered
[    0.460242] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 242)
[    0.460438] io scheduler mq-deadline registered
[    0.460453] io scheduler kyber registered
[    0.460583] io scheduler bfq registered
[    0.463240] irq_meson_gpio: 100 to 8 gpio interrupt mux initialized
[    0.476807] IPMI message handler: version 39.2
[    0.493558] soc soc0: Amlogic Meson SM1 (S905X3) Revision 2b:c (10:2) Detected
[    0.499919] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.503143] ff803000.serial: ttyAML0 at MMIO 0xff803000 (irq = 22, base_baud = 1500000) is a meson_uart
[    0.640827] Freeing initrd memory: 7124K
[    0.644060] printk: console [ttyAML0] enabled
[    1.586735] msm_serial: driver initialized
[    1.604692] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.605631] ehci-pci: EHCI PCI platform driver
[    1.610036] ehci-platform: EHCI generic platform driver
[    1.615321] ehci-orion: EHCI orion driver
[    1.619253] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.625267] ohci-pci: OHCI PCI platform driver
[    1.629695] ohci-platform: OHCI generic platform driver
[    1.634958] uhci_hcd: USB Universal Host Controller Interface driver
[    1.641706] SPI driver max3421-hcd has no spi_device_id for maxim,max3421
[    1.648107] usbcore: registered new interface driver uas
[    1.653154] usbcore: registered new interface driver usb-storage
[    1.659093] usbcore: registered new interface driver ums-alauda
[    1.664955] usbcore: registered new interface driver ums-cypress
[    1.670916] usbcore: registered new interface driver ums-datafab
[    1.676858] usbcore: registered new interface driver ums_eneub6250
[    1.682989] usbcore: registered new interface driver ums-freecom
[    1.688931] usbcore: registered new interface driver ums-isd200
[    1.694797] usbcore: registered new interface driver ums-jumpshot
[    1.700835] usbcore: registered new interface driver ums-karma
[    1.706615] usbcore: registered new interface driver ums-onetouch
[    1.712669] usbcore: registered new interface driver ums-realtek
[    1.718603] usbcore: registered new interface driver ums-sddr09
[    1.724468] usbcore: registered new interface driver ums-sddr55
[    1.730332] usbcore: registered new interface driver ums-usbat
[    1.736148] usbcore: registered new interface driver usbserial_generic
[    1.742576] usbserial: USB Serial support registered for generic
[    1.750066] mousedev: PS/2 mouse device common for all mice
[    1.759661] device-mapper: uevent: version 1.0.3
[    1.759948] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22) initialised: dm-devel@redhat.com
[    1.772629] sdhci: Secure Digital Host Controller Interface driver
[    1.773193] sdhci: Copyright(c) Pierre Ossman
[    1.778138] Synopsys Designware Multimedia Card Interface Driver
[    1.784327] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.790532] ledtrig-cpu: registered to indicate activity on CPUs
[    1.795894] meson-sm: secure-monitor enabled
[    1.799723] hid: raw HID events driver (C) Jiri Kosina
[    1.804423] usbcore: registered new interface driver usbhid
[    1.809840] usbhid: USB HID core driver
[    1.815864] meson-saradc ff809000.adc: supply vref not found, using dummy regulator
[    1.825731] Initializing XFRM netlink socket
[    1.826092] NET: Registered PF_INET6 protocol family
[    1.848509] Segment Routing with IPv6
[    1.848582] In-situ OAM (IOAM) with IPv6
[    1.850493] mip6: Mobile IPv6
[    1.853381] NET: Registered PF_PACKET protocol family
[    1.858507] Key type dns_resolver registered
[    1.863115] registered taskstats version 1
[    1.866673] Loading compiled-in X.509 certificates
[    1.872015] zswap: loaded using pool lzo/zbud
[    1.876060] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[    1.885143] Key type ._fscrypt registered
[    1.888829] Key type .fscrypt registered
[    1.892708] Key type fscrypt-provisioning registered
[    1.898255] Btrfs loaded, crc32c=crc32c-generic, zoned=yes, fsverity=no
[    1.904626] Key type encrypted registered
[    2.575278] reg-fixed-voltage regulator-p12v_0: nonexclusive access to GPIO for regulator-p12v_0
[    2.578698] reg-fixed-voltage regulator-p12v_1: nonexclusive access to GPIO for regulator-p12v_1
[    2.658451] dwc3-meson-g12a ffe09000.usb: USB2 ports: 1
[    2.658497] dwc3-meson-g12a ffe09000.usb: USB3 ports: 0
[    2.665623] dwc2 ff400000.usb: supply vusb_d not found, using dummy regulator
[    2.670400] dwc2 ff400000.usb: supply vusb_a not found, using dummy regulator
[    2.677529] dwc2 ff400000.usb: EPs: 7, dedicated fifos, 712 entries in SPRAM
[    2.686133] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.689957] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 1
[    2.697517] xhci-hcd xhci-hcd.0.auto: hcc params 0x0228fe64 hci version 0x110 quirks 0x0000000000010010
[    2.706740] xhci-hcd xhci-hcd.0.auto: irq 35, io mem 0xff500000
[    2.712775] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.16
[    2.720761] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.727930] usb usb1: Product: xHCI Host Controller
[    2.732751] usb usb1: Manufacturer: Linux 5.16.10-1-aarch64-ARCH xhci-hcd
[    2.739476] usb usb1: SerialNumber: xhci-hcd.0.auto
[    2.744638] hub 1-0:1.0: USB hub found
[    2.748064] hub 1-0:1.0: 2 ports detected
[    2.752231] xhci-hcd xhci-hcd.0.auto: xHCI Host Controller
[    2.757517] xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 2
[    2.765017] xhci-hcd xhci-hcd.0.auto: Host supports USB 3.0 SuperSpeed
[    2.771516] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    2.779651] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.16
[    2.787697] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.794850] usb usb2: Product: xHCI Host Controller
[    2.799679] usb usb2: Manufacturer: Linux 5.16.10-1-aarch64-ARCH xhci-hcd
[    2.806406] usb usb2: SerialNumber: xhci-hcd.0.auto
[    2.811534] hub 2-0:1.0: USB hub found
[    2.814965] hub 2-0:1.0: 1 port detected
[    2.821812] dw-pcie fc000000.pcie: IRQ index 1 not found
[    2.821820] meson-gx-mmc ffe05000.sd: Got CD GPIO
[    2.831315] meson-pcie fc000000.pcie: host bridge /soc/pcie@fc000000 ranges:
[    2.835751] meson-pcie fc000000.pcie:       IO 0x00fc600000..0x00fc6fffff -> 0x0000000000
[    2.843851] meson-pcie fc000000.pcie:      MEM 0x00fc700000..0x00fdffffff -> 0x00fc700000
[    2.852024] meson-pcie fc000000.pcie: iATU unroll: enabled
[    2.857381] meson-pcie fc000000.pcie: Detected iATU regions: 4 outbound, 4 inbound
[    2.906238] meson-pcie fc000000.pcie: error: wait linkup timeout
[    2.911688] mmc0: new ultra high speed SDR104 SDHC card at address aaaa
[    2.913743] mmcblk0: mmc0:aaaa SC16G 14.8 GiB
[    2.922228]  mmcblk0: p1 p2
[    2.937014] meson-pcie fc000000.pcie: Link up
[    2.937151] meson-pcie fc000000.pcie: PCI host bridge to bus 0000:00
[    2.942056] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.947477] pci_bus 0000:00: root bus resource [io  0x0000-0xfffff]
[    2.953686] pci_bus 0000:00: root bus resource [mem 0xfc700000-0xfdffffff]
[    2.960521] pci 0000:00:00.0: [16c3:abcd] type 01 class 0x060400
[    2.966463] pci 0000:00:00.0: reg 0x38: [mem 0x00000000-0x0000ffff pref]
[    2.973125] pci 0000:00:00.0: supports D1
[    2.977060] pci 0000:00:00.0: PME# supported from D0 D1 D3hot D3cold
[    2.985919] pci 0000:01:00.0: [1b21:0611] type 00 class 0x010185
[    2.989357] pci 0000:01:00.0: reg 0x10: [io  0x0000-0x0007]
[    2.994845] pci 0000:01:00.0: reg 0x14: [io  0x0000-0x0003]
[    3.000376] pci 0000:01:00.0: reg 0x18: [io  0x0000-0x0007]
[    3.005885] pci 0000:01:00.0: reg 0x1c: [io  0x0000-0x0003]
[    3.011407] pci 0000:01:00.0: reg 0x20: [io  0x0000-0x000f]
[    3.016924] pci 0000:01:00.0: reg 0x24: [mem 0x00000000-0x000001ff]
[    3.023134] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    3.029782] pci 0000:01:00.0: Max Payload Size set to 256 (was 128, max 512)
[    3.042030] pci 0000:00:00.0: BAR 14: assigned [mem 0xfc700000-0xfc7fffff]
[    3.043564] pci 0000:00:00.0: BAR 15: assigned [mem 0xfc800000-0xfc8fffff pref]
[    3.050811] pci 0000:00:00.0: BAR 6: assigned [mem 0xfc900000-0xfc90ffff pref]
[    3.057964] pci 0000:00:00.0: BAR 13: assigned [io  0x1000-0x1fff]
[    3.064091] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc800000-0xfc80ffff pref]
[    3.071245] pci 0000:01:00.0: BAR 5: assigned [mem 0xfc700000-0xfc7001ff]
[    3.077984] pci 0000:01:00.0: BAR 4: assigned [io  0x1000-0x100f]
[    3.084018] pci 0000:01:00.0: BAR 0: assigned [io  0x1010-0x1017]
[    3.090055] pci 0000:01:00.0: BAR 2: assigned [io  0x1018-0x101f]
[    3.096092] pci 0000:01:00.0: BAR 1: assigned [io  0x1020-0x1023]
[    3.102129] pci 0000:01:00.0: BAR 3: assigned [io  0x1024-0x1027]
[    3.108169] pci 0000:00:00.0: PCI bridge to [bus 01-ff]
[    3.113335] pci 0000:00:00.0:   bridge window [io  0x1000-0x1fff]
[    3.119374] pci 0000:00:00.0:   bridge window [mem 0xfc700000-0xfc7fffff]
[    3.126114] pci 0000:00:00.0:   bridge window [mem 0xfc800000-0xfc8fffff pref]
[    3.133532] pcieport 0000:00:00.0: PME: Signaling with IRQ 37
[    3.139193] pcieport 0000:00:00.0: AER: enabled with IRQ 37
[    3.144663] ahci 0000:01:00.0: enabling device (0000 -> 0003)
[    3.150316] ahci 0000:01:00.0: SSS flag set, parallel bus scan disabled
[    3.156753] ahci 0000:01:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl IDE mode
[    3.164655] ahci 0000:01:00.0: flags: 64bit ncq sntf stag led clo pmp pio slum part ccc sxs
[    3.173922] scsi host0: ahci
[    3.176243] scsi host1: ahci
[    3.178818] ata1: SATA max UDMA/133 abar m512@0xfc700000 port 0xfc700100 irq 38
[    3.185963] ata2: SATA max UDMA/133 abar m512@0xfc700000 port 0xfc700180 irq 38
```
