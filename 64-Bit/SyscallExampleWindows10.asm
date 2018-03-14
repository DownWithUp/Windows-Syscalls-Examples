;Works on a Windows 10 (1709)
;This is native 64-bit
Format PE64 Console
include 'win64a.inc'
entry start

section '.data' data readable writable
szName db 'C:\Windows\System32\notepad.exe', 0
sInfo STARTUPINFO
pInfo PROCESS_INFORMATION

section '.text' code readable writable executable
start:
        sub rsp, 8 ;Align stack
        invoke CreateProcess, szName, NULL, NULL, NULL, FALSE, 0, NULL, NULL, sInfo, pInfo
        invoke Sleep, 2000d;Sleep so you can see notepad, then see it be terminated
        invoke OpenProcess, PROCESS_ALL_ACCESS, FALSE, [pInfo.dwProcessId]

        mov r10, rax ;1st parameter, r10 must contain first parameter
        mov rdx, 0 ;2nd Paramter
        mov eax, 0x2C ;NtTerminateProcess syscall for x64 Win10 (all versions)
        syscall ;Call the kernel
        invoke ExitProcess, 0


section '.idata' import readable writable
library kernel32, 'kernel32.dll'

include 'api/kernel32.inc'
