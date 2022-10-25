# Signal Processing (SP) project 7: Detecting slots of outliers via sliding RMS window
Detecting segments of noise or outliers via sliding RMS window.

# Credit
The dataset and proposal of the exercise is from the Udemy course [Signal Processing Problems, solved in Matlab and in Python](https://www.udemy.com/course/signal-processing/). I highly recommend this course for those interested in signal processing.

# Procedure
I already used in my previous [project](https://github.com/MariaGoniIba/SP6-Denoising-Spectral-Interpolation-downsampling) an sliding RMS window. 
They key parameter of this procedure is the percent window. But how to determine the appropriate percent window for computing the sliding RMS time series?
In this project I will loop the procedure previously shown in the previous [project](https://github.com/MariaGoniIba/SP6-Denoising-Spectral-Interpolation-downsampling) for several values and plot the RMS values according to window size.

First we generate a noisy signal with some burst of noise.
<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP7-Outlier-sliding-RMS-window/blob/main/Figure1-OriginalSignal.png">
</p>

Now, let's compute the RMS matrix for several percent windows.
```
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
imagesc(rmsmatrix)
```

I plot the window size in percentage (y) and time (x).  

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP7-Outlier-sliding-RMS-window/blob/main/Figure2-WindowSize-TIme.png">
</p>

This plot helps me identify an appropriate window in order to detect those windows of large variance. 
I choose a window of 1% and a threshold (_thresh_) of 10 after visual inspecting the following figure.

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP7-Outlier-sliding-RMS-window/blob/main/Figure3-Thresholding.png">
</p>

Finally, I mark the outlier region according to those values above that threshold.

```
signalR = signal;
signalR( rmsmatrix(1,:)>thresh ) = NaN;
```

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP7-Outlier-sliding-RMS-window/blob/main/Figure4-Result.png">
</p>
