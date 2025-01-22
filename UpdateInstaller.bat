call ..\..\CreateInstaller.bat

::Get version number from the most recent release, if there is none, start at 0.0.0
powershell -Command "Invoke-WebRequest https://github.com/EC-WW/NiteLiteSite/releases/latest/download/VERSION.txt -OutFile VERSION.txt"
if errorlevel 1 (
    echo v0 > VERSION.txt
)

::get current version and increment version file major version number
set /p version=<version.txt
for /f "tokens=1-1 delims=.v" %%a in ("%version%") do (
  set /a vernum=%%a + 1
)
set new_version=%vernum%
echo v%new_version% > VERSION.txt

::create the release on github
gh release create %new_version% --notes %new_version%

::add the zip to the release
gh release upload %new_version% VERSION.txt
gh release upload %new_version% ..\..\Installer\INSTALLER\NiteLite_Setup.exe

::delete the uploaded stuffs
del VERSION.txt
del NiteLite.zip