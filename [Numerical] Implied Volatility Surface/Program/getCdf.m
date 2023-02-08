% Compute the cumulative density function of the price S(T)
% Inputs :
% volSurf : volatility surface data
% T: time to expiry of the option
% Ks: vector of strikes
% Output :
% cdf: vector of cdf(Ks)
function cdf = getCdf (volSurf , T, Ks)
    %% We are going to apply Richardson
    % set bump size
    % if h is chosen too small, then it will suffer from oscillations
    h = 1e-4; 
    
    % obtain forward price
    fwdCurve = volSurf.fwdCurve;
    fwd = getFwdSpot(fwdCurve,T);
    
    % obtain call price in neighborhood
    for i = 1:2
        eval(['us_',num2str(i),'hp = getBlackCall (fwd, T, Ks(Ks>2*h)+i*h , getVol(volSurf,T,Ks(Ks>2*h)+i*h));']);
        eval(['us_',num2str(i),'hm = getBlackCall (fwd, T, Ks(Ks>2*h)-i*h , getVol(volSurf,T,Ks(Ks>2*h)-i*h));']);
    end
    
    %us_1hp = getBlackCall (fwd, T, Ks(Ks>2*h)+h , getVol(volSurf,T,Ks(Ks>2*h)+h));
    %us_1hm = getBlackCall (fwd, T, Ks(Ks>2*h)-h , getVol(volSurf,T,Ks(Ks>2*h)-h));
    %us_2hp = getBlackCall (fwd, T, Ks(Ks>2*h)+2*h , getVol(volSurf,T,Ks(Ks>2*h)+2*h));
    %us_2hm = getBlackCall (fwd, T, Ks(Ks>2*h)-2*h , getVol(volSurf,T,Ks(Ks>2*h)-2*h));
    
    % apply Richardson for nonzero strikes
    cdf(Ks>2*h) = 2/3/h*(us_1hp-us_1hm)-1/12/h*(us_2hp-us_2hm)+1;
    % apply forward derivative for close-to-zero strikes
    cdf(Ks <= 2*h) = (getBlackCall(fwd,T,h*ones(size(Ks(Ks<=2*h))),getVol(volSurf,T,Ks(Ks<=2*h)+h))...
        -getBlackCall(fwd,T,zeros(size(Ks(Ks<=2*h))),getVol(volSurf,T,Ks(Ks<=2*h))))/h+1;
   
end