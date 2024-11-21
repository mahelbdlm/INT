function vidWriterVision(video_struct,frame_field,fps,fileName,format)
    for i=1:length(frame_field)
        videoColorFWriter=vision.VideoFileWriter(fileName+"_"+frame_field(i)+format,'FrameRate',fps);
        videoColorFWriter.VideoCompressor="DV Video Encoder";
       
        for j=1:length(video_struct)
            frame=video_struct(j).(frame_field(i));
            videoColorFWriter(frame);
        end
    
        release(videoColorFWriter);
    end
end
