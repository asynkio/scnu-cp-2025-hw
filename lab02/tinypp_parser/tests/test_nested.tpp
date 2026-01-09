{Test nested control structures}
read n;
if n > 0 then
  for i := 1 to n
    if i % 2 = 0 then
      write i
    end
  enddo
else
  while n < 0 do
    n += 1
  enddo
end
