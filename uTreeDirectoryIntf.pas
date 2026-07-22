(*
    My Projects: https://github.com/superbot-coder?tab=repositories
    Telegram channel: https://t.me/delphi_solutions
    Telegram chat: https://t.me/delphi_solutions_chat
    Date: 22.07.2026
 *)

unit uTreeDirectoryIntf;

interface

USES
  System.SysUtils, System.StrUtils, System.Classes, Vcl.ComCtrls, System.IOUtils,
  Dialogs;

type

  ITreeBuilder = interface
  ['{A7E29AE0-2C7D-4D65-9DBB-7E980B34B42A}']
    function SetIndexIcons(const IndexDir, indexFile: Integer): ITReeBuilder;
    function SetInitialDir(const InitialDir: string): ITReeBuilder;
    function SetTree(Tree: TTreeView): ITReeBuilder;
    function SetFilterFileExt(const AExt: TArray<string>): ITReeBuilder;
    function SetTreeStrings(TreeStrings: TStrings): ITReeBuilder;
    procedure TreeExecut;
    procedure TreeListExecut;
    procedure TreeFullPathListExecut;
  end;

  TTreeBuilder = class(TInterfacedObject, ITReeBuilder)
  private
    FIndexDirectory: Integer;
    FindexFile: Integer;
    FTree: TTreeView;
    FTreeStrings: TStrings;
    FInitialDir: string;
    FExt: TArray<string>;
    procedure GetTree(const Directory: string; Node: TTreeNode); Inline;
    procedure GetTreeList(const Directory: string; EntrLevel: UInt32); Inline;
    procedure GetTreeFullPathList(const Directory: string); Inline;
  public
    constructor Create(Tree: TTreeView; TreeStrings: TStrings; const InitialDir: string); overload;
    constructor Create; overload;
    function SetIndexIcons(const IndexDir, indexFile: Integer): ITReeBuilder;
    function SetInitialDir(const InitialDir: string): ITReeBuilder; Inline;
    function SetFilterFileExt(const AExt: TArray<string>): ITReeBuilder; Inline;
    function SetTree(Tree: TTreeView): ITReeBuilder; Inline;
    function SetTreeStrings(TreeStrings: TStrings): ITReeBuilder; Inline;
    procedure TreeExecut;
    procedure TreeListExecut;
    procedure TreeFullPathListExecut;
    class function New: ITReeBuilder;
  end;

implementation

{ TTReeBuilder }

constructor TTreeBuilder.Create(Tree: TTreeView; TreeStrings: TStrings; const InitialDir: string);
begin
  inherited Create;
  FIndexDirectory := -1;
  FindexFile := -1;
  FTree := Tree;
  FTreeStrings := TreeStrings;
  FInitialDir := InitialDir;
end;

constructor TTreeBuilder.Create;
begin
  inherited Create;
  FIndexDirectory := -1;
  FindexFile := -1;
  FTree := Nil;
  FTreeStrings := Nil;
end;

procedure TTreeBuilder.GetTree(const Directory: string; Node: TTreeNode);
var
  TN: TTreeNode;
begin
  for var enum in TDirectory.GetFileSystemEntries(Directory, '*') do
  begin
    var EnumName := enum.Replace(IncludeTrailingPathDelimiter(Directory), '');
    if DirectoryExists(Enum) then
    begin

      // The only My Project
      if EnumName.ToLower = 'images' then
        Continue;

      TN := FTree.Items.AddChild(Node, EnumName);
      TN.ImageIndex := FIndexDirectory;
      TN.SelectedIndex := FIndexDirectory;
      GetTree(Enum, TN);
    end
    else
    begin
      // implementation filter Extentions
      if Length(FExt) > 0 then
      begin
        if Not AnsiMatchStr(TPath.GetExtension(EnumName).ToLower, FExt) then
        begin
          Continue;
        end;
      end;
      TN := FTRee.Items.AddChild(Node,  EnumName);
      TN.ImageIndex    := FindexFile;
      TN.SelectedIndex := FindexFile;
    end;
  end;
end;

