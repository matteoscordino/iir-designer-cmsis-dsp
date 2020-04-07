% @author Matteo Scordino
% @date 2018-08-04
% @version 1.0.0
% 
% @brief M file to design a lowpass Butterworth filter and get the coefficients for CMSIS DSP
% 

function design_iir_lowpass_cmsis_butter(requested_order, f1, fs, plot_results)
order = requested_order;
% Nyquist frequency, for convenience
fNyquist=fs/2;
% design filter in zeros, poles, gain format
[z,p,k] = butter(order, f1/fNyquist, 'low');
% convert it to the second order sections (used for biquads) format
[sos] = zp2sos(z,p,k);

% compute biquad coefficients
coeffs = sos(:,[1 2 3 5 6]);
% negate a1 and a2 coeffs (CMSIS expects them negated)
coeffs(:,4) = -coeffs(:,4);
coeffs(:,5) = -coeffs(:,5);

% make a linear array of it
coeffs = coeffs';
coeffs = coeffs(:);

if (plot_results == true)
	%plot the frequency response, just for human reference
	% (we need to redesign the filter in b,a format)
	[b,a] = butter(order,f1/fNyquist, 'low');
	[h, w] = freqz (b,a);
	figure(1)
	plot (w./pi, 20*log10 (abs (h)), ";;")
	xlabel ("Frequency");
	ylabel ("abs(H[w])[dB]");
	axis ([0, 1, -40, 0]);
	hold ("on");
	x=ones (1, length (h));
	hold ("off");

	% plot the filtered result of 3 sample sines
	data=[[1;zeros(fs-1,1)],[ones(fs,1)],sinetone(f1/2,fs,1,1),sinetone(f1,fs,1,1),sinetone(f1*2,fs,1,1)];
	filtered = filter(b,a,data);
	figure(2)
	clf
	subplot ( columns ( filtered ), 1, 1)
	plot(filtered(:,1),";Impulse response;")	
	subplot ( columns ( filtered ), 1, 2)
	plot(filtered(:,2),";DC response;")
	subplot ( columns ( filtered ), 1, 3 )
	plot(filtered(:,3),";f1/2 Hz response;")
	subplot ( columns ( filtered ), 1, 4 )
	plot(filtered(:,4),";f1 response;")
	subplot ( columns ( filtered ), 1, 5 )
	plot(filtered(:,5),";f1*2 response;")
endif

% print the coefficients as expected by CMSIS
coeffs
endfunction
