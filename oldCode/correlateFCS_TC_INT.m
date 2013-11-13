function [tv1,cv] = correlateFCS_TC_INT(file)
    %dt should be set to the smallest size in the alg..
    dt = 1e-5;
    %dt = 1e-8;
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
    ncasc = 20; %Number of cascades.
    jmax = B*ncasc; %Number of times neede to have ncasc cascades of
                    %length B.
    Data = uint32(floor((1./dt)*Data) );  %Floor out the data. I will only use
                                    %this for now until I implement the 
                                    %time corstening.
    %Creat vector of times.
    tv = zeros(jmax,1);
    %start = 1e-6;
    tv(1) = 1;
    for k = 1:jmax-1
        tv(k+1) = tv(k) + 2^floor(k/B);
    end
    tv1 = tv*dt;
    %Start the Timer:
    display('Processing Data...') 
    tic
    %Begin looping through the data.  This may be optimized later.
    cv = zeros(size(tv));
    tv2 = zeros(size(tv));
    k = 1;
    for a = 1:ncasc;
        for b = 1:B;
            i = 1; j = 1; count = 0;
            while 1
                if i >= L, break, end;
                
                while (Data(i)<Data(j)+tv(k))&&(i+1<=L)
                    i = i+1;
                end
                
                if j >= L, break, end;

                while (j<=L)&&(Data(j)+tv(k)<=Data(i))
                    if Data(i)==Data(j)+tv(k)
                        w1 = 1;
                        while (i+w1<=L)&&(Data(i) == Data(i+w1))
                            w1 = w1 + 1;
                        end    
                        i = i + w1 - 1;
                        
                        w2 = 1;
                        while (j+w2<=L)&&(Data(j) == Data(j+w2))
                            w2 = w2 + 1;
                        end
                        j = j + w2 - 1;

                        count = count + (w1)*(w2); %With weighting
                        %count = count +1;  %With out weighting
                    end
                    j = j+1;
                end
            end
            tv2(k) = tv(k)*2^(a-1);
            %cv(k) = (count)*T/(dt*L^2); %C1
            cv(k) = (count/(2^floor((k-1)/B)))*T/(dt*L^2); %C1
            k = k + 1;
        end
        Data = uint32(floor((Data/2) ) );
        tv = floor( (tv/2) ) ;
    end
    %UData = unique(Data);
    %length(Data)/length(UData);
    display('Done!');
    toc    
    %Print the result (if requested).
    if plot_op == 1
        plot(log10(tv),cv*dt)
        title('Log10(lagtime) vs. count')
    end
    %tv2 = tv2*dt;
    cv = cv-1;
end
       
            