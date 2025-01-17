

video= load("jan/save/test28-Nov-2024/video_fast10.mat").video_fast;
tic
t=0.001*[video.t]; %in s
frames=reshape(double([video.original_depth]),360,640,[]);
frames_lq=frames(1:2:end,1:2:end,:);
% rotate the image if necessary
frames_lq=imrotate(frames_lq,0);
t_lq=t(1:end);

%treat frame used for ROIS...
disk=strel("disk",1);
frame=median(frames_lq(:,:,1:50),3);
frame=medfilt2(frame,[15 15],'symmetric');
frame=imclose(frame,disk);
frame(frame<0.5*median(frame(:)))=median(frame(:));%nothing is closer than 50cm
%define ROIS
imshow(frame,[])
width=length(frame(1,:));
g=gradient(frame(:,floor(width/2)));
% figure()
% plot(g)
prominence=0.5*max(abs(g));
gmax=islocalmax(g,'MinProminence',prominence,'MinSeparation',width/20,'FlatSelection','center');
gmin=islocalmin(g,'MinProminence',prominence,'MinSeparation',width/20,'FlatSelection','center');
% figure()
% plot(gmax);hold on;plot(gmin);
posmax=find(gmax>0);
posmin=find(gmin>0);
while posmin(1)<posmax(1) %primer hi ha un minim
    posmin=posmin(2:end);
end
while posmax(end)>posmin(end)
    posmax=posmax(1:end-1);
end
nrois=min(length(posmax),length(posmin));
posroi=round(0.5*(posmax(1:nrois)+posmin(1:nrois)));

%measure distances
% I=frame;
% dist=zeros(1,nrois-1);
% for i=1:nrois-1
%     P1=[posroi(i) width/2];
%     P2=[posroi(i+1) width/2];
%     dist(i)=measure_3d_dist(P1,P2,I);
% end
% de moment manual...
dist=(0.13);


filtered_lq=zeros(size(frames_lq));
left=zeros(2,length(frames_lq(1,1,:)));
buffersize=1;
buffer=zeros(size(frames_lq(:,:,1:buffersize)));
disk=strel('disk',3);
suma=zeros(nrois,length(t_lq));
sumaz=zeros(nrois,length(t_lq));
for i=1:length(t_lq)
    fmed=medfilt2(frames_lq(:,:,i),[15 15],'symmetric');
    filtered_lq(:,:,i)=fmed;
    buffer(:,:,1:end-1)=buffer(:,:,2:end);
    buffer(:,:,end)=fmed;
    avg=mean(buffer,3);
    dif=fmed-avg;
    dif=1*(abs(dif)>=50)+0*(abs(dif)<50);
    if i>buffersize
        difopen=imopen(dif,disk);
        suma(:,i)=sum(dif(posroi,:),2);
    end
    sumaz(:,i)=sum(and(fmed(posroi,:)>700,fmed(posroi,:)<800),2);
%     imshow(filtered_lq(:,:,i),[])
%     imshowpair((imopen(dif,disk)),fmed,'montage')
%     pause(0.1)
end
minProminence=0.7*min(max(suma,[],2));
maxrois=islocalmax(suma,2,"MinProminence",minProminence,"FlatSelection","first","MaxNumExtrema",2,'MinSeparation',10);

minProminencez=0.7*min(max(diff(sumaz')));
maxroisz=islocalmax(diff(sumaz'),"MinProminence",minProminencez,"FlatSelection","first","MaxNumExtrema",1,'MinSeparation',10);
minProminencez=0.7*min(max(-diff(sumaz')));
minroisz=islocalmax(diff(-sumaz'),'MinProminence',minProminencez,'FlatSelection','first','MaxNumExtrema',1,'MinSeparation',10);
d=diff(-sumaz');
% plot(d)

maxnframe0=find(maxroisz(:,nrois-1));
maxnframe1=find(maxroisz(:,nrois));
v0=dist*15/(maxnframe1-maxnframe0);
minnframe0=find(minroisz(:,1));
minnframe1=find(minroisz(:,2));
v1=dist*15/(minnframe1-minnframe0);
mvel=mean([v1 v0]);
L=4*dist+mvel*(t_lq(minnframe0)-t_lq(maxnframe1))
toc
% 
% for i=1:50
%     fmed=medfilt2(frames_lq(:,:,i),[15 15],'symmetric');
%     filtered_lq(:,:,i)=fmed;
%     buffer(:,:,1:end-1)=buffer(:,:,2:end);
%     buffer(:,:,end)=fmed;
%     avg=mean(buffer,3);
%     dif=fmed-avg;
%     dif=1*(abs(dif)>=50)+0*(abs(dif)<50);
%     dif=imopen(dif,disk);
%     imshow((imopen(dif,disk)))
%     pause(1/5)
% end
% 
% tic
% for i=1:nrois
%     frameroi=filtered_lq(posmax(i):posmin(i),:,:);
%     for j=1:50
%         imshow(frameroi(:,:,j),[])
%     end
%     pause(2/30)
% end
% toc