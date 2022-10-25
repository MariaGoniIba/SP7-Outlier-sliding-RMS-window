clear; clc; close all

%% generate signal with varying variability
n = 2000;
p = 15; % poles for random interpolation

% amplitude modulator
signal = interp1(randn(p,1)*3,linspace(1,p,n),'pchip');
signal = signal + randn(1,n);

% add some high-amplitude noise
signal(200:220)   = signal(200:220) + randn(1,21)*9;
signal(1500:1600) = signal(1500:1600) + randn(1,101)*9;

% plot
figure(1), clf, hold on
plot(signal)
xlabel('Time')
title('Original signal', 'FontSize', 14)

%% detect bad segments using sliding RMS

rmsmatrix = [];
for i = 1:20
    % window size as percent of total signal length
    pct_win = i; % in percent, not proportion!
    
    % convert to indices
    k = round(n * (pct_win)/2/100);
      
    % initialize RMS time series vector
    rms_ts = zeros(1,n);
    
    for ti=1:n
        
        % boundary points
        low_bnd = max(1,ti-k);
        upp_bnd = min(n,ti+k);
        
        % signal segment (and mean-center!)
        tmpsig = signal(low_bnd:upp_bnd);
        tmpsig = tmpsig - mean(tmpsig);
        
        % compute RMS in this window
        rms_ts(ti) = sqrt(sum( tmpsig.^2 ));
    end
    rmsmatrix = [rmsmatrix; rms_ts];
    clear rms_ts
end

% plot RMS according to window size
figure(2)
imagesc(rmsmatrix)
axis('xy')
xlabel('Time','FontSize',14)
ylabel('Window size (%)','FontSize',14)

%% Choosing parameters based on the previous plot
% plot RMS
figure(3), clf, hold on
plot(rmsmatrix(1,:),'s-') % window

% pick threshold manually based on visual inspection
thresh = 10;
xlabel('Time', 'FontSize',12)
plot(get(gca,'xlim'),[1 1]*thresh,'r')
legend({'Local RMS';'Threshold'},'FontSize',12)

% mark bad regions in original time series
signalR = signal;
signalR( rmsmatrix(1,:)>thresh ) = NaN;

figure(4), clf, hold on
plot(signal,'b')
plot(signalR,'r')
legend({'Original';'Thresholded'},'FontSize',12)
