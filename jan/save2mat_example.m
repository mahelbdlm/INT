pause(5);   % you've got 3 seconds to get ready, hurry!
file_path="jan/save/test"+date;

fileName=save2matfast(file_path,15);
vidmat=load(fileName);
vidmat=vidmat.video_fast;
vidWriterVision(vidmat,"colorized_depth",15,fileName,".avi")
t=0.001*[vidmat.t];
plot(t)
%si no és una recta és que no hem respectat fps!!! 
%palet raro fa 100x120