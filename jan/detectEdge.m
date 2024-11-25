function detectEdge(img)
% close all;
% img=load("images7_11_24\imgdist3.mat");
% img=img.imgdist;
%% pipeline=connectDepth();
% for i=1:5
%     fs=pipeline.wait_for_frames();
% end
% depth_frame = fs.get_depth_frame();    
% 
% % % %     // Get the depth frame's dimensions
% height = depth_frame.get_height();
% width=depth_frame.get_width();
% % % %     // Query the distance from the camera to the object in the center of the image
% img=reshape(depth_frame.get_data()',[width,height]);
%% 
% Retallem la part en negre per defecte!
img=img(50:end-10,10:end-10);
% Filter the image to close the black dots and reduce noise
imgclosed=imclose(img,strel('disk',5));
I=medfilt2(imgclosed,[20 20],'symmetric');

IBW=edge(I,'canny');
[H,T,R]=hough(IBW);
P  = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(IBW,T,R,P,'FillGap',5,'MinLength',7);

figure(10),imshow(I,[]),hold on
xy = [lines(1).point1; lines(1).point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% plot beginnings and ends of lines
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
hold off;

I=imrotate(I,90+lines(1).theta);
if mod(lines(1).theta,90)-45<0
    hcrop=find(I(:,3)>0,1);
    wcrop=length(I(1,:))-find(I(3,end:-1:1)>0,1);
end
if mod(lines(1).theta,90)-45>0
    hcrop=find(I(end:-1:1,3)>0,1);
    wcrop=length(I(1,:))-find(I(3,:)>0,1);
end
I=I(hcrop:end-hcrop,end-wcrop:wcrop);
Iscaled=uint8(255*double(I)./double(max(I(:))));
rgbI=repmat(Iscaled,1,1,3);
wpos=zeros(1,3*100);wneg=wpos;w=1;p=1;
upcorner=-1.*ones(1,200);botcorner=upcorner;c=1;
position=zeros(100,2);
index=1:5:length(I(1,:));
for i=1:5:length(I(1,:))
    window=double(I(:,i));
    x=gradient(window);
    xm=medfilt1(x,10);
    xmpos=xm.*(xm>0);
    xmneg=xm.*(xm<0);
    maxpos=(islocalmax(xmpos,'MinSeparation',50,'MinProminence',0.4*max(xmpos),'MaxNumExtrema',3));
    maxneg=(islocalmin(xmneg,'MinSeparation',50,'MinProminence',abs(0.4*min(xmneg)),'MaxNumExtrema',3));
    maxposf=find(maxpos);maxnegf=find(maxneg);
    if isempty(maxposf)
        maxposf=1;
    end
    if isempty(maxnegf)
        maxnegf=1;
    end
    wpos(w:w+length(maxposf)-1)=maxposf;
    wneg(w:w+length(maxnegf)-1)=maxnegf;

    upcorner(c)=wneg(w);
    botcorner(c)=wpos(w+length(maxnegf)-1);

    l=length(maxposf)+length(maxnegf);
    position(p:p+l-1,:)=[ ones(l,1)*i [maxposf;maxnegf]];
    w=w+length(maxposf);
    p=p+l;
    c=c+1;
%     plot(maxpos);hold on
%     plot(maxneg);
end
upcorner=upcorner(upcorner>=0);
botcorner=botcorner(botcorner>=0);
index=index(1:min(length(upcorner),length(botcorner)));
maskup=abs(upcorner-median(upcorner))<0.35*median(upcorner);
maskbot=abs(botcorner-median(botcorner))<0.35*median(botcorner);
validupcorner=upcorner.*maskup+0.*(~maskup);
validbotcorner=botcorner.*maskbot+0.*(~maskbot);
validindex=index(and(validbotcorner>0,validupcorner>0));

validupcorner=validupcorner(and(maskup,maskbot));
validbotcorner=validbotcorner(and(maskup,maskbot));

% up=insertMarker(rgbI,[index' botcorner'],"circle","Size",1,"Color","green");
% upgreen=up(:,:,2);
% upgreen=upgreen==max(upgreen);
% upgreen=imclose(upgreen,strel('disk',10));
% upgreenedge=edge(upgreen,'canny');
% figure(10), imshow(up,[]), hold on
% [H,T,R]=hough(upgreenedge);
% P  = houghpeaks(H,1);
% lines = houghlines(upgreenedge,T,R,P);
% xy = [lines(1).point1; lines(1).point2];
% plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% % plot beginnings and ends of lines
% plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
% plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% hold off;

figure(1)
imshow(insertMarker(rgbI,[index' upcorner'],"Size",10,"Color","green"),[])
figure(2)
imshow(insertMarker(rgbI,[index' botcorner'],"Size",10,"Color","green"),[])
figure(3)
imshow(insertMarker(rgbI,[validindex' validupcorner'],"Size",10,"Color","green"),[])
figure(4)
imshow(insertMarker(rgbI,[validindex' validbotcorner'],"Size",10,"Color","green"),[])
hold off;
widthPalet=-1*ones(1,100);j=1;
for i=1:length(validindex)
    
    widthPalet(j)=measure({validindex(i),validupcorner(i)},{validindex(i),validbotcorner(i)},I);
    j=j+1;
end
widthP=median(widthPalet(widthPalet>=0));
fprintf('Palet width= %.2f cm\n',widthP*100)

% heightPalet1=measure({validindex(1),validupcorner(1)},{validindex(end),validupcorner(end)},I);
% heightPalet2=measure({validindex(1),validbotcorner(1)},{validindex(end),validbotcorner(end)},I);
% heightP=(heightPalet1+heightPalet2)/2;
% fprintf('Palet height= %.2f cm\n',heightP*100)
end
