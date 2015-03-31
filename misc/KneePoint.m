function idx = KneePoint(points, t)
% find the knee point of given SORTed points, from largest to smallest.
% according to the paper: 
%    Big-Align: Fast Bipartite Graph Alignment
%
% The knee occurs when the slope fo aline segment is less than 5% of the 
% previous segment
%
% input: 
%     points  -- sorted from largest to smallest;
%     t       -- time of smooth, t =2 is recommended.
% output:
%     idx     -- knee pints;
%
%

%smooth
for i = 1:t
    points = smooth(points);
end

%% normalize the curve to unit square
points = points / (points(1) - points(end));

%c= zeros(length(points),1);

if length(points) < 3
   idx = 2;
else
    for i = 2:length(points)-1
       %c(i)=((points(i-1) - points(i)))/(points(i) - points(i+1));
       if (points(i) - points(i+1)) < 0.05*(points(i-1) - points(i)) 
            idx = i;
            break;
        end
    end
end

%figure, plot(c,'b');
%hold on;
%plot(points,'r')

end