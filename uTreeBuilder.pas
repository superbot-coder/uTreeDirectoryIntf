
(*
    My Projects: https://github.com/superbot-coder?tab=repositories
    Telegram channel: https://t.me/delphi_solutions
    Telegram chat: https://t.me/delphi_solutions_chat
    Date: 23.07.2026
 *)

unit uTreeBuilder;

interface

USES
  System.SysUtils, System.StrUtils, System.IOUtils, System.Classes, Vcl.ComCtrls,
  uTreeBuilderIntf;

Type

  TTreeBuilder = class(TTreeBase, ITreeBuilder)
  private
    FIndexDirectory: Integer;
    FindexFile: Integer;
    FTree: TTreeView;
    procedure SetIndexIcons(const IndexDir, IndexFile: Integer); Inline;
    procedure SetTree(ATree: TTreeView); Inline;
    procedure BuildTree(const Directory: string; Node: TTreeNode); Inline;
  public
    constructor Create; overload;
    constructor Create(const AInitialDir: String; ATree: TTreeView;
      AExt: TArray<String>; AIndexDir: integer = -1; AIndexFile: Integer = -1); overload;
    procedure Execut;
    class function New(const AInitialDir: String; ATree: TTreeView;
      AExt: TArray<String>; IndexDir: Integer = -1; IndexFile: Integer = -1): ITreeBuilder; overload;
    class function New: ITreeBuilder; overload;
  end;

  TTreeListBuilder = class(TTreeBase, ITreeListBuilder)
  private
    FTreeList: TStrings;
    FFullPathEnabled: Boolean;
    procedure BuildTree(const Directory: string; EntrLevel: Integer); inline;
  public
    constructor Create; overload;
    constructor Create(const AInitialDir: string; ATreeList: TStrings; AExt: TArray<String>); overload;
    procedure SetTreeList(ATreeList: TStrings); inline;
    procedure Execut(FullPathEnabled: Boolean = false);
    class function New(const AInitialDir: string; ATreeList: TStrings; AExt: TArray<String>): ITreeListBuilder; overload;
    class function New: ITreeListBuilder; overload;
  end;


implementation

{ TTreeBuilder}

procedure TTreeBuilder.BuildTree(const Directory: string; Node: TTreeNode);
var
  TN: TTreeNode;
begin
  for var enum in TDirectory.GetFileSystemEntries(Directory) do
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
      BuildTree(Enum, TN);
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

constructor TTreeBuilder.Create;
begin
  inherited Create;
  FIndexDirectory := -1;
  FindexFile := -1;
  FTree := Nil;
end;

constructor TTreeBuilder.Create(const AInitialDir: String; ATree: TTreeView;
  AExt: TArray<String>; AIndexDir, AIndexFile: Integer);
begin
  FInitialDir := AInitialDir;
  FTree := ATree;
  SetFilterFileExt(AExt);
  FIndexDirectory := AIndexDir;
  FindexFile := AIndexFile;
end;

procedure TTreeBuilder.Execut;
begin
  if not Assigned(FTree) then
    raise Exception.Create('Error: control TTreeView is Nil');
  if FInitialDir.IsEmpty then
    raise Exception.Create('Error: InitialDir is empty');
  FTree.Items.BeginUpdate;
  FTree.Items.Clear;
  BuildTree(FInitialDir, Nil);
  FTree.Items.EndUpdate;
end;

class function TTreeBuilder.New: ITreeBuilder;
begin
  Result := TTreeBuilder.Create;
end;

class function TTreeBuilder.New(const AInitialDir: String; ATree: TTreeView;
  AExt: TArray<String>; IndexDir, IndexFile: Integer): ITreeBuilder;
begin
  Result := TTreeBuilder.Create;
  Result.InitialDir := AInitialDir;
  Result.Tree := ATree;
  Result.SetFilterFileExt(AExt);
  Result.SetIndexIcons(IndexDir, IndexFile);
end;

procedure TTreeBuilder.SetIndexIcons(const IndexDir, indexFile: Integer);
begin
  FIndexDirectory := IndexDir;
  FindexFile := IndexFile;
end;

procedure TTreeBuilder.SetTree(ATree: TTreeView);
begin
  FTree := ATree;
end;

{ TTreeListBuilder }

procedure TTreeListBuilder.BuildTree(const Directory: string; EntrLevel: Integer);
begin

  for var enum in TDirectory.GetFileSystemEntries(Directory) do
  begin

    var EnumName := enum.Replace(IncludeTrailingPathDelimiter(Directory), '');

    if DirectoryExists(enum) then
    begin

      // if EnumName.ToLower = 'images' then
      //  Continue;

      if FFullPathEnabled then
        FTreeList.Add(enum)
      else
        FTreeList.Add(StringOfChar(#9, EntrLevel) + EnumName);

      BuildTree(enum, succ(EntrLevel));
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

     if FFullPathEnabled then
       FTreeList.Add(enum)
     else
       FTreeList.Add(StringOfChar(#9, EntrLevel) + EnumName);
    end;
  end;

end;

constructor TTreeListBuilder.Create;
begin
  Inherited Create;
  FTreeList := Nil;
  FInitialDir := '';
end;

constructor TTreeListBuilder.Create(const AInitialDir: string;
  ATreeList: TStrings; AExt: TArray<String>);
begin
  inherited Create;
  FInitialDir := AInitialDir;
  FTreeList := ATreeList;
  SetFilterFileExt(AExt);
end;

procedure TTreeListBuilder.Execut(FullPathEnabled: Boolean);
begin
  if Not Assigned(FTreeList) then
    raise Exception.Create('Error:  TStrings is Nil');
  if FInitialDir.IsEmpty then
    raise Exception.Create('Error: InitialDir is empty');
  FTreeList.BeginUpdate;
  FTreeList.Clear;
  FFullPathEnabled := FullPathEnabled;
  BuildTree(FInitialDir, 0);
  FTreeList.EndUpdate;
end;

class function TTreeListBuilder.New(const AInitialDir: string;
  ATreeList: TStrings; AExt: TArray<String>): ITreeListBuilder;
begin
  Result := TTreeListBuilder.Create(AInitialDir, ATreeList, AExt);
end;

class function TTreeListBuilder.New: ITreeListBuilder;
begin
  Result := TTreeListBuilder.Create;
end;

procedure TTreeListBuilder.SetTreeList(ATreeList: TStrings);
begin
  FTreeList := ATreeList;
end;

end.
