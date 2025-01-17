video= load("jan/save/test02-Dec-2024/video_fast4.mat").video_fast;
fps=video(1).fps;
t=0.001*[video.t]; %in s
N=length(   t);
frames=reshape(double([video.original_depth]),360,640,[]);
frames_lq=frames(1:2:end,1:2:end,:);
frames_lq=imrotate(frames_lq,-1);
filtered_lq=zeros(size(frames_lq));
for i=1:length(t)
    fmed=medfilt2(frames_lq(:,:,i),[10 10],'symmetric');
    filtered_lq(:,:,i)=fmed;
%     imshow(filtered_lq(:,:,i),[])
end
close all
% W=0.8;
% vmig=W/;
%set the width of the pallet manually

wroi=[80:140,180:240];
hroi=[30,135];
roiframes=reshape(filtered_lq(hroi,wroi,:),[],N)';
maskinvalid=(roiframes==0)|(roiframes<650)|(roiframes>1000);
roiframes(maskinvalid)=1000;
roiframes=1000-roiframes;
r1=roiframes(:,1:2:121);
r2=roiframes(:,123:2:end-1);
r3=roiframes(:,2:2:122);
r4=roiframes(:,124:2:end);

r=median(r3,2);
precision=25;%2.5cm
H1=max(r);
H2=H1-122;
H3=H1-144;
edges=[0 H3-precision 0.5*(H3+H2) 0.5*(H2+H1) H1];
dr=discretize(r,edges,[0 H3 H2 H1]);
maxH1=islocalmax(dr==H1,'FlatSelection','first')+islocalmax(dr==H1,'FlatSelection','last');
v=0.2;
W=v*(find(maxH1,1,"last")-find(maxH1,1,"first"))/fps;
plot(find(maxH1),H1,'rx')
hold on
plot(r)
% maxr1=islocalmax(gradient(median(r1,2)),'maxnUMExtrema',3);
% minr1=islocalmax(medr1.*gradient(-median(r1,2)),'MaxNumExtrema',3);
% 
% medr1=median(r1,2);
% valposmin=max(medr1(minr1));
% posmin=find(medr1==valposmin);
% 
% Wmeasured=58;
% 
% H1=260;H2=140;
% W=55;w1=10;w2=floor(0.5*(W-3*w1));
% ideal=zeros(1,(N));
% offset=floor((N-W)/2);
% ideal(offset:W+offset)=H1;
% ideal([offset+w1:offset+w1+w2,offset+w1*2+w2:offset+w1*2+w2*2])=H2;
% corr1=zeros(N,N*2-1);
% corr2=zeros(N,N*2-1);
% corr3=zeros(N,N*2-1);
% corr4=zeros(N,2*N-1);
% 
% 
% id=ideal-mean(ideal);
% rf1=r1-mean(r1);
% rf2=r2-mean(r2);
% rf3=r3-mean(r3);
% rf4=r4-mean(r4);
% for i=1:61
%     corr1(i,:)=xcorr(id,rf1(:,i)');
%     corr2(i,:)=xcorr(id,rf2(:,i)');
%     corr3(i,:)=xcorr(id,rf3(:,i)');
%     corr4(i,:)=xcorr(id,rf4(:,i)');
% end


% posroi=100*ones(2,320/16);
% posroi(2,:)=1:320/20:320;
% % posroi=[100 90;100 214];
% for i=1:length(posroi)
%     roi=medfilt1(reshape(frames_lq(posroi(1,i),posroi(2,i),:),[],N),10);
%     if or(median(roi)<700,max(roi)<900)
%         roi=roi*0;
% %         ideal=0;
%     else
%         roi=max(roi)-roi;
%         roi=medfilt1(roi);
%         g=gradient(roi);
%         gmax=(islocalmax(g,'MinProminence',0.75*max(g),'MinSeparation',10));
%         gmin=(islocalmax(-g,'MinProminence',0.75*max(-g),'MinSeparation',10));
%         pgmax=find(gmax);
%         pgmin=find(gmin);
%         wt=pgmin(end)-pgmax(1);
%         w1=floor(wt/8);
%         w2=floor(wt/3.52);
%         w3=floor(wt/5.51);
% %         ideal=zeros(1,(wt+1));
% %         ideal(2:(1+2*w1+w3+2*w2))=277;
% %         ideal(2+w1:1+w1+w2)=157;
% %         ideal(2+w1+w3+w2:1+w1+w3+2*w2)=157;
%     end
%     figure(1)
%     subplot(3,1,1)
%     plot(roi)
%     hold on
%     subplot(3,1,2)
%     plot(ideal)
%     hold on
%     subplot(3,1,3)
% %     plot(xcorr(ideal-mean(ideal),roi-mean(roi)))
%     figure(2)
%     hold on
%     r=zeros(1,length(roi)-length(ideal)+1);
%     for d=0:length(roi)-length(ideal)
%         r(d+1)=fcorr(roi(1+d:length(ideal)+d),ideal);
%     end
%     plot(r)
% end
%     