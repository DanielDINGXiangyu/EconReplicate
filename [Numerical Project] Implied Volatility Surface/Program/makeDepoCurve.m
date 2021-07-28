% Inputs:
% ts: array of size N containing times to settlement in years
% dfs: array of size N discount factors
% Output:
% curve: a struct containing data needed by getRateIntegral
function [ curve ] = makeDepoCurve(ts ,dfs)
    %% input check
    if size(ts) ~= size(dfs)
        error("Input invalid. Please check!");
    end
    %% apply bootstrapping
    % we apply the bootstrapping to obtain piecewise constant (average)
    % interest rate in each time interval
    % exp(r1*T1)*exp(r12*(T2-T1)) = exp(r2*T2) ¡ª¡ª> r12 = (r2*T2-r1*T1)/(T2-T1)
    dts = diff(ts); % calculate difference between time grid point
    TR = -log(dfs); % calculate total interest up to each time grid point
    IR = TR./ts; % convert discount factor to interest rate (continuously)
    numerator = diff(IR.*ts); % calculate the numerator in the formula
    IR_boot = numerator./dts; % calculate the piecewise constant IR
    curve(:,1) = [0;ts];
    curve(:,2) = [0;IR(1);IR_boot];
    curve(:,3) = [0;TR];
end

