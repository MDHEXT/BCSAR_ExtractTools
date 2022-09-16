@ECHO OFF

SET "$WORKDIR=%~dp0"
SET "$TEMPDIR=%$WORKDIR%/tmp"

FOR %%A IN (*.bcsar;*.csar) DO (
	MKDIR "%$TEMPDIR%" >NUL 2>&1

	"%$WORKDIR%tools\Wii3DSUSoundTool.exe" "%%~A"

	PUSHD "%%~nxA_ext"
	FOR /R %%B IN (*.txt) DO MOVE /Y "%%~B" "%$TEMPDIR%" >NUL 2>&1
	FOR /R %%B IN (*.bcseq;*.cseq) DO (
		"%$WORKDIR%tools\cseq2midi.exe" "%%~B"
		MOVE /Y "%%~B.mid" "%$WORKDIR%" >NUL 2>&1
	)
	FOR /R %%B IN (*.bcwav) DO "%$WORKDIR%tools\test.exe" -o "%$TEMPDIR%\%%~nB.wav" -L "%%~B" >NUL 2>&1
	POPD
	RMDIR /S /Q "%%~nxA_ext"

	FOR %%B IN (%$TEMPDIR%\*.txt) DO (
		MKDIR "%$WORKDIR%output\%%~A" >NUL 2>&1
		"%$WORKDIR%tools\sf2comp" c "%%~B" "%$WORKDIR%output\%%~A\%%~nB"
	)

	RMDIR /S /Q "%$TEMPDIR%" >NUL 2>&1
)

ECHO.
ECHO The extraction process is complete! Thanks for using this tool!
PAUSE >NUL
EXIT /B