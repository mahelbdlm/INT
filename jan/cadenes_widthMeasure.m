video= load("jan/save/test02-Dec-2024/video_fast2.mat").video_fast;
fps=video(1).fps;
t=0.001*[video.t]; %in s
frames=reshape(double([video.original_depth]),360,640,[]);
frames=imrotate(frames,-1);
frames_lq=frames(1:2:end,1:2:end,1:fps*15);
N=length(frames_lq(1,1,:));
filtered_lq=zeros(size(frames_lq));
for i=1:N
    fmed=medfilt2(frames_lq(:,:,i),[10 10],'symmetric');
    filtered_lq(:,:,i)=fmed;
    imshow(filtered_lq(:,:,i),[])
end
close all

wroi=90:5:130;
hroi=[90,110];
roiframes=reshape(filtered_lq(hroi,wroi,:),[],N)';
maskinvalid=(roiframes==0)|(roiframes<650)|(roiframes>1000);
roiframes(maskinvalid)=1000;
roiframes=1000-roiframes;
r1=roiframes(:,1:2:end);
r2=roiframes(:,2:2:end);


mr1=median(r1,2);
mr2=median(r2,2);
precision=25;%2.5cm
for r=[mr1,mr2]
    figure
    H1=max(r);
    H2=H1-122;
    H3=H1-144;
    edges=[0 H3-precision 0.5*(H3+H2) 0.5*(H2+H1) H1];
    values=[0,H3,H2,H1];
    dr=discretize(r,edges,values);
    maxH1=islocalmax(dr==H1,'FlatSelection','first')+islocalmax(dr==H1,'FlatSelection','last');
    v=0.3125;
    W=v*(find(maxH1,1,"last")-find(maxH1,1,"first"))/fps;
    plot(find(maxH1),H1,'rx')
    hold on
    plot(dr)
end