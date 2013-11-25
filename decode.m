function [symbols]=decode(trailofbits,magic,depth)

b=0;symbols=[];foundother=0;

while b<length(trailofbits)

posgo=depth+1;found=0;
rgo=char(magic{depth+1});

    while found==0 && foundother==0
    
        b=b+1;
        posstart=posgo;
        bit=trailofbits(b);    
        if bit==1 
            posgo=posstart-1;       
            while isempty(strfind(rgo,char(magic{posgo,1})))    
                posgo=posgo-1;                
            end;
            rgo=char(magic{posgo,1});
        end;
        if bit==0        
            posgo=posstart-1;        
            while isempty(strfind(rgo,char(magic{posgo,3})))    
                posgo=posgo-1;
            end;
            rgo=char(magic{posgo,3});
        end;
        
        if length(rgo)==1; found=1; end;
        if length(rgo)>1 && b==length(trailofbits) && isempty(symbols)==1; fprintf('ôßðïôá ðñïò åêôýðùóç \n'); foundother=1; symbols=[]; end;
        if length(rgo)>1 && b==length(trailofbits) && isempty(symbols)==0; fprintf('åìöáíßóôçêå ðñüâëçìá, áëëÜ Ýãéíå ìåñéêÞ áðïêùäéêïðïßçóç \n'); foundother=1;        
        end;
        
    end;
    if foundother~=1; symbols=[symbols rgo]; end;

end;


end
