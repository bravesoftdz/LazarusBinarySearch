unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  CheckLst, StdCtrls, Clipbrd, lazUTF8;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    CheckListBox6: TCheckListBox;
    CheckListBox7: TCheckListBox;
    CheckListBox3: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  slBuf: TStringList;

  function BinSearch(Strings: TStringList; SubStr: string; iFirst:integer;iLast:integer): Integer;
  function LowercaseFirst(const s:string):string;
  function NaiveSearch(Strings: TStringList; SubStr: string): Integer;


implementation

{$R *.lfm}


function BinSearch(Strings: TStringList; SubStr: string; iFirst:integer;iLast:integer): Integer;
// Binary search.
// Caution: 1) No doubles in dic. 2) Dic must be sorted.
// Problems : 'ciò' > 'città' ; 'ciò' > 'cit' ; 'ciò' > 'cip'
// Binary search uses > comparison and =, while naive search only uses = operator.
var
  iPivot: Integer;
  bFound: Boolean;
begin
 bFound  := False; //Initializes the bFound flag (Not bFound yet)
 Result := -1; //Initializes the Result
 //If iFirst > iLast then searched item doesn't exist
 //If item is bFound the loop stops
  while (iFirst <= iLast) and (not bFound) do
  begin
   iPivot := (iFirst + iLast) div 2; // trunc(iFirst + iLast) gives the same result.
//    if (Strings[iPivot] = SubStr) then // UTF8CompareText(Strings[iPivot], SubStr) < 0 then
   if Strings[iPivot] = SubStr then // UTF8CompareText(Strings[iPivot], SubStr) < 0 then
    begin
      bFound  := True;
      Result := iPivot;
    end
//    else if (Strings[iPivot] > SubStr) then // UTF8CompareText(Strings[iPivot], SubStr) > 0 then
//    else if UTF8CompareText(Strings[iPivot], SubStr) > 0 then
    else if WideCompareText(UTF8Decode(Strings[iPivot]), UTF8Decode(SubStr)) > 0 then
    iLast := iPivot - 1
    else
      iFirst := iPivot + 1;
  end;
end;

{ TForm1 }


procedure TForm1.BitBtn1Click(Sender: TObject);
 var
 i, iCount, iIndex:integer;
 s:string;
begin
 slBuf.Clear;
 for i:= 0 to Checklistbox2.Count-1 do
  if Checklistbox2.Checked[i] then Checklistbox2.Checked[i] := false;
 for i:= 0 to Checklistbox1.Count-1 do
  slBuf.Add(Checklistbox1.Items[i]);  // slBuf.Add(Lowercase(Checklistbox1.Items[i]));
 //slBuf.Sorted := true; // Sort strings.
 for i:= 0 to Checklistbox2.Count-1 do
 begin
  s := Checklistbox2.Items[i];  // Lowercase(Checklistbox2.Items[i]);
  iIndex := BinSearch(slBuf, s, 0, slBuf.Count-1);
  if (iIndex >= 0) then
    Checklistbox2.Checked[i] := true;
 end;
 iCount := 0;
  for i:= 0 to Checklistbox2.Count-1 do
   if Checklistbox2.Checked[i] = true then
    Inc(iCount);
 Label1.Caption := Inttostr(iCount) + '/' + Inttostr(Checklistbox2.Count);
end;

function NaiveSearch(Strings: TStringList; SubStr: string): Integer;
var
 j:integer;
begin
 j := 0;
 Result := -1;
 repeat
 begin
  if SubStr = Strings[j] then
  begin
   Result := j;
   break;
  end;
 j := j+1;
 end;
 until j = Strings.Count;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
 i:integer;
begin
 for i:= 0 to Checklistbox1.Count-2 do
  if Checklistbox1.Items[i] < Checklistbox1.Items[i+1] then CheckListBox6.Items.Add('<');
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
i, iCount, iIndex:integer;
s:string;
begin
 for i:= 0 to Checklistbox3.Count-1 do
  if Checklistbox3.Checked[i] then Checklistbox3.Checked[i] := false;
for i:= 0 to Checklistbox1.Count-1 do
 slBuf.Add(Checklistbox1.Items[i]);  // slBuf.Add(Lowercase(Checklistbox1.Items[i]));
for i:= 0 to Checklistbox3.Count-1 do
begin
 s := Checklistbox3.Items[i];  // Lowercase(Checklistbox2.Items[i]);
 iIndex := NaiveSearch(slBuf, s);
 if (iIndex >= 0) then
   Checklistbox3.Checked[i] := true;
end;
iCount := 0;
for i:= 0 to Checklistbox3.Count-1 do
 if Checklistbox3.Checked[i] = true then
  Inc(iCount);
Label3.Caption := Inttostr(iCount) + '/' + Inttostr(Checklistbox3.Count);
{ CheckListBox6.Clear;
for i:= 0 to slBuf.Count-1 do
 CheckListBox6.Items.Add(slBuf[i]+ ':' + Inttostr(Length(slBuf[i]))); }
end;


procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  ClipBoard.SetTextBuf(Pchar(CheckListBox7.Items.Text));
end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 slBuf.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 slBuf := TStringList.Create;
end;


function LowercaseFirst(const s:string):string;
begin
 if s[1] in ['A'..'Z'] then
  result := Lowercase(s[1]) + rightstr(s, length(s)-1)
 else result := s;
end;

end.

