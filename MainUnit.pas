unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.StdCtrls, Vcl.ExtDlgs;

type
  TIPhone_XS_Max = class(TForm)
    imgIPhone: TImage;
    btnOpenFile: TButton;
    OpenFile: TOpenTextFileDialog;
    lblOtnocit_velichina: TLabel;
    lblMaxNesting: TLabel;
    gridOperators: TStringGrid;
    procedure btnOpenFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IPhone_XS_Max: TIPhone_XS_Max;

implementation

{$R *.dfm}

uses
  Math;

type
  AdrOperators = ^Operators;

  AdrOperands = ^Operands;

  Operators = record
    Operation: string[50];
    Number: Integer;
    AdrNext: AdrOperators;
  end;

  Operands = record
    Operand: string[50];
    Number: Integer;
    AdrNext: AdrOperands;
  end;

var
  Adr1Operators, AdrCurOperators: AdrOperators;
  Adr1Operands, AdrCurOperands: AdrOperands;
  F, Code: TextFile;
  i, j, nesting, maxNesting, numOperands, numOperators, totalOperands, totalOperators, if_counter, do_counter, number_of_if: Integer;
  s: string;
  arr: array of Char;
  ch: Char;
  arr_2, useless: array of string;
  flag: Boolean;

procedure TIPhone_XS_Max.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Halt;
end;

procedure TIPhone_XS_Max.FormCreate(Sender: TObject);
begin
  gridOperators.Cells[0, 0] := 'Opers';
  gridOperators.Cells[1, 0] := 'Num';
  gridOperators.Cells[2, 0] := 'CL';
  gridOperators.Cells[3, 0] := 'Num';
end;

