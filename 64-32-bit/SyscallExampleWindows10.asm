;Works on a Windows 10 (1709)
;This works in a 32bit program running on a 64bit OS.
Format PE Console
include 'win32a.inc'
entry start

section '.data' data readable writable
szName db 'C:\Windows\System32\notepad.exe', 0
sInfo STARTUPINFO
pInfo PROCESS_INFORMATION

section '.text' code readable writable executable
start:

        invoke CreateProcess, szName, NULL, NULL, NULL, FALSE, 0, NULL, NULL, sInfo, pInfo
        invoke Sleep, 2000d ;Sleep so you can see notepad, then see it be terminated
        invoke OpenProcess, PROCESS_ALL_ACCESS, FALSE, [pInfo.dwProcessId]

        push eax ;1st Parameter
        push 0 ;2nd Paramter
        mov eax, 0x2C ;NtTerminateProcess syscall for x86-x64 Win10 (all versions)
        mov ebx, [fs:0xC0] ;Contains a pointer to FastSysCall in Wow64. (Wikipedia)
        call ebx

section '.idata' import readable writable
library kernel32, 'kernel32.dll'

include 'api/kernel32.inc'
