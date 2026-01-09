{Comprehensive test: GCD calculation using Euclidean algorithm}
read a;
read b;

{Ensure both numbers are positive}
if a < 0 then
  a := 0 - a
end;
if b < 0 then
  b := 0 - b
end;

{Calculate GCD}
while b <> 0 do
  temp := a % b;
  a := b;
  b := temp
enddo;

{Output result}
write a
