function [magic,depth,coder] = huff(N_symbols,symbols,p,original)

magic=[];[B, IX] = sort(p,'descend');
sum=0;depth=0;coder=[];

while single(sum)<1 
   depth=depth+1; 
   if depth==1
       make=[symbols(IX(end-1)) 1 symbols(IX(end)) 0 depth];   symbolsprin=0;
   else 
       if length(IX)>1    
           if IX(end-1)>IX(end)  
               make=[symbolsprin(IX(end)) 1 symbolsprin(IX(end-1)) 0 depth];   
           else
               make=[symbolsprin(IX(end-1)) 1 symbolsprin(IX(end)) 0 depth];
           end;   
       end;
   end;
   magic=[magic ; make];
   
       if length(IX)>1
            newsymbol=[symbols(IX(end-1)) symbols(IX(end))];   newsymbol=[newsymbol{:}];  
       end;
       
   if depth==1    symbols=[symbols(IX(1:end-2)) newsymbol];
   else     
    symbols=[symbolsprin(IX(1:end-2)) newsymbol]; 
   end;  
   if length(B)>1   
       B=[B(1:end-2) B(end-1)+B(end)];
   end;
   [B, IX] = sort(B,'descend');   if length(B)>1   sum=B(end-1)+B(end);   symbolsprin=symbols;   end;   
end;

depth=depth+1;   
make=[symbols(IX(end-1)) 1 symbols(IX(end)) 0 depth];  
magic=[magic ; make];
z=[magic{end,1} magic{end,3}];
make=[cellstr(z) 'p' cellstr(magic{end,3}) 'p' 'end'];
magic=[magic ; make];
     
for i=1:N_symbols
       d=depth;
       while d>0     
        A=num2str(original(i));
        k=ismember(A,char(magic(d,1)));  
        if k==1 string(i,depth-d+1)=1;    
        else   
            k=ismember(A,char(magic(d,3)));   
            if k==1;  string(i,depth-d+1)=0;
            else     string(i,depth-d+1)=2;          
            end;     
        end;  
        d=d-1;
       end;   
       help=string(i,:);  help=help(help~=2);
       if i==1       coder=cell({help});
       else coder=[coder ; cell({help})];
       end;         

end;

end