procedure TTreeBuilder.GetTreeFullPathList(const Directory: string);
begin
  for var enum in TDirectory.GetFileSystemEntries(Directory, '*') do
  begin
    if DirectoryExists(enum) then
    begin

      // The only My Project
      // if enum.ToLower = 'images' then
      // Continue;

      FTreeStrings.Add(enum);
      GetTreeFullPathList(enum);
    end
    else
    begin
      // implementation filter Extentions
      if Length(FExt) > 0 then
      begin
        if Not AnsiMatchStr(TPath.GetExtension(enum).ToLower, FExt) then
        begin
          Continue;
        end;
      end;
      FTreeStrings.Add(Enum);
    end;
  end;
end;

procedure TTreeBuilder.GetTreeList(const Directory: string; EntrLevel: UInt32);
begin
  for var enum in TDirectory.GetFileSystemEntries(Directory, '*') do
  begin
    var EnumName := enum.Replace(IncludeTrailingPathDelimiter(Directory), '');
    if DirectoryExists(enum) then
    begin
      if EnumName.ToLower = 'images' then
        Continue;
      FTreeStrings.Add(StringOfChar(#9, EntrLevel) + EnumName);
      GetTreeList(enum, succ(EntrLevel));
    end
    else
    begin
      // implementation filter Extentions
      if Length(FExt) > 0 then
      begin
        if Not AnsiMatchStr(TPath.GetExtension(EnumName).ToLower, FExt) then
        begin
          Continue;
        end;
      end;
      FTreeStrings.Add(StringOfChar(#9, EntrLevel) + EnumName);
    end;
  end;
end;

class function TTreeBuilder.New: ITreeBuilder;
begin
  Result := TTreeBuilder.Create;
end;

procedure TTReeBuilder.TreeListExecut;
begin
  if Not Assigned(FTreeStrings) then
    raise Exception.Create('Error:  TStrings is Nil');
  if FInitialDir.IsEmpty then
    raise Exception.Create('Error: InitialDir is empty');
  FTreeStrings.BeginUpdate;
  FTreeStrings.Clear;
  GetTreeList(FInitialDir, 0);
  FTreeStrings.EndUpdate;
end;

function TTreeBuilder.SetIndexIcons(const IndexDir,
  indexFile: Integer): ITReeBuilder;
begin
  Result := Self;
  FIndexDirectory := IndexDir;
  FindexFile      := indexFile;
end;

function TTReeBuilder.SetInitialDir(const InitialDir: string): ITReeBuilder;
begin
  Result := Self;
  FInitialDir := InitialDir;
end;

function TTReeBuilder.SetFilterFileExt(const
  AExt: TArray<string>): ITReeBuilder;
begin
  Result := Self;
  FExt := AExt;
  for var i := 0 to High(FExt) do
    FExt[i] := FExt[i].ToLower;
end;

function TTReeBuilder.SetTree(Tree: TTreeView): ITReeBuilder;
begin
  Result := Self;
  FTree  := Tree;
end;

function TTReeBuilder.SetTreeStrings(TreeStrings: TStrings): ITReeBuilder;
begin
  Result := Self;
  FTreeStrings := TreeStrings;
end;

procedure TTReeBuilder.TreeExecut;
begin
  if not Assigned(FTree) then
    raise Exception.Create('Error: control TTreeView is Nil');
  if FInitialDir.IsEmpty then
    raise Exception.Create('Error: InitialDir is empty');
  FTree.Items.BeginUpdate;
  FTree.Items.Clear;
  GetTree(FInitialDir, Nil);
  FTree.Items.EndUpdate;
end;

procedure TTReeBuilder.TreeFullPathListExecut;
begin
  if Not Assigned(FTreeStrings) then
    raise Exception.Create('Error:  TStrings is Nil');
  if FInitialDir.IsEmpty then
    raise Exception.Create('Error: InitialDir is empty');

  FTreeStrings.BeginUpdate;
  FTreeStrings.Clear;
  GetTreeFullPathList(FInitialDir);
  FTreeStrings.EndUpdate;
end;

end.
