% main method
close all;

% run parameters
%size = 640;
size = 448;
%size = 256;
rCounter = 0;
bCounter = 0.2;

setGlobalSize(size);
setGlobalClickBool(false);
nbElements = 65;
pixFilepath = 'T:\Users\libpub\Documents\MATLAB\LPs\';

% init variables
mainCanvas = canvas(size, nbElements, pixFilepath);
imgFrames = {};

f = figure;
set(f, 'Color', 'black');
set(f,'WindowButtonDownFcn',@mouseclickedcallback);
set(f, 'Pointer', 'crosshair');
pan off;

% display gui
while(true)
    
    rCounter = rCounter + 0.01;
    bCounter = bCounter + 0.02;
    mainCanvas.repaint(rCounter, bCounter);
    imshow(mainCanvas.viewWindow, 'Border', 'tight');
    
    if (getGlobalClickBool == true)
        mainCanvas.checkClick();
        setGlobalClickBool(false);
    end
    
end

% 
% if exist('output.avi'), delete output.avi; end
% aviObject = VideoWriter('output.avi');
% aviObject.FrameRate = 80;
% open(aviObject);
% 
% nImages = length(imgFrames);
% disp('WRITING FRAMES TO AVI');
% for i = 1:nImages
%     disp(i);
%     writeVideo(aviObject, imgFrames{i});
% end
% 
% close(aviObject); 