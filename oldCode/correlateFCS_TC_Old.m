function [tv1,cv] = correlateFCS_TC_Old(file)
    %dt should be set to the smallest size in the alg..
    %dt = 2e-12;
    dt = 1e-9;
    %Set to 1 to plot the result.
    plot_op = 0;

    %Get Data from file
    display('Loading Data...')
    Data = load(file);
    display('Done!')
    
    L = length(Data);
    T = Data(end);
    
    %Generate the shift times.
    B = 10; %One over the exponential rate of growth.  Also the lenght of
            %each cascade of time steps.
    ncasc = 40; %Number of cascades.
    jmax = B*ncasc; %Number of times neede to have ncasc cascades of
                    %length B.
    Data = floor((1./dt)*Data)*dt;  %Floor out the data. I will only use
                                    %this for now until I implement the 
                                    %time corstening.
    %Creat vector of times.
    tv = zeros(jmax,1);
    tv(1) = dt;
    for k = 1:jmax-1
        tv(k+1) = tv(k) + dt*2^floor(k/B);
    end
    tv1 = tv;
    
    %Start the Timer:
    display('Processing Data...') 
    tic
    %Begin looping through the data.  This may be optimized later.
    
    cv = zeros(size(tv));
    k = 1;
    for a = 1:ncasc;
        for b = 1:B;
            i = 1; j = 1; count = 0;
            while (i<L)&&(j<L)
                while (Data(i)<=Data(j)+tv(k))&&(i<L)
                    if Data(i)==Data(j)+tv(k)
                        
                        w1 = 0;
                        while (Data(i) == Data(i+w1))&&(i+w1+1<L)
                            w1 = w1 + 1;
                        end
                        w2 = 0;
                        while (Data(j) == Data(j+w2))&&(j+w2<L)
                            w2 = w2 + 1;
                        end
                        
                        %count = count + w1*w2; %With weighting
                        count = count +1;  %With out weighting
                        i = i + w1;
                        j = j + w2;
                    end
                    i = i+1;
                end
                while (Data(j)+tv(k)<=Data(i))&&(j<L)
                    if Data(i)==Data(j)+tv(k)
                        
                        w1 = 0;
                        while (Data(i) == Data(i+w1))&&(i+w1<L)
                            w1 = w1 + 1;
                        end
                        
                        w2 = 0;
                        while (Data(j) == Data(j+w2))&&(j+w2+1<L)
                            w2 = w2 + 1;
                        end
                        
                        %count = count + w1*w2;  %With weighting
                        count = count +1;  %With out weighting
                        i = i + w1;
                        j = j + w2;
                        
                    end
                    j = j+1;
                end
            end
            cv(k) = count/(2^floor((k-1)/B)); %C1
            k = k + 1;
        end
        Data = floor( (1./dt)*(Data/2) )*dt;
        tv = floor( (1./dt)*(tv/2) )*dt;
        %for z = length(Data)-1:-1:1
        %    if ( Data(z)==Data(z+1) )
        %        wv(z) = wv(z)+wv(z+1);
        %        wv(z+1) = 0;
        %    end
        %end
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
       
            