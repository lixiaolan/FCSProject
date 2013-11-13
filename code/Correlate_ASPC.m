%%%%%%%%%%%%%%%%%%%%%%[Author: Leland J. Jefferis]%%%%%%%%%%%%%%%%%%%%%%%%%
% INTRODUCTION:
% This function performs autocorrelation on time-tagged single photon
% counting data and is based on the paper "Fast calculation of fluorescence
% correlation data with asynchronous time-correlated single-photon
% counting" (Wahl et. al.).  The details of implementation may be found in
% the associated document Correlate_FCS_TC.pdf.
% 
% PARAMETERS:
% time-tagged single photon counting data is an increasing sequence of
% arrival times which are all integer multiples of some minimal detectable
% unit of time "dt".  This code allows the user to specify "dt" so as to
% round the input data to this minimal unit dt.  Practically speaking, dt
% is the minimum lag time the algorithm will use.
%
% Once dt is specified, the lag times tau_j are generated as follows:
%
%       tau_1 = 1*dt
%       tau_j = tau_(j-1)+2^floor( (j-1)/B )*dt for j = 2... ncasc*B
%
% where B and ncasc are integers.  B is the inverse rate of exponential
% growth of the lag times tau_j whereas ncasc is the number of "cascades"
% of lag times.  A cascade of lag times is a sequence of length B with
% even spacing between them.  Practically speaking, increasing B increases
% the density of chosen lag times whereas increasing ncasc increases the
% maximal lag time used (B = 10, ncasc = 20 appears to work well for a
% first attempt).
%
% SUMMARY:
% dt    - Minimum lag time
% B     - Inverse exponential growth rate of lag times (size of each cascade)
% ncasc - Number of cascades
% file  - The path to the desired data set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [timeVecOut,countVec] = Correlate_ASPC(file)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters: (described above) %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dt = 1e-8; B = 10; ncasc = 20;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Get Data from file %
    %%%%%%%%%%%%%%%%%%%%%%
    display('Loading Data...')
    Data = load(file);
    display('Done!')
    L = length(Data);     %Length of data set (used for normalization)
    T = Data(end);        %Total time of the experiment (last arrival time)  
    Data = floor( (1./dt)*Data );%Floor out the data.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate the shift times %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    jmax = B*ncasc;
    timeVec = zeros(jmax,1);
    timeVec(1) = 1;
    for k = 1:jmax-1
        timeVec(k+1) = timeVec(k) + 2^floor(k/B);
    end
    
    %%%%%%%%%%%%%%%%%%%%%
    % Begin the looping %
    %%%%%%%%%%%%%%%%%%%%%
    display('Processing Data...')
    tic %Start the Timer
    countVec = zeros(size(timeVec));
    timeVecOut = zeros(size(timeVec));
    index = 1;
    for a = 1:ncasc;
        for b = 1:B;
            i = 1; j = 1; count = 0;
            while 1
                if i >= L, break, end;
                
                while (Data(i)<Data(j)+timeVec(index))&&(i+1<=L)
                    i = i+1;
                end
                
                if j >= L, break, end;

                while (j<=L)&&(Data(j)+timeVec(index)<=Data(i))
                    if Data(i)==Data(j)+timeVec(index)
                        
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

                        count = count + (w1)*(w2);
                    end
                    j = j+1;
                end
            end
            timeVecOut(index) = timeVec(index)*2^(a-1);
            countVec(index) = (count/(2^floor( (index-1)/B ) ) );
            index = index + 1;
        end
        Data = floor( (Data/2) );
        timeVec = floor( (timeVec/2) );
    end
    display('Done!');
    toc %stop the timer
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Scale and format the output %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    countVec = countVec*T/(dt*L^2)-1;
    timeVecOut = timeVecOut*dt;
end
       
            