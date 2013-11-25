function [targetsall,coder,magic,sum] = allhuff(originalother,p,coderinput,resolution)

disp(sprintf('coding stage  :%s', coderinput));

N_symbols=length(originalother);

for i=1:N_symbols
    symbols(i)=cellstr(originalother(i));
end;

[magic,depth,coder]=huff(N_symbols,symbols,p,originalother);

allnodes=depth+N_symbols;

if resolution==2 || resolution==3 || resolution==4 || resolution==5
    
nodes(1)=cellstr(magic{depth+1,1});d=depth+1;

for i=2:2:allnodes

    paidi1=cellstr(magic{d-1,1});
    paidi2=cellstr(magic{d-1,3});
    
    if magic{d-1,2}==1; paidiaristera=paidi1;paidideksia=paidi2;
    else paidiaristera=paidi2;paidideksia=paidi1;
    end;
    
    nodes(i)=paidiaristera;
    nodes(i+1)=paidideksia;
    
    d=d-1;

end;

gonios=zeros(1,allnodes);gonios(1)=0;gonios(2)=1;gonios(3)=1;

for i=allnodes-1:-2:4
    
    foundsec=0;    poios=-1;    paidiaristera=char(nodes(i));
    paidideksia=char(nodes(i+1));    d=0;    indexprwths=-500;    
    while foundsec==0
        
        d=d+1;    
        if length(char(magic{d,1}))==length(paidiaristera)            
            if strfind(char(magic{d,1}),paidiaristera)           
            indexprwths=d;           
            end;           
        end;
        
        if length(char(magic{d,1}))~=length(paidiaristera)            
            if strfind(char(magic{d,1}),paidiaristera)
%             gonios o aristera            
            foundsec=1;poios=1; % 1 gia aristera sto poios           
            end;
        end;
        
        if length(char(magic{d,3}))~=length(paidiaristera) 
%             disp('mphke');
            if strfind(char(magic{d,3}),paidiaristera)
%             gonios o deksia
            foundsec=1;poios=0; % 0 gia deksia sto poios 
%             disp('mphke');
            end;
        
        end;           
        
    end;
    
    gonios(i)=allnodes-((d-1)*2+poios);gonios(i+1)=allnodes-((d-1)*2+poios);
    
end

end;

% epeksergasia eisodou - kwdikopoihsh auths

trailofbits=[];targetsall=[];sum=0;

for i=1:length(coderinput)

    index=find(originalother==coderinput(i));
    trailofbits=coder(index(1));
    trailofbits=[trailofbits{:}];
    targets=decode(trailofbits,magic,depth);
    targetsall=[targetsall targets];
    sum=sum+length(trailofbits);
   
end;

end

