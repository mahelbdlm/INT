close all;
video= load("jan/save/testfinal_sensellum/america2.mat").video_fast;
tic
fps=video(1).fps;
t=0.001*[video.t]; %in s
frames=reshape(double([video.original_depth]),360,640,[]);
% I=medfilt2(frames(1:4:end,1:4:end,10),[10 10],'symmetric');
% BW = edge(I,'canny');
% [H,T,R] = hough(BW);
% P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
%  
% % Find lines and plot them
% lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
% figure, imshow(I,[]), hold on
% max_len = 0;
% for k = 1:length(lines)
%      xy = [lines(k).point1; lines(k).point2];
%      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end
% angles=[lines.theta];
% angle_valid=-90+abs(median(angles(abs(angles)>45)));
% frames=imrotate(frames,angle_valid);
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
wroi=[190:5:230];
hroi=[75 90];
figure
imshow(filtered_lq(:,:,100),[])
hold on
plot(wroi,hroi(1),'rx')
plot(wroi,hroi(2),'bx')
roiframes=reshape(filtered_lq(hroi,wroi,:),[],N)';
maskinvalid=(roiframes==0)|(roiframes<650)|(roiframes>1000);
roiframes(maskinvalid)=1000;
roiframes=1000-roiframes;
r1=roiframes(:,1:2:end);
r2=roiframes(:,2:2:end);

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
    plot(t(localmaxdr==1),H1,'rx')
    hold on
    plot(t,dr)
    ax=gca;
    grid on
    ax.YTick=values;
    ax.XTick=t(localmaxdr==1);
    xlabel("t (s)",'FontSize',13)
    ylabel("dist (mm)",'fontsize',15)
    i=i+1;
end

%% Result
v=0.07*fps./((find(maxH1(2,:)==1)-find(maxH1(1,:)==1)));
figure
plot(v)
hold on
p1=yline(mean(v),'r--');
p2=yline(median(v),'b-.');
ylabel("v (m/s)")
ax=gca;
ax.XAxis.Visible='off';
legend('median speed','mean speed')
W=mean(v)*(mean([find(maxH1(1,:),1,"last")-find(maxH1(1,:),1,'first'),find(maxH1(2,:),1,"last")-find(maxH1(2,:),1,'first')]))/fps;
disp("Estimated Width(mean(v))= "+W*100+" cm")
W=median(v)*(mean([find(maxH1(1,:),1,"last")-find(maxH1(1,:),1,'first'),find(maxH1(2,:),1,"last")-find(maxH1(2,:),1,'first')]))/fps;
disp("Estimated Width(median(v))= "+W*100+" cm")
toc