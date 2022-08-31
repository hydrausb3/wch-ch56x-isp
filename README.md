wch-ch56x-isp
=======

wch-ch56x-isp is a small utility to program WCH micro-controllers.
This utility is a rewrite in C of the rust tool [wchisp](https://github.com/ch32-rs/wchisp) based on https://github.com/jmaselbas/wch-isp.
This utility has only be tested on the CH569W & CH565 but should work on any WCH CH56x.

### MounRiver Studio or MounRiver Studio Community project settings to generate bin file for CH56x...
 - #### Properties of project => C/C++ Build => Settings => Build Steps
   - ##### Post-build steps:
     - `riscv-none-embed-objcopy -O binary "${ProjName}.elf"  "${ProjName}.bin"`
   - ##### Description:
     - `Create Flash Image BIN`

### Driver installation for Windows
- Run Zadig (executable can be found on https://zadig.akeo.ie/)
- Install or Reinstall driver for "USB Module" (with USB ID `4348` `55E0`) with `libusb-win32` or `WinUSB`
- Note: After 10s without any activity the device "USB Module" (with USB ID `4348` `55E0`) will disappear as the bootloader timeout so it shall be restarted

### How to build wch-ch56x-isp
- See the document [How_To_Build.md](How_To_Build.md)

### How to use wch-ch56x-isp
- Start a shell(on GNU/Linux) or execute cmd(on Windows)
- For usage type wch-ch56x-isp -h (options -p display progress, -v do verify after write, -r reset board at end, -V print the version) 
  - #### GNU/Linux
    - wch-ch56x-isp -vr flash fullpath/file.bin
  - #### Windows
    - wch-ch56x-isp.exe -vr flash fullpath/file.bin

### CH569 Flash RAMX/ROM size
With the new version v0.2.0 there is new commands `flash32k`, `flash64k` and `flash96k`
- flash32k will change the RAMX maximum usable size to 96KB and ROM(flash code running in 0 wait sate) to 32KB
  - It shall be used for any code which does not exceed 32KB to run with maximum performances
- flash64k will change the RAMX maximum usable size to 64KB and ROM(flash code running in 0 wait sate) to 64KB
  - It shall be used for any code which does not exceed 64KB to run with maximum performances
- flash96k will change the RAMX maximum usable size to 32KB and ROM(flash code running in 0 wait sate) to 96KB
  - It shall be used for any code which does not exceed 96KB to run with maximum performances

One of those new commands shall be used only to change the RAMX/ROM(Flash code) size ratio.

Warning: After any change to RAMX/ROM size old binary previously flashed will not run correctly, so it is mandatory to flash the program again with a binary by using `flash` command like in example [`How to use wch-isp`](https://github.com/hydrausb3/wch-isp#how-to-use-wch-isp)

### CH569 Debug mode
* If the CH569 config `debug` mode is `on/enabled` it is impossible to flash a program with `wch-ch56x-isp` and it will return error "Fail to program chunk @ 0 error: e0 00" (the booloader refuse to flash anything when debug mode is `on/enabled`).
* To check the CH569 config `debug` mode, launch `wch-ch56x-isp -c` and it will display the config of the CH569 including debug state (`DEBUG_EN` `1: enabled` or `0: disabled`)
* To disable the `debug` mode, launch `wch-ch56x-isp debug-off`

Example WCH569 config with debug enabled/on:
```
nv=0x8FFFF2E5
[4] RESET_EN 0: disabled
[5] DEBUG_EN 1: enabled
[6] BOOT_EN 1: enabled
[7] CODE_READ_EN 1: enabled
[29] LOCKUP_RST_EN 0: disabled
[31:30] USER_MEM 0x02: RAMX 96KB + ROM 32KB
```

Example WCH569 config with debug disabled/off:
```
nv=0x8FFFF245
[4] RESET_EN 0: disabled
[5] DEBUG_EN 0: disabled
[6] BOOT_EN 1: enabled
[7] CODE_READ_EN 0: disabled
[29] LOCKUP_RST_EN 0: disabled
[31:30] USER_MEM 0x02: RAMX 96KB + ROM 32KB
```
