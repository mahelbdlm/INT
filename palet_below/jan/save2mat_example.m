pause(2);   % you've got x seconds to get ready, hurry!

% fileName=save2matfast(file_path,15);

vidmat=load("jan\save\testfinal_sensellum\pallet_bo_eur\video_fast1.mat");
fileName="jan\save\testfinal_sensellum\pallet_bo_eur\video_fast1";
vidmat=vidmat.video_fast;
vidWriterVision(vd,"original_depth",15,fileName +"_od",".avi")
t=0.001*[vidmat.t];
plot(t)
%si no és una recta és que no hem respectat fps!!! 
%palet raro fa 100x120
ylabel('mm','FontSize',15,'Rotation',90)