function plots(logValues,plotConfiguration,fileName)
%PLOTS plot tables


    % Plot limits
    %     % vbd y limits
    yvbdLeftMin = plotConfiguration.yvbdLeftMin;
    yvbdLeftMax = plotConfiguration.yvbdLeftMax;
    yvbdRightMin = plotConfiguration.yvbdRightMin;
    yvbdRightMax = plotConfiguration.yvbdRightMax;
    % pitch y limits
    ypitchLeftMin = plotConfiguration.ypitchLeftMin;
    ypitchLeftMax = plotConfiguration.ypitchLeftMax;
    ypitchRightMin = plotConfiguration.ypitchRightMin;
    ypitchRightMax = plotConfiguration.ypitchRightMax;
    % roll y limits
    yrollLeftMin = plotConfiguration.yrollLeftMin;
    yrollLeftMax = plotConfiguration.yrollLeftMax;
    yrollRightMin = plotConfiguration.yrollRightMin;
    yrollRightMax = plotConfiguration.yrollRightMax;

    % Value filters
    vbdMinTime = plotConfiguration.vbdMinTime;
    pitchMintime = plotConfiguration.pitchMintime;
    rollMinTime = plotConfiguration.rollMinTime;

    x = logValues.st_secs/60; % shared axis=time since start of dive
    xMin = min(logValues.st_secs)/60;
    xMax = max(logValues.st_secs)/60;


%     % vbd y limits
%     yvbdLeftMin = 0;
%     yvbdLeftMax = 6;
%     yvbdRightMin = 0;
%     yvbdRightMax = 20;
%     % pitch y limits
%     ypitchLeftMin = 0;
%     ypitchLeftMax = 1000;
%     ypitchRightMin = 0;
%     ypitchRightMax = 20;
%     % roll y limits
%     yrollLeftMin = 0;
%     yrollLeftMax = 1500;
%     yrollRightMin = 0;
%     yrollRightMax = 20;
% 
%     % Value filters
%     vbdMinTime = 0.01;
%     pitchMintime = 0.01;
%     rollMinTime = 0.01;
    % Plot Font size
    sz = 10;


    % create figure 

    figure('Name',string(fileName),'NumberTitle','off');    
    
    % VBD        
    subplot(3,1,1); %m-row,n-col,p-position    
    grid on

    % plot pot1
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate1(logValues.vbd_secs >= vbdMinTime)),"m:.",MarkerSize=10);
      
    % plot pot2
    hold on
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate2(logValues.vbd_secs >= vbdMinTime)),"c:.",MarkerSize=10);
        
    % plot pot average
    hold on
    plot(x(logValues.vbd_secs >= vbdMinTime),abs(logValues.vbdRate(logValues.vbd_secs >= vbdMinTime)),"k:.",MarkerSize=10);
    
    % plot vbd current
    hold on   
    plot(x(logValues.vbd_secs >= vbdMinTime),logValues.vbd_i(logValues.vbd_secs >= vbdMinTime),"b:.",MarkerSize=10);
    
    grid on
    xlim([xMin xMax]);
    ylim([yvbdLeftMin yvbdLeftMax]);
    ylabel(['{\color{black}Rate[AD/sec] \color{blue}Current [A]}'], FontSize=sz); 
% title(['\fontsize{16}black {\color{magenta}magenta ' '\color[rgb]{0 .5 .5}teal \color{red}red} black again'])    

    % Plot on second Y axis
    yyaxis right
    % plot vbd time
    area(x,logValues.vbd_secs,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r'); 
    hold on
    % plot vbd voltage    
    plot(x((logValues.vbd_secs >= vbdMinTime)),logValues.vbd_volts((logValues.vbd_secs >= vbdMinTime)),"r:.",MarkerSize=10);
    % plot depth
    hold on
    plot(x,logValues.depth/100,"g--");
    % plot errors
    hold on
    plot(x((logValues.vbd_errors > 0)),logValues.vbd_errors(logValues.vbd_errors > 0),"y*",MarkerSize=10);

    ylim([yvbdRightMin yvbdRightMax]);
%     ylabel("Time[s] Voltage[V] Depth[m]", FontSize=sz);
    ylabel(['{\color[rgb]{0.9608 0.6510 0.6510}Time[s] \color{red}Voltage[V] \color{green}Depth[m]}'], FontSize=sz);
    ax = gca;
    ax.YColor = 'r';

    legend("pot1","pot2", "pot average", "current", "time", "voltage", "depth/100", "errors");
    title("VBD");
    



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PITCH
    subplot(3,1,2);     
    grid on

    % plot pitch rate
    plot(x(logValues.pitch_secs >= pitchMintime),abs(logValues.pitchRate(logValues.pitch_secs >= pitchMintime)),"k:.",MarkerSize=10);
    hold on

    % plot pitch current mA 
    hold on
    plot(x(logValues.pitch_secs >= pitchMintime),logValues.pitch_i(logValues.pitch_secs >= pitchMintime)*1000,"b:.",MarkerSize=10);
    xlim([xMin xMax]);
    ylim([ypitchLeftMin ypitchLeftMax]);
    ylabel(['{\color{black}Rate[AD/sec] \color{blue}Current [mA]}'], FontSize=sz); 
    
    % plot pitch time
    yyaxis right
    area(x,logValues.pitch_secs * 10,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r');
    
    % plot pitch volts
    hold on
    plot(x(logValues.pitch_secs >= pitchMintime),logValues.pitch_volts(logValues.pitch_secs >= pitchMintime),"r:.",MarkerSize=10);

    % plot errors
    hold on
    plot(x((logValues.pitch_errors > 0)),logValues.pitch_errors(logValues.pitch_errors > 0),"y*",MarkerSize=10);
    
    ylim([ypitchRightMin ypitchRightMax]);
    ylabel(['{\color[rgb]{0.9608 0.6510 0.6510}Time[s] \color{red}Voltage[V]}'], FontSize=sz);
    ax = gca;
    ax.YColor = 'r';
    
    grid on

    legend("rate", "current", "time*10", "voltage", "errors");
    title("PITCH");
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ROLL
    subplot(3,1,3); 
    title("ROLL");
    grid on
    % plot roll rate
    plot(x(logValues.roll_secs >= rollMinTime),abs(logValues.rollRate(logValues.roll_secs >= rollMinTime)),"k:.",MarkerSize=10);
    
    % plot roll current mA
    hold on
    plot(x(logValues.roll_secs >= rollMinTime),logValues.roll_i(logValues.roll_secs >= rollMinTime)*1000*10,"b:.",MarkerSize=10);
    
    ylim([yrollLeftMin yrollLeftMax]);
    ylabel(['{\color{black}Rate[AD/sec] \color{blue}Current [mA]}'], FontSize=sz); 

    % plot roll time
    yyaxis right
    area(x,logValues.roll_secs,FaceAlpha=0.1,FaceColor='r',EdgeAlpha=0.1,EdgeColor='r');
    
    % plot pitch volts
    hold on
    plot(x(logValues.roll_secs >= rollMinTime),logValues.roll_volts(logValues.roll_secs >= rollMinTime),"r:.",MarkerSize=10);

    % plot errors
    hold on
    plot(x((logValues.roll_errors > 0)),logValues.roll_errors(logValues.roll_errors > 0),"y*",MarkerSize=10);
    
    ylim([yrollRightMin yrollRightMax]);
    ylabel(['{\color[rgb]{0.9608 0.6510 0.6510}Time[s] \color{red}Voltage[V]}'], FontSize=sz);
    ax = gca;
    ax.YColor = 'r';    

    xlim([xMin xMax]);
    grid on

    legend("rate", "current*10", "time", "voltage", "errors");
    title("ROLL");

end


