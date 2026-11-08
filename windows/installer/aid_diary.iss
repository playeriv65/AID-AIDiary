; Per-user Windows installer for AID Diary (docs/UPDATES.md). Build with
;   ISCC /DVersion=0.1.2 /DBuild=261108154 windows\installer\aid_diary.iss
; after `flutter build windows --release` and the `aid` CLI compile; the
; nightly passes the same values. /DBundle and /DCliExe point elsewhere.

#define Ini SourcePath + "installer.ini"
#define AppId ReadIni(Ini, "App", "Id")
#define AppName ReadIni(Ini, "App", "Name")
#define AppPublisher ReadIni(Ini, "App", "Publisher")
#define AppUrl ReadIni(Ini, "App", "Url")
#define AppExe ReadIni(Ini, "App", "Exe")
#define CliName ReadIni(Ini, "App", "Cli")
#if AppId == "" || AppExe == "" || CliName == ""
  #error installer.ini is missing the app's identity
#endif
#ifndef Version
  #error Pass the app version: /DVersion=MAJOR.MINOR.PATCH
#endif
#ifndef Build
  #error Pass the build number: /DBuild=YYMMDDHHM
#endif
#ifndef Bundle
  #define Bundle SourcePath + "..\..\build\windows\x64\runner\Release"
#endif
#ifndef CliExe
  #define CliExe SourcePath + "..\..\build\cli\aid.exe"
#endif

[Setup]
AppId={{{#AppId}}
AppName={#AppName}
AppVersion={#Version} ({#Build})
AppPublisher={#AppPublisher}
AppPublisherURL={#AppUrl}
AppSupportURL={#AppUrl}
VersionInfoVersion={#Version}
; Per user, without an administrator prompt: {autopf} is then
; %LOCALAPPDATA%\Programs.
PrivilegesRequired=lowest
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
SetupIconFile=..\runner\resources\app_icon.ico
OutputDir=..\..\build\installer
OutputBaseFilename=aid-diary-windows-setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; An update replaces files of the running app: close it (the app exits by
; itself after starting a silent update; this covers a slow exit) and
; start it again from [Run], as Restart Manager cannot restart it.
CloseApplications=force
RestartApplications=no
ChangesEnvironment=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
english.AddToPath=Add the %1 command line to PATH

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "addtopath"; Description: "{cm:AddToPath,{#CliName}}"; Flags: unchecked

[InstallDelete]
; Flutter's assets from the previous version; the new build brings its own.
Type: filesandordirs; Name: "{app}\data"

[Files]
Source: "{#Bundle}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#CliExe}"; DestDir: "{app}"; DestName: "{#CliName}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
; A silent update started by the app asks for it to open again.
Filename: "{app}\{#AppExe}"; Flags: nowait; Check: Relaunch

[Code]
const
  EnvironmentKey = 'Environment';

function Relaunch: Boolean;
begin
  Result := ExpandConstant('{param:relaunch|0}') = '1';
end;

// Paths without Dir, and whether Dir was among them.
function PathWithout(Paths, Dir: String; var Found: Boolean): String;
var
  Rest, Item: String;
  Split: Integer;
begin
  Result := '';
  Found := False;
  Rest := Paths;
  while Rest <> '' do
  begin
    Split := Pos(';', Rest);
    if Split = 0 then
    begin
      Item := Rest;
      Rest := '';
    end
    else
    begin
      Item := Copy(Rest, 1, Split - 1);
      Delete(Rest, 1, Split);
    end;
    if CompareText(RemoveBackslashUnlessRoot(Item), RemoveBackslashUnlessRoot(Dir)) = 0 then
      Found := True
    else if Item <> '' then
    begin
      if Result <> '' then
        Result := Result + ';';
      Result := Result + Item;
    end;
  end;
end;

// Puts Dir on the user's PATH, or takes it off.
procedure SetOnPath(Dir: String; Present: Boolean);
var
  Paths, Others: String;
  Found: Boolean;
begin
  if not RegQueryStringValue(HKCU, EnvironmentKey, 'Path', Paths) then
    Paths := '';
  Others := PathWithout(Paths, Dir, Found);
  if Present = Found then
    Exit;
  if Present then
  begin
    if Others <> '' then
      Others := Others + ';';
    Others := Others + Dir;
  end;
  RegWriteExpandStringValue(HKCU, EnvironmentKey, 'Path', Others);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    SetOnPath(ExpandConstant('{app}'), WizardIsTaskSelected('addtopath'));
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    SetOnPath(ExpandConstant('{app}'), False);
end;
