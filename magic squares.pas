{ Построить матрицу NxN, в которой сумма элементов в каждой строке, в      }
{ столбце, в каждой диагонали (их 2) имеют одинаковую сумму.               }
{ Подсказка: такая сумма может быть определена заранее и равна             }
{            n*n(n*n+1) div (2*n)                                          }
{--------------------------------------------------------------------------}
const N=3; SQRN = N*N; {будет матрица NxN}
      IdealSum = N*(SQRN+1) div 2;
var   a:array[1..SQRN] of byte;
      b:array[1..SQRN] of byte;
      f:boolean; recurse:longint;
 
Procedure PRINT;
var i,j:integer;
begin
   assign(output,'magic.out'); rewrite(output);
   for i:=1 to N do begin
     for j:=1 to N do write(a[pred(i)*N+j],' ');
     writeln;
   end;
end;
 
function TestRow(i:integer):boolean;
var j,s:integer;
begin
    s:=0; i:=(i-1)*n;
    for j:=1 to N do s:=s+a[i+j];
    TestRow:=(s=IdealSum);
end;
 
function TestCol(i:integer):boolean;
var j,s:integer;
begin
    s:=0;
    for j:=1 to N do s:=s+a[(j-1)*N+i];
    TestCol:=(s=IdealSum);
end;
 
function TestDiag:boolean;
var j,s:integer;
begin
    s:=0;
    for j:=1 to N do s:=s+a[(N-j)*N+j];
    TestDiag:=(s=IdealSum);
end;
 
function TestMagic:boolean; {Тест всей матрицы на соотв. маг. квадрату}
var srow,scol,sdiag1,sdiag2,i,j:integer;
begin
    TestMagic:=FALSE;
    sdiag1:=0; sdiag2:=0;
    for i:=1 to N do begin
      srow:=0; scol:=0;
      for j:=1 to N do begin
         srow:=srow+a[pred(i)*N+j];
         scol:=scol+a[pred(j)*N+i];
      end;
      if (srow<>scol) or (scol<>IdealSum) then EXIT;
      sdiag1:=sdiag1+a[pred(i)*N+i];
      sdiag2:=sdiag2+a[(N-i)*N+i];
    end;
    if (sdiag1<>sdiag2) or (sdiag2<>IdealSum) then EXIT;
    TestMagic:=TRUE;
end;
 
procedure SqMagic(k:integer);
var i:integer; still:boolean;
begin
   i:=1;
   while (i<=SQRN) and NOT(f) do begin
      still:=true;
      if b[i]=0 then begin
        b[i]:=1; a[k]:=i;
        if k=SQRN then begin
           if TestMagic then begin PRINT; f:=true; still:=false; end;
        end else if (k mod n=0) then begin {если завершена строка}
           if NOT(TestRow(k div n)) then still:=false;
        end else if (k>SQRN-N) then begin  {если завершен столбец}
           if NOT(TestCol(k mod n)) then still:=false;
        end else if (k=SQRN-N+1) then begin {если завершена диагональ}
           if NOT(TestDiag) then still:=false;
        end;
        if still then SqMagic(k+1);
        b[i]:=0;
      end;
      inc(i);
   end;
end;
 
begin
     f:=false; recurse:=0;
     fillchar(a,sizeof(a),0); fillchar(b,sizeof(b),0);
     SqMagic(1);
end.