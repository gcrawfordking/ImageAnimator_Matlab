% canvas object

classdef canvas < handle
    
    properties(SetObservable = true)
        size;
        nbElements;
        viewWindow;
        pixArr;
        bgImg;
        txtInfo;
        origBg;
    end
    
    
    methods
        % constructor
        function obj = canvas(size, nbElements, pixFilepath)
            obj.size = size;
            obj.nbElements = nbElements;
            obj.viewWindow =  uint8(zeros(size, size, 3));
            obj.origBg = imread('starsBackground.jpg');
            obj.bgImg = imread('starsBackground.jpg');
            obj.origBg = imresize(obj.origBg, [size size]);
            obj.bgImg = imresize(obj.bgImg, [size size]);
            obj.viewWindow = obj.bgImg;
            obj.pixArr = loadPix(obj, nbElements, pixFilepath);
            
            obj.txtInfo = 'LP_Info.txt';
        end
        
        %load picture elements
        function pixArr = loadPix(obj, nbElements, pixFilepath)
            pixArr = {};
            fid = fopen('LP_Info.txt', 'rt');
            tmp = textscan(fid, '%s', 'Delimiter', '\n');
            tmp = tmp{1};
            fclose(fid);
            
            for i = 1 : (nbElements + 2)
                file_name = dir(strcat(pixFilepath)); % image path
                img = imread(strcat(pixFilepath,file_name(i + 2).name));
                infoStr = strsplit(tmp{i}, ',');
                pixArr{i} = pictureElement(img, obj.size, infoStr{1}, infoStr{2}, infoStr{3});
            end
        end

        %repaint
        function obj = repaint(obj, rCounter, bCounter)
            
            % clear canvas of old data
              obj.bgImg(:, :, 1) = uint8(round(obj.origBg(:, :, 1) + sin(rCounter) .* obj.origBg(:, :, 1) / 4));
              obj.bgImg(:, :, 2) = uint8(round(obj.origBg(:, :, 2) + cos(bCounter) .* obj.origBg(:, :, 2) / 2));
              obj.bgImg(:, :, 3) = uint8(round(obj.origBg(:, :, 3) + (sin(rCounter) * cos(bCounter)) .* obj.origBg(:, :, 3)/ 2));
              obj.viewWindow = obj.bgImg;
            
            % for each picture element, update position and velocity, then write to canvas
            for k = 1:length(obj.pixArr)
               obj.pixArr{k}.moveElement();
              % disp([num2str(obj.pixArr{k}.x_min),' ', num2str(obj.pixArr{k}.x_max),' ', num2str(obj.pixArr{k}.y_min),' ', num2str(obj.pixArr{k}.y_max)]);
              if (obj.pixArr{k}.resizeBool == false)
               obj.viewWindow(obj.pixArr{k}.x_min : obj.pixArr{k}.x_max, obj.pixArr{k}.y_min : obj.pixArr{k}.y_max, 1 : 3) = obj.pixArr{k}.img;
              end
            end
            
           for k = 1:length(obj.pixArr)
              if (obj.pixArr{k}.resizeBool == true)
               obj.viewWindow(obj.pixArr{k}.x_min : obj.pixArr{k}.x_max, obj.pixArr{k}.y_min : obj.pixArr{k}.y_max, 1 : 3) = obj.pixArr{k}.img;
              end
           end
           
        end
        
        %check if object is clicked
        function obj = checkClick(obj)
            
            clickPos = getGlobalClickPos;
            disp(['You clicked Row:',num2str(clickPos(1)),', Col:',num2str(clickPos(2))]);
            % for each picture element, check if clicked
            for k = length(obj.pixArr):-1:1
                
                if (clickPos(2) > obj.pixArr{k}.y_min && clickPos(2) < obj.pixArr{k}.y_max && clickPos(1) > obj.pixArr{k}.x_min && clickPos(1) < obj.pixArr{k}.x_max)
                    
                    lpStr = strcat('Title: ', obj.pixArr{k}.lpname);
                    artistStr = strcat('Artist: ', obj.pixArr{k}.artist);
                    yearStr = strcat('Year: ', obj.pixArr{k}.year);
                    
                    msgStr = {lpStr; artistStr; yearStr};
                    msgbox(msgStr,'Vinyl LP','custom',obj.pixArr{k}.img);

                    break;
                end

               
               
            end
            
            
        end
        
        % getter for viewWindow
        function viewWindow = get.viewWindow(obj)
                 viewWindow = obj.viewWindow;
        end
    
    end


end
