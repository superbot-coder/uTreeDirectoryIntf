
(*
    My Projects: https://github.com/superbot-coder?tab=repositories
    Telegram channel: https://t.me/delphi_solutions
    Telegram chat: https://t.me/delphi_solutions_chat
    Date: 23.07.2026
 *)

unit uTreeBuilderIntf;

interface

USES
  System.SysUtils, System.StrUtils, System.IOUtils, System.Classes, Vcl.ComCtrls;

type

  ITreeBase = interface
  ['{DBF9B47E-E863-498F-BE3B-409C8ABEE701}']
    function GetInitialDir: string;
    procedure SetInitialDir(const AInitialDir: string);
    procedure SetFilterFileExt(const AExt: TArray<string>);
    property InitialDir: string read GetInitialDir write SetInitialDir;
  end;

  TTreeBase = class(TInterfacedObject, ITreeBase)
  Protected
    FInitialDir: String;
    FExt: TArray<string>;
    function GetInitialDir: string;
    procedure SetInitialDir(const AInitialDir: string);
    procedure SetFilterFileExt(const AExt: TArray<string>);
    property InitialDir: string read GetInitialDir write SetInitialDir;
  end;

  ITreeBuilder = interface(ITreeBase)
  ['{6AB8DDD8-4DA0-4104-B69A-0AFE39D27574}']
    procedure SetIndexIcons(const IndexDir, IndexFile: Integer);
    procedure SetTree(ATree: TTreeView);
    property Tree: TTreeView write SetTree;
    procedure Execut;
  end;

  ITreeListBuilder = interface(ITreeBase)
  ['{42C98BF1-F0F9-4FD4-B1E2-39988525818C}']
    procedure SetTreeList(ATree: TStrings);
    procedure Execut(FullPath: Boolean = false);
  end;

implementation

{ TTreeBase }

function TTreeBase.GetInitialDir: string;
begin
  Result := FInitialDir;
end;

procedure TTreeBase.SetFilterFileExt(const AExt: TArray<string>);
begin
  FExt := AExt;
  for var i := 0 to High(FExt) do
    FExt[i] := FExt[i].ToLower;
end;

procedure TTreeBase.SetInitialDir(const AInitialDir: string);
begin
  FInitialDir := AInitialDir;
end;

end.
