% Compute the probability density function of the price S(T)
% Inputs :
% volSurf : volatility surface data
% T: time to expiry of the option
% Ks: vector of strikes
% Output :
% pdf: vector of pdf(Ks)
function pdf = getPdf (volSurf , T, Ks)
    %% input check
    assert(T>0, "PDF is undefined when T <= 0!");
    %% We are going to apply Richardson again to cdf
    h = 1e-4; 
    % will oscillate or even overflow once below some certain level
    for i = 1:2
        eval(['cdf_',num2str(i),'hp = getCdf (volSurf, T, Ks(Ks>2*h)+i*h);']);
        eval(['cdf_',num2str(i),'hm = getCdf (volSurf, T, Ks(Ks>2*h)-i*h);']);
    end
    
    %cdf_1hp = getCdf (volSurf, T, Ks(Ks>2*h)+h);
    %cdf_1hm = getCdf (volSurf, T, Ks(Ks>2*h)-h);
    %cdf_2hp = getCdf (volSurf, T, Ks(Ks>2*h)+2*h);
    %cdf_2hm = getCdf (volSurf, T, Ks(Ks>2*h)-2*h);
    
    % apply Richardson to nonzero strikes
    pdf(Ks>02*h) = 2/3/h*(cdf_1hp-cdf_1hm)-1/12/h*(cdf_2hp-cdf_2hm);
    % apply forward derivative to close-to-zero strikes
    pdf(Ks<=2*h) = (getCdf (volSurf, T, h*ones(size(Ks(Ks<=2*h))))-...
        (getCdf (volSurf, T, Ks(Ks<=2*h))))/h;
end