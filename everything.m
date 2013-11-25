function [CR,bestCR,bits_huff,bits_no_huff,entr_bits,percentofentropy,yfinal,coder,magic,targets] = everything(resolution,originalother,coderinput,p,ynew,optimal)

[targets,coder,magic,sum]=allhuff(originalother,p,coderinput,resolution);
disp(sprintf('decoding stage:%s', targets));

for i=1:length(targets)

    ind=find(targets(i)==originalother);
    yfinal(i)=optimal(ind(1));
    
end;

entr_bits=0;
for i=1:length(originalother)

    entr_bits=entr_bits+p(i)*log2(1/p(i));

end;

% ta bits einai upologismena sto sunolo tou mhnumatos
entr_bits=entr_bits*length(ynew);
bits_no_huff=length(ynew)*resolution;
bits_huff=sum;

percentofentropy=bits_huff/entr_bits*100;

CR=bits_huff/bits_no_huff;

bestCR=entr_bits/bits_no_huff;

end



