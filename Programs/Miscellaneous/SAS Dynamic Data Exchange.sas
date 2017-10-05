options noxwait noxsync;

data _null_;
 rc=system('start excel');
run;

filename sastoxl dde "excel|system";

data _null_;
 x=sleep(5);
run;

data _null_;
 file sastoxl;
 put '[open("C:\Documents and Settings\tghosh\Desktop\temp.xls")]';
 put '[workbook.insert(1)]';
 put '[workbook.name("Sheet1","Temp4")]';
run;

