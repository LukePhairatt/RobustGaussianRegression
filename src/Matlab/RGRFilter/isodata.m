% Find a good threshold automatically, using the isodata algorithm (Ridler
% and Calvard 1978)
%
%	Example:
%		vImage = Image(:);
% 		[n xout]=hist(vImage, <nb_of_bins>);
% 		threshold = isodata(n, xout)
%
% Parameters: count and intensity are vectors, 
%				there are count(i) pixels of intensity(i)
%				(see "hist"	function)
function threshold = isodata(count, intensity)
T(1) = round(sum(count.*intensity) ./ sum(count));

delta = 1;	% initialisation before while loop
i=1;	%counter for the generations of T (threshold)
% the index of the threshold in the intensity list (T(i) is a threshold, not an index... it can be <0, for example.

while (delta ~= 0) && (i<15)
	% after the call to the "hist" function, the intensities are sorted
	% (ascending).
	T_indexes = find(intensity >= T(i));	
	T_i = T_indexes(1);	% finds the value (in "intensity") that is closest to the threshold.
	% calculate mean below current threshold: mbt
	mbt = sum(count(1:T_i) .* intensity(1:T_i) ) ./ sum(count(1:T_i));
	% calculate mean above current threshold: mat
	mat = sum(count(T_i:end) .* intensity(T_i:end) ) ./ sum(count(T_i:end));
	% the new threshold is the mean of mat and mbt
	i= i+1;
	T(i) = round( (mbt+mat)./2 );
	delta = T(i) - T(i-1);
end
threshold = T(i);


