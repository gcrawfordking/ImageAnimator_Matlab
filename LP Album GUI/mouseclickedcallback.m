function mouseclickedcallback(src,~)

pos=get(src,'CurrentPoint');
size = getGlobalSize;
rowVal = size - pos(2) + 1;
colVal = pos(1);

%disp(['You clicked Col:',num2str(colVal),', Row:',num2str(rowVal)]);

setGlobalClickPos(rowVal, colVal);
setGlobalClickBool(true);

end

