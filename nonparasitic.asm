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