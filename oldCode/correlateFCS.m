function [tv,cv] = correlateFCS(file)
    %Set to 1 to plot the result.
    plot_op = 0;
    dt = 1e-6;
    %Get Data from file
    display('Loading Data...')
    Data = load(file);
    display('Done!')
    L = length(Data);
    T = Data(end);
    
    %Generate the shift times.
    B = 10; %One over the exponential rate of growth.  Also the lenght of
            %each cascade of time steps.
    ncasc = 20; %Number of cascades.
    jmax = B*ncasc; %Number of times neede to have ncasc cascades of
                    %length B.
    %dt = 1e-7;  %Minimum time interval detectable.
    Datatemp = Data;
    Data = round((1./dt)*Data)*dt;  %Floor out the data. I will only use
                                    %this for now until I implement the 
                                    %time corstening.
    
    length(Datatemp)/length(unique(Data))                             
    %Creat vector of times.
    tv = zeros(jmax,1);
    tv(1) = dt;
    for k = 1:jmax-1
        tv(k+1) = tv(k) + dt*2^floor(k/B);
    end
    
    %Start the Timer:
    display('Processing Data...') 
    tic
    %Begin looping through the data.  This may be optimized later.
    
    cv = zeros(size(tv));
    for k = 1:length(tv)
        i = 1; j = 1; count = 0;
        while (i<=L)&&(j<=L)
            while ( (i<=L)&&(Data(i)<=Data(j)+tv(k)) )
                if Data(i)==Data(j)+tv(k)
                    count = count + 1;
                end
                i = i+1;
            end
            while ( (i<=L)&&(j<=L)&&(Data(j)+tv(k)<=Data(i)) )
                if Data(i)==Data(j)+tv(k)
                    count = count + 1;
                end
                j = j+1;
            end
        end
        cv(k) = count;
    end
    display('Done!');
    toc
    cv = (cv*T)/(dt*L^2);
    %Print the result (if requested).
    if plot_op == 1
        plot(log10(tv),cv*dt)
        title('Log10(lagtime) vs. count')
    end
end
       
            