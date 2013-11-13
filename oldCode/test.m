plot_op = 0;

%Get Data from file
display('Loading Data...')
Data = load('testData/giant wells_Rh590Cl 1nM.out');
S = length(Data);

display('Done!')

%Generate the shift times.
Max = 200;
dt = 1e-8;
Data = round((1./dt)*Data)*dt;
tv = zeros(Max,1);
tv(1) = dt;

for k = 1:Max-1
    tv(k+1) = tv(k) + dt*2^floor(k/10);
end

cv = zeros(size(tv));

%Start the Timer:
display('Processing Data...') 
tic

for k = 1:length(tv)
    i = 1; j = 1; count = 0;
    while (i<S)&&(j<S)
        while (Data(i)<=Data(j)+tv(k))&&(i<S)
            if Data(i)==Data(j)+tv(k)
                count = count + 1;
            end
            i = i+1;
        end
        while (Data(j)+tv(k)<=Data(i))&&(j<S)
            if Data(i)==Data(j)+tv(k)
                count = count + 1;
            end
            j = j+1;
        end
    end
    cv(k) = count;
end
toc

if plot_op == 1
    plot(log10(tv),cv*dt)
    title('Log10(lagtime) vs. count')
end
    
       
            