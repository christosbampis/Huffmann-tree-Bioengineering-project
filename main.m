close all; clear all;clc;
pall=[];
color=['-b' '-g' '-r' '-c' '-m'];
res=[2,3,4,5,6,7,8];
l=length(res);
load ecg.mat;
CR=[];bestCR=[];
yfinalall=[];
y=data10(:,2)';
x=data10(:,1)';
ynewall=[];
start=40;
coderall=[];
o=[1 2 3 4 5 6 7];
v=40;

for k=o(1:end);

    names=1:2^res(k);
    originalother = char(start:start-1+2^res(k));
    if res(k)>6 originalother(94)=char(35);originalother(121)=char(36); end;
    
%   kbantish timwn sthn pio kontinh
    
    if res(k)==8
        
        blocks=round(length(y)/64);
        yfordct=y(1:64*blocks);
        xfordct=x(1:64*blocks);
        yfordct2d=reshape(yfordct,blocks,64);
        ydcted=blkproc(yfordct2d, [8 8], 'dct2');
        ydctedzigzag=blkproc(ydcted, [8 8], 'zigzag', v);
        ydctedzigzagintime=blkproc(ydctedzigzag, [8 8], 'idct2');  
        yout1=reshape(ydctedzigzagintime,1,[]);
        ynew=yout1;
        d=length(y)-length(ynew);
        ynew=[ynew y(end-d+1:end)];

        optimal=linspace(min(ynew),max(ynew),2^res(k));
        
        for i=1:(length(y))

        [s,index]=min(abs(ynew(i)-optimal));
        ynew(i)=optimal(index);

        end;
       
    ynewall=[ynewall; ynew];
    
%   occurency frequency in ecg signal 
    
    for i=1:2^res(k)

        w=find(optimal(i)==ynew);
        pithanothta(i)=length(w);

    end;
    
    p=pithanothta/length(y);
    pall=[pall;cell({p})];
    
%   encode-decode
    
    coderinput=[];
    for i=1:length(y)

        coderinput=[coderinput originalother(find(ynew(i)==optimal))];

    end;

    [CR(k),bestCR(k),bits_huff(k),bits_no_huff(k),entr_bits(k),percentofentropy(k),yfinal,coder,magic,t]=everything(res(k),originalother,coderinput,p,ynew,optimal);
   
    else
        
    optimal=linspace(min(y),max(y),2^res(k));
        
    for i=1:(length(y))

        [s,index]=min(abs(y(i)-optimal));
        ynew(i)=optimal(index);

    end;
       
    ynewall=[ynewall; ynew];
    
%   find probabilities in ecg signal
    
    for i=1:2^res(k)

        w=find(optimal(i)==ynew);
        pithanothta(i)=length(w);

    end;
    
    p=pithanothta/length(y);
    pall=[pall;cell({p})];
      
    coderinput=[];
    for i=1:length(y)

        coderinput=[coderinput originalother(find(ynew(i)==optimal))];

    end;

    [CR(k),bestCR(k),bits_huff(k),bits_no_huff(k),entr_bits(k),percentofentropy(k),yfinal,coder,magic,t]=everything(res(k),originalother,coderinput,p,ynew,optimal);

    end;
    
    sfalma=(ynew-y);
    PRD(k)=((sum(sfalma.^2)/(sum(y.^2)))^0.5)*100;

    sfalma=(yfinal-y);
    PRDcheck(k)=((sum(sfalma.^2)/(sum(y.^2)))^0.5)*100;

    yfinalall=[yfinalall; yfinal];
    coderall=[coderall; cell({coder})];

end;

figure;
plot(res(1:end),PRDcheck,'-*r');xlabel('bits'),ylabel('PRD %');
grid,title('PRD % vs resolution 2...8 bits');

figure;
hold on;
plot(res(1:end),CR,'-*r');xlabel('bits'),ylabel('CR');
plot(res(1:end),bestCR,'-*b');xlabel('bits'),ylabel('bestCR');
plot(res(1:end),ones(length(CR),1),'-*m');xlabel('bits'),ylabel('CR');
ylim([0 1.5]);
legend('CR','bestCR','oxi CR',3,'Location','BestOutside');
grid,title('CR, bestCR, oxi CR me resolution 2...8 bits');

figure();
hold on;
for i=1:length(ynew)-1
    plot([x(i)/freq (x(i)+0.5)/freq],[ynew(i) ynew(i)]);
    plot([(x(i)+0.5)/freq (x(i)+0.5)/freq],[ynew(i) ynew(i+1)]);
    plot([(x(i)+0.5)/freq x(i+1)/freq],[ynew(i+1) ynew(i+1)]);
end;
grid;
plot(x/freq,ynewall(7,:),'r');
plot(x/freq,y,'m');
title(' 8 bits');
ylabel('ECG amplitude (mV)'),xlabel('time (sec)');
hold off;

CRtotalof8=v*CR(end)/64;

% % originalother=char(65:90);
% % 
% % p=[0.08 0.015 0.03 0.04 0.13 0.02 0.015 0.06 0.065 0.005 0.005 0.035 0.03 0.07 0.08 0.02 0.0025 0.065 0.06 0.09 0.03 0.01 0.015 0.005 0.02 0.0025];
% % 
% % % N_symbols=5;
% % % originalother=char(65:65+N_symbols-1);
% % % p=[0.4 0.2 0.2 0.1 0.1];
% % 
% % coderinput=['E' 'I' 'R'];
% % 
% % [CR,coder,trailofbits,magic]=allhuff(originalother,p,coderinput);
