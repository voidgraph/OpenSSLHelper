:: Encrypt with AES-256-CBC and Sign SHA256 with RSA
:: Result will be in Out/ dir
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "Encrypt and sign util" & echo."Enter file name in work dir (ex. test.txt)" & echo."or absolute file path (ex. D:\OpenSSLHelper\In\test.txt):")
set /p "InputFilePath="
(>&2 echo "Enter new file extension (ex. enc):")
set /p "NewFileExt="
cd /d %~dp0
cd In
call :NORMALIZEPATH %InputFilePath%
call :DELIMPATH %RETVAL%
set InputFilePath=%RETVAL%
cd ..
if not exist %InputFilePath% (
(>&2 echo "File %InputFilePath% not found" & echo."Put file in In/ dir and type file name or type absolute file path")
EXIT /B 1
)
call set_keys.bat
cd AES
echo 1|call call_enc.bat ..\Keys\%AES_ENC_KEY% 00000000000000000000000000000000 %InputFilePath% > ..\Out\%DelimFileName%.%NewFileExt%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, error = !errorlevel!")
	EXIT /B 1
)
cd ..
cd RSA
echo 1|call call_dgst.bat ..\Keys\%RSA_SIGN_KEY% ..\Out\%DelimFileName%.%NewFileExt%
cd ..

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
  
:DELIMPATH
  FOR %%i IN ("%~1") DO (
    SET DelimFileDrive=%%~di
    SET DelimFileName=%%~ni
    SET DelimFilePath=%%~pi
    SET DelimFileExtension=%%~xi
  )
  EXIT /B