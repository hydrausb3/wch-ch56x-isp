wch-ch56x-isp
=======

wch-ch56x-isp is a small utility to program WCH micro-controllers.
This utility is a rewrite in C of the rust tool [wchisp](https://github.com/ch32-rs/wchisp) based on https://github.com/jmaselbas/wch-isp.
This utility support only WCH CH569W & CH565.

Contributor shall check [CODING_STYLE.md](CODING_STYLE.md)

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

- For usage type `wch-ch56x-isp -h`
```
Usage: wch-ch56x-isp [OPTION]...
  -V, --Version             Print version
  -h, --help                Show help
  -c, --config              Print CH569 config(after isp_init and before isp_fini)
  -p, --progress            Display progress
  -v, --verify              Do verify after erase/program
  -r, --reset               Reset MCU at end
  -d, --mcudebug=VALUE      Set MCU debug mode on or off
  -f, --flashfile=VALUE     Flash file (binary file *.bin)
```

- Standard use case to flash a bin file with verify and reset
  - #### GNU/Linux
    - `wch-ch56x-isp -vr -f=fullpath/file.bin`
  - #### Windows
    - `wch-ch56x-isp.exe -vr -f=fullpath/file.bin`

### CH56x Flash RAMX/ROM size
With the new version v0.3 or more the flash is automatically set depending on flash file size to set internally `flash32k`, `flash64k` or `flash96k`
- `flash32k` will change the RAMX maximum usable size to 96KB and ROM(flash code running in 0 wait sate) to 32KB
  - It is used for any code which does not exceed 32KB to run with maximum performances, application shall not use more than 96KB of RAMX
- `flash64k` will change the RAMX maximum usable size to 64KB and ROM(flash code running in 0 wait sate) to 64KB
  - It is used for any code which does not exceed 64KB to run with maximum performances, application shall not use more than 64KB of RAMX
- `flash96k` will change the RAMX maximum usable size to 32KB and ROM(flash code running in 0 wait sate) to 96KB
  - It is used for any code which does not exceed 96KB to run with maximum performances, application shall not use more than 32KB of RAMX

### CH56x Debug mode
* If the CH56x config `debug` mode is `on/enabled` it is impossible to flash a program with `wch-ch56x-isp` and it will return error "Fail to program chunk @ 0 error: e0 00" (the booloader refuse to flash anything when debug mode is `on/enabled` and the program shall be flashed with 2-Wire Debug).
* To enable the `debug` mode, launch `wch-ch56x-isp -d=on`
* To disable the `debug` mode, launch `wch-ch56x-isp -d=off`
* To check the CH569 config `debug` mode, launch `wch-ch56x-isp -c` and it will display the config of the CH569 including debug state (`DEBUG_EN` `1: enabled` or `0: disabled`)

Example WCH569 config with debug enabled/on:
```
wch-ch56x-isp -c
...
config after isp_init() nv=0xCFFFF245
[4] RESET_EN 0: disabled
[5] DEBUG_EN 1: enabled
[6] BOOT_EN 1: enabled
[7] CODE_READ_EN 1: enabled
[29] LOCKUP_RST_EN 0: disabled
[31:30] USER_MEM 0x02: RAMX 96KB + ROM 32KB
config before isp_fini() nv=0xCFFFF245
...
```

Example WCH569 config with debug disabled/off:
```
wch-ch56x-isp -c
...
config after isp_init() nv=0x8FFFF245
[4] RESET_EN 0: disabled
[5] DEBUG_EN 0: disabled
[6] BOOT_EN 1: enabled
[7] CODE_READ_EN 0: disabled
[29] LOCKUP_RST_EN 0: disabled
[31:30] USER_MEM 0x02: RAMX 96KB + ROM 32KB
...
```

Warning: After any change to CH56x Debug mode old binary previously flashed will not run correctly, so it is mandatory to flash the program again with a binary like in example [`How to use wch-ch56x-isp`](https://github.com/hydrausb3/wch-ch56x-isp#how-to-use-wch-ch56x-isp)
