close all;
video= load("jan/save/testfinal_sensellum/eur_bo_1.mat").video_fast;
tic
fps=video(1).fps;
t=0.001*[video.t]; %in s
frames=reshape(double([video.original_depth]),360,640,[]);

I=medfilt2(frames(1:4:end,1:4:end,10),[10 10],'symmetric');
% figure, imshow(I,[])

%% Pre processing
frames=imrotate(frames,0);
frames_lq=frames(1:2:end,1:2:end,:);
N=length(frames_lq(1,1,:));
filtered_lq=zeros(size(frames_lq));
% normalized_lq=zeros(size(frames_lq));
for i=1:N
    fmed=medfilt2(frames_lq(:,:,i),[10 10],'symmetric');
    filtered_lq(:,:,i)=fmed;
%     normalized_lq(:,:,i)=127*fmed/max(fmed(:));
%     imshow(normalized_lq(:,:,i))
end
% normalized_lq=int8(normalized_lq);

%% ROI declaration
wroi=[90:5:130,190:5:230];
hroi=90;
figure
imshow(filtered_lq(:,:,100),[])
hold on
plot(wroi,hroi(1),'rx')
roiframes=reshape(filtered_lq(hroi,wroi,:),[],N)';
maskinvalid=(roiframes==0)|(roiframes<650)|(roiframes>1000);
roiframes(maskinvalid)=1000;
roiframes=1000-roiframes;
r1=roiframes(:,1:end/2);
r2=roiframes(:,end/2+1:end);

%% Processing
mr1=median(r1,2);
mr2=median(r2,2);
figure
plot(t,mr1)
xlabel("t (s)",'FontSize',13)
ylabel("dist (mm)",'fontsize',15)
H1=max(mr1);
H2=H1-122;
H3=H1-144;
precision=25;%2.5cm
edges=[0 H3-precision 0.5*(H3+H2) 0.5*(H2+H1) H1];
ax=gca;
ax.YTick=edges;
ax.YGrid='on';
i=1;
p=[0 0];
maxH1=zeros(2,length(mr1));
posW=[0 0];
for r=[mr1,mr2]
    figure
    H1=max(r);
    H2=H1-122;
    H3=H1-144;
    edges=[0 H3-precision 0.5*(H3+H2) 0.5*(H2+H1) H1];
    values=[0,H3,H2,H1];
    dr=discretize(r,edges,values)';
    localmaxdr=islocalmax(dr==H1,'FlatSelection','first')+islocalmax(dr==H1,'FlatSelection','last');
    maxH1(i,:)=localmaxdr;
    
    posTop=find(localmaxdr);
    posCenterH1=round(0.5*(posTop(end)+posTop(1)));
    posLeftH2=round(0.5*(posTop(2)+posTop(3)));
    posRightH2=round(0.5*(posTop(end-2)+posTop(end-1)));
    hCenterH1=dr(posCenterH1);
    hLeftH2=dr(posLeftH2);
    hRightH2=dr(posRightH2);
    posW(i)=posTop(end)-posTop(1);

    plot(t(localmaxdr==1),H1,'rx')
    hold on
    plot(t,dr)
    plot([t(posCenterH1),t(posLeftH2),t(posRightH2)],[hCenterH1,hLeftH2,hRightH2],'*g')
    ax=gca;
    grid on
    ax.YTick=values;
    ax.XTick=t(localmaxdr==1);
    xlabel("t (s)",'FontSize',13)
    ylabel("dist (mm)",'fontsize',15)

    disp("Scan "+i+"/2")
    checkIntegrity_pass=true;
    if(hCenterH1~=H1)
        disp('Center Top H1 could be missing!')
        checkIntegrity_pass=false;
    end
    if(hLeftH2~=H2)
        disp('Left H2 could be missing!')
        checkIntegrity_pass=false;
    end
    if(hRightH2~=H2)
        disp('Right H2 could be missing!')
        checkIntegrity_pass=false;
    end
    if(checkIntegrity_pass==true)
        disp("Pallet integrity checked! It's a pass")
    else
        error("Pallet integrity check fail!")
    end
    i=i+1;
end
toc