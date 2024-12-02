pause(3);   % you've got 3 seconds to get ready, hurry!
file_path="mahel/save/savejan1";

fileName=save2mat(file_path,5,'medfilt');
vidmat=load(fileName);
vidmat=vidmat.video;
vidWriterVision(vidmat,"color",vidmat(1).fps,fileName,".avi")
