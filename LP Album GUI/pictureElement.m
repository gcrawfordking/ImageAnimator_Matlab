% picture element object

classdef pictureElement < handle
    
    properties(SetObservable = true)
        origImg;
        img;
        canvasSize;
        imgSize;
        x_max;
        x_min;
        y_max;
        y_min;
        x_sign;
        y_sign;
        y_vel;
        x_vel;
        speedMod;
        resizeCounter;
        resizeBool;
        currSize;
        
        artist;
        lpname;
        year;
    end
    
    
    methods
        % constructor
        function obj = pictureElement(img, canvasSize, lpname, artist, year)
            obj.origImg = img;
            obj.img = img;
            obj.resizeCounter = round(rand * 700);
            obj.imgSize = (canvasSize / 8);
            
%           click info
            obj.lpname = lpname;
            obj.artist = artist;
            obj.year = year;
            
%           resize objects to variable sizes
            
            if (rand < 0.5)
            obj.currSize = obj.imgSize;
            obj.resizeBool = true;
            else
            obj.currSize = (obj.imgSize / 2);
            obj.resizeBool = false;
            end
            
            obj.canvasSize = canvasSize;
            obj = resize(obj);
            
            % random starting position
            randX = round((rand * (canvasSize - obj.currSize))) + 0.5 * obj.currSize;
            randY = round((rand * (canvasSize - obj.currSize))) + 0.5 * obj.currSize;
            
            obj.x_min = randX - 0.5 * obj.currSize + 1;
            obj.x_max = randX + 0.5 * obj.currSize;
            obj.y_min = randY - 0.5 * obj.currSize + 1;
            obj.y_max = randY + 0.5 * obj.currSize;
            
            % random starting direction
            if (rand < 0.5)
                     obj.x_sign = 1;
                else obj.x_sign = -1;
            end
            
             if (rand < 0.5)
                     obj.y_sign = 1;
                else obj.y_sign = -1;
             end
            
             % random starting speed
%              obj.y_vel = round(1 * rand) + 1;
%              obj.x_vel = round(1 * rand) + 1;
             obj.y_vel = 1;
             obj.x_vel = 1;
%              obj.speedMod = round(2 * rand) + 1;
            
        end
        
        % move position for repaint
                %function obj = moveElement(obj, frameCount)
        function obj = moveElement(obj)
        
            if (obj.resizeCounter > 0)
                
                    obj.resizeCounter = obj.resizeCounter - 1;    
                    obj.x_min = obj.x_min + ( obj.x_sign * obj.x_vel );
                    obj.x_max = obj.x_max + ( obj.x_sign * obj.x_vel );
                    obj.y_min = obj.y_min + ( obj.y_sign * obj.y_vel );
                    obj.y_max = obj.y_max + ( obj.y_sign * obj.y_vel );

                % edge detection and redirection
                if (obj.x_min <= 1)
                    obj.x_sign = obj.x_sign * -1;
                    if (rand > 0.75)
                        obj.y_sign = obj.y_sign * -1;
                    end
                    obj.x_min = 1;
                    obj.x_max = obj.currSize;
                end

                if (obj.y_min <= 1)
                    obj.y_sign = obj.y_sign * -1;
                    if (rand > 0.75)
                        obj.x_sign = obj.x_sign * -1;
                    end
                    obj.y_min = 1;
                    obj.y_max = obj.currSize;
                end

                if (obj.x_max >= obj.canvasSize)
                    obj.x_sign = obj.x_sign * -1;
                    if (rand > 0.7)
                        obj.y_sign = obj.y_sign * -1;
                    end
                    obj.x_max = obj.canvasSize;
                    obj.x_min = obj.x_max - obj.currSize + 1;
                end

                if (obj.y_max >= obj.canvasSize)
                    obj.y_sign = obj.y_sign * -1;
                    if (rand > 0.75)
                        obj.x_sign = obj.x_sign * -1;
                    end
                    obj.y_max = obj.canvasSize;
                    obj.y_min = obj.y_max - obj.currSize + 1;
                end
            end
                
                % object resizing  
            if (obj.resizeCounter == 0)
                
                %shrink object
                if(obj.resizeBool == true)
                    if (obj.currSize > obj.imgSize/2)
                        obj.currSize = obj.currSize - 1;
                        obj.img = imresize(obj.origImg, [obj.currSize obj.currSize]);
                        obj.x_max = obj.x_max - 1;
                        obj.y_max = obj.y_max - 1;
                    else
                        obj.resizeCounter = round(rand * 2000);
                        obj.resizeBool = false;
                    end
                end
                
                %grow object
                if(obj.resizeBool == false)    
                    
                    if (obj.currSize < obj.imgSize)
                        if(obj.x_max + 0.5 * obj.imgSize < obj.canvasSize) && (obj.y_max + 0.5 * obj.imgSize < obj.canvasSize)
                            obj.currSize = obj.currSize + 1;
                            obj.img = imresize(obj.origImg, [obj.currSize obj.currSize]);
                            obj.x_max = obj.x_max + 1;
                            obj.y_max = obj.y_max + 1;
                        else
                            obj.resizeCounter = 100;
                        end
                    else
                        obj.resizeCounter = round(rand * 1500);
                        obj.resizeBool = true;
                    end
                    
                end
            end
            
        end
        
        %resize
        function obj = resize(obj)
            obj.img = imresize(obj.img, [obj.currSize obj.currSize]);
        end
        
    end
    
end