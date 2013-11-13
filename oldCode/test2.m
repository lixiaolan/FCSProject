%Get Data from file
load testData.out;
format long;
S = length(testData);

%Generate the shift times.
Max = 300;
dt = 1e-10;
tv = zeros(Max,1);
tv(1) = dt;

for k = 1:Max-1
    tv(k+1) = tv(k) + (1e-10)*2^floor(k/10.0);
end

cv = zeros(size(tv));

%Start the Timer:
tic

for k = 1:length(tv)
    i = 1; j = 1; count = 0;
    t = tv(k);
    di = testData(1);
    dj = testData(1)+t;
    while (1)
        if (di < dj)
            i = i + 1;
            if (i > S) 
                break;
            end
            di = testData(i);
        elseif (di > dj)
            j = j + 1;
            if (j > S) 
                break;
            end
            dj = testData(j) + t;
        else
            count = count + 1;
            i = i + 1;
            if (i > S) 
                break;
            end
            di = testData(i);
        end
    end
    cv(k) = count;
end
toc