{Calculate factorial}
read n;
fact := 1;
for i := 1 to n
  fact := fact * i
enddo;
write fact
