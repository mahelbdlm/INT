% Show list o webcams:
% webcamlist
% Select webcam: 
cam = webcam("Intel(R) RealSense(TM) Depth Camera 435i RGB");

% Take a snapshot

while ishandle(gca) % Loop until the figure is closed
    img = snapshot(cam); % Capture a snapshot from the webcam
    imshow(img); % Display the image
    pause(0.1); % Pause for a brief moment to control the frame rate
end