function errors = LogPlotter_v1(plotConfiguration,logFormat,filePath) % working directory, filename, old/new format, plotLimits, plotFilters

%     fileName = "p6650121.log";
%     workingDir = pwd;
%     filePath = fullfile(workingDir,fileName);
%     logFormat = 1; % 1-new 0-old
%     disp(filePath);
%     filePath = "p6650121.log";
    fileName = strsplit(filePath,"\");
    fileName = fileName(end);
 
    % Open file
    fin = fopen(filePath);    
    
    % initiate table to add values - delete at the end -> logValues(1,:)=[]
    logValues =  table(-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, ...
            'VariableNames',["gc","st_secs","end_secs","depth","vbd_secs","pitch_secs","roll_secs","vbd_i","pitch_i","roll_i", ...
            "deltaVbd1","deltaVbd2","deltaVbd","vbdRate1","vbdRate2","vbdRate","deltaPitch","pitchRate","deltaRoll","rollRate", ...
            "vbd_volts","pitch_volts","roll_volts","vbd_errors","pitch_errors","roll_errors"]);
    
    % loop reading each line
    while true
        line = fgetl(fin);
        if ~ischar(line)
            break;
        end
    
        % store DIVE values (GC=1)
        if contains(line, "begin dive")
            %disp("...START DIVE...");
            while true
                line = fgetl(fin); % start reading in inner loop
                if contains(line, "end dive")
                    %disp("...DIVE FINISHED...");
                    break;
                end
    
                if startsWith(line,"$GC")    
                    a=get_values_v1(line, 1, logFormat);
    %                 logValues=[logValues;a;b]; % append values
                    logValues=[logValues;a];
    
                end
            end
        end
    
        % store APOGEE values (GC=2)
        if contains(line,"begin apogee")
            %disp("...APOGEE START...");
            line = fgetl(fin); % read only 1 line for apogee
            a=get_values_v1(line, 2, logFormat);
    %         logValues=[logValues;a;b]; % append values  
            logValues=[logValues;a];
            %disp("...APOGEE FINISHED...")
        end
    
        % store CLIMB values (GC=3)
        if contains(line, "begin climb")
            %disp("...START CLIMB...");
            while true
                line = fgetl(fin); % start reading in inner loop
                if contains(line, "end climb")
                    %disp("...CLIMB FINISHED...");
                    break;
                end
    
                if startsWith(line,"$GC")
                    a=get_values_v1(line, 3, logFormat);
    %                 logValues=[logValues;a;b]; % append values 
                    logValues=[logValues;a];
                end
            end
        end
        
        if contains(line, "$ERRORS,")
            errors = get_errors(line, logFormat);
        end

    end
    
    fclose(fin);
    
    % delete first row
    logValues(1,:)=[];
    
    plots(logValues,plotConfiguration,fileName);

end


