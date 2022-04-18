
:: 取个怪异的名字加"__",尽量不干扰全局的变量
:: 使用方式： call wslpath.bat [WINDOW路径] [保存的变量名]
::  call wslpath.bat . MOUNT_PATH
::  call wslpath.bat "C:\Program Files\Docker" MOUNT_PATH
::
::  MIT License 
::  @https://gitee.com/wuxue107/wslpath.bat
:: 
:: SETLOCAL 

set __SET_PARAM_NAME=%2
set __FULL_PATH=%~f1
set __FILE_PATH=%__FULL_PATH:~2%
set __FILE_PATH=%__FILE_PATH:\=/%
set __DEVICE_NAME=%~d1
set __DEVICE_NAME=%__DEVICE_NAME::=%

for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set __DEVICE_NAME=%%__DEVICE_NAME:%%i=%%i%%
:: ENDLOCAL
if "%__SET_PARAM_NAME%" == "" (
    echo /%__DEVICE_NAME%%__FILE_PATH%
) else (
    set %__SET_PARAM_NAME%=/%__DEVICE_NAME%%__FILE_PATH%
)