procedure TIPhone_XS_Max.btnOpenFileClick(Sender: TObject);
begin
  New(Adr1Operators);
  New(Adr1Operands);
  AdrCurOperators := Adr1Operators;
  AdrCurOperands := Adr1Operands;
  AdrCurOperators^.AdrNext := nil;
  AdrCurOperands^.AdrNext := nil;
  if_counter := 0;
  do_counter := 0;

 // if OpenFile.Execute then
 // begin

  AssignFile(Code, 'E:\Метрология\Laba 2\Jilbs-Metric\Code.txt');
  AssignFile(F, 'E:\Метрология\Laba 2\Jilbs-Metric\Operators.txt');
  Reset(F);
  while not Eof(F) do
  begin
    New(AdrCurOperators^.AdrNext);
    AdrCurOperators := AdrCurOperators^.AdrNext;
    Readln(F, AdrCurOperators^.Operation);
    AdrCurOperators^.AdrNext := nil;
  end;
  CloseFile(F);

  AssignFile(F, 'E:\Метрология\Laba 2\Jilbs-Metric\Useless.txt');
  Reset(F);
  i := 0;
  while not Eof(F) do
  begin
    SetLength(useless, i + 1);
    Readln(F, useless[i]);
    Inc(i);
  end;
  CloseFile(F);

  Reset(Code);
  i := 0;
  while not Eof(Code) do
  begin
    SetLength(arr, i + 1);
    Read(Code, ch);
    if (ch = '[') or (ch = '(') or (ch = ':') or ((ch >= #33) and (ch <= #47) and (ch <> '''') and (ch <> '"')) then
    begin
      SetLength(arr, i + 2);
      arr[i] := ' ';
      Inc(i);
      arr[i] := ch;
      Inc(i);
      arr[i] := ' ';
    end
    else if (ch <> #$A) and (ch <> #$D) and (ch <> #0) then
      arr[i] := ch;
    Inc(i);
  end;
  CloseFile(Code);
  i := 0;
  j := 0;
  s := '';

  while i < Length(arr) do
  begin
    while (arr[i] <> ' ') and (arr[i] <> ']') and (arr[i] <> '}') and (arr[i] <> ')') and (arr[i] <> #0) do
    begin
      s := s + arr[i];
      if (arr[i] = '+') and (arr[i + 1] = '+') then
      begin
        SetLength(arr_2, j + 1);
        arr_2[j] := '++';
        Inc(j);
        if s[Length(s)] = '+' then
          Delete(s, Length(s), 1);
        Inc(i);
      end
      else if (arr[i] = '-') and (arr[i + 1] = '-') then
      begin
        SetLength(arr_2, j + 1);
        arr_2[j] := '--';
        Inc(j);
        if s[Length(s)] = '-' then
          Delete(s, Length(s), 1);
        Inc(i);
      end;
      Inc(i);
    end;

    if (Length(s) > 0) and (s <> #0#0) and (s <> #0) then
    begin
      if s[Length(s)] = ';' then
      begin
        SetLength(arr_2, j + 1);
        arr_2[j] := ';';
        Inc(j);
        Delete(s, Length(s), 1);
      end;
      if (Length(s) > 0) then
      begin
        SetLength(arr_2, j + 1);
        arr_2[j] := s;
        Inc(j);
        s := '';
      end;
    end
    else
      Inc(i);
    s := '';
    if arr[i] = '}' then
    begin
      SetLength(arr_2, j + 1);
      arr_2[j] := arr[i];
      inc(j);
    end;
  end;

  i := 0;
  while i < length(arr_2) do
  begin
    arr_2[i] := Trim(arr_2[i]);
    if arr_2[i] = 'else' then
      Inc(if_counter);
    INC(I);
  end;
  i := 0;
  while i < length(arr_2) do
  begin
    if arr_2[i] = 'do' then
      Inc(do_counter);
    INC(I);
  end;
  i := 0;
  while i < length(arr_2) do
  begin
    if (arr_2[i] = 'while') and (do_counter <> 0) then
    begin
      arr_2[i] := 'do..' + arr_2[i];
      Dec(do_counter);
    end;
    INC(I);
  end;
  i := 0;
  while i < length(arr_2) do
  begin
    if (arr_2[i] = 'if') and (if_counter <> 0) then
    begin
      arr_2[i] := arr_2[i] + '..else';
      Dec(if_counter);
    end;
    INC(I);
  end;
  i := 0;

  while i < Length(arr_2) do
  begin
    AdrCurOperators := Adr1Operators;
    flag := True;

    while AdrCurOperators^.AdrNext <> nil do
    begin
      AdrCurOperators := AdrCurOperators^.AdrNext;
      if AdrCurOperators^.Operation = arr_2[i] then
      begin
        Inc(AdrCurOperators^.Number);
        flag := False;
      end;
      if (arr_2[i] = 'function') then
      begin
        AdrCurOperators := Adr1Operators;
        while AdrCurOperators^.AdrNext <> nil do
          AdrCurOperators := AdrCurOperators^.AdrNext;
        New(AdrCurOperators^.AdrNext);
        AdrCurOperators := AdrCurOperators^.AdrNext;
        AdrCurOperators^.Operation := arr_2[i + 1];
        AdrCurOperators^.Number := 1;
        AdrCurOperators^.AdrNext := nil;
        inc(i);
        flag := False;
      end;
    end;
    if flag then
    begin
      AdrCurOperands := Adr1Operands;
      flag := True;
      while AdrCurOperands^.AdrNext <> nil do
      begin
        AdrCurOperands := AdrCurOperands^.AdrNext;
        if AdrCurOperands^.Operand = arr_2[i] then
        begin
          Inc(AdrCurOperands^.Number);
          flag := False;
        end;
      end;

      if flag then
      begin
        New(AdrCurOperands^.AdrNext);
        AdrCurOperands := AdrCurOperands^.AdrNext;
        AdrCurOperands^.Operand := arr_2[i];
        AdrCurOperands^.Number := 1;
        AdrCurOperands^.AdrNext := nil;
      end;
    end;
    Inc(i);
  end;

  nesting := 0;
  maxNesting := 0;
  for i := 0 to Length(arr_2) - 1 do
  begin
    if (arr_2[i] = 'if') or (arr_2[i] = 'do..while') or (arr_2[i] = 'if..else') or (arr_2[i] = 'for') or (arr_2[i] = 'while') then
      inc(nesting);
    if nesting > maxNesting then
      maxNesting := nesting;
    if arr_2[i] = '}' then
      Dec(nesting);
  end;

  totalOperands := 0;
  numOperands := 0;
  totalOperators := 0;
  numOperators := 0;
  i := 1;
  AdrCurOperators := Adr1Operators;
  flag := True;
  number_of_if := 0;
  while AdrCurOperators^.AdrNext <> nil do
  begin
    AdrCurOperators := AdrCurOperators^.AdrNext;
    if (AdrCurOperators^.Number <> 0) and (AdrCurOperators^.Operation <> '}') then
    begin
      if (AdrCurOperators^.Operation = 'if') or (AdrCurOperators^.Operation = 'if..else') or (AdrCurOperators^.Operation = 'do..while') or (AdrCurOperators^.Operation = 'while') or (AdrCurOperators^.Operation = 'for') or (AdrCurOperators^.Operation = 'switch') then
        number_of_if := number_of_if + AdrCurOperators^.Number;
      if (AdrCurOperators^.Operation = '(') and (flag) then
      begin
        gridOperators.Cells[0, i] := '()';
        gridOperators.Cells[1, i] := IntToStr(AdrCurOperators^.Number);
        gridOperators.RowCount := gridOperators.RowCount + 1;
        flag := False;
        Inc(i);
        Inc(totalOperators);
        numOperators := numOperators + AdrCurOperators^.Number;
      end
      else if AdrCurOperators^.Operation = '[' then
      begin
        gridOperators.Cells[0, i] := '[]';
        gridOperators.Cells[1, i] := IntToStr(AdrCurOperators^.Number);
        gridOperators.RowCount := gridOperators.RowCount + 1;
        Inc(i);
        Inc(totalOperators);
        numOperators := numOperators + AdrCurOperators^.Number;
      end
      else if AdrCurOperators^.Operation = '{' then
      begin
        gridOperators.Cells[0, i] := '{}';
        gridOperators.Cells[1, i] := IntToStr(AdrCurOperators^.Number);
        gridOperators.RowCount := gridOperators.RowCount + 1;
        Inc(i);
        Inc(totalOperators);
        numOperators := numOperators + AdrCurOperators^.Number;
      end
      else if AdrCurOperators^.Operation <> '(' then
      begin
        gridOperators.Cells[0, i] := (AdrCurOperators^.Operation);
        gridOperators.Cells[1, i] := IntToStr(AdrCurOperators^.Number);
        gridOperators.RowCount := gridOperators.RowCount + 1;
        Inc(i);
        Inc(totalOperators);
        numOperators := numOperators + AdrCurOperators^.Number;
      end;
    end;
  end;

  gridOperators.Cells[1, i] := IntToStr(numOperators);
  gridOperators.Cells[3, i] := IntToStr(number_of_if);
  lblOtnocit_velichina.Caption := lblOtnocit_velichina.Caption + FloatToStr(number_of_if / numOperators);
  lblMaxNesting.Caption := lblMaxNesting.Caption + IntToStr(maxNesting);

  i := 1;
  AdrCurOperators := Adr1Operators;
  while AdrCurOperators^.AdrNext <> nil do
  begin
    AdrCurOperators := AdrCurOperators^.AdrNext;
    if (AdrCurOperators^.Number <> 0) then
    begin
      if (AdrCurOperators^.Operation = 'if') or (AdrCurOperators^.Operation = 'if..else') or (AdrCurOperators^.Operation = 'do..while') or (AdrCurOperators^.Operation = 'while') or (AdrCurOperators^.Operation = 'for') or (AdrCurOperators^.Operation = 'switch') then
      begin
        gridOperators.Cells[2, i] := (AdrCurOperators^.Operation);
        gridOperators.Cells[3, i] := IntToStr(AdrCurOperators^.Number);
      end;
    end;
  end;


  j := 1;
  AdrCurOperands := Adr1Operands;
  while AdrCurOperands^.AdrNext <> nil do
  begin
    AdrCurOperands := AdrCurOperands^.AdrNext;
    flag := true;
    for i := 0 to Length(useless) - 1 do
    begin
      if useless[i] = AdrCurOperands^.Operand then
        flag := false;
    end;
    if flag then
    begin
      numOperands := numOperands + AdrCurOperands^.Number;
      inc(totalOperands);
      inc(j);
    end;
  end;

 // end;
end;

end.

