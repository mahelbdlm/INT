%Measuring distances between two points P1 and P2
function [dist12]=measure(P1,P2,I) %Pn are cells {wpos,hpos}
    width=640;height=480;
    I=double(I);
    [wpos1,hpos1]=P1{:};
    [wpos2,hpos2]=P2{:};
    dist1=I(hpos1,wpos1);
    dist2=I(hpos2,wpos2);
    B=50;%baseline = 50mm, distance between two cameras
    HFOV=75*pi/180;%Horitzontal field of view
    VFOV=62*pi/180;%Vertical field of view
    x1=-2*(wpos1-width/2)*(dist1*tan(HFOV/2)-B)/width;
    if(wpos1>=width/2)
        x1=-2*(wpos1-width/2)*(dist1*tan(HFOV/2))/width;
    end
    x2=2*(wpos2-width/2)*(dist2*tan(HFOV/2)-B)/width;
    if(wpos2>=width/2)
        x2=2*(wpos2-width/2)*(dist2*tan(HFOV/2))/width;
    end
    dist12x=(x1+x2)*HFOV/VFOV;
    dist12y=VFOV*2*(-dist1*(hpos1-height/2)+dist2*(hpos2-height/2))*tan(HFOV/2)/height/HFOV;
    dist12=hypot(hypot(dist12x,dist12y),abs((dist1)-(dist2)))/1000;%in meters!
end