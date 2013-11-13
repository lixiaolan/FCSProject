function [tv, cv] = binandcor(file)
    %Get Data from file
    display('Loading Data...')
    Data = load(file);
    L = length(Data);
    T = Data(end);
    
    display('Done!')
    [f, xout] = hist(Data, 20000000);
    dt = xout(2)-xout(1);
    tv = floor(exp( (1:100)/10) );
    avg = trapz(xout, f)/T;
    f = f - avg;
    
    cv = zeros(size(tv));
    for i = 1:length(tv)
        v1 = [f(tv(i)+1:end), zeros(1,tv(i))];
        v1 = v1.*f;
        cv(i) = trapz(xout, v1)/T;
        i
    end
    cv = cv/avg^2;
    tv = tv*dt;
end