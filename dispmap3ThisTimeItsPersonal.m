function [ dispmap ] = dispmap3ThisTimeItsPersonal( leftI, rightI )
%DISPMAP3THISTIMEITSPERSONAL Summary of this function goes here
%   Detailed explanation goes here

%right = imread('C:\Users\Fraser\Desktop\pentagon_right.bmp');
%left = imread('C:\Users\Fraser\Desktop\pentagon_left.bmp');

%leftI = mean(left,3);
%rightI = mean(right,3);

dispmap = zeros(size(leftI),'single');

windowSize = 50;

halfSampleSize = 4;
sampleSize = 2 * halfSampleSize+1;

[h, w] = size(leftI);

for m = 1:h
   minr = max(1, m - halfSampleSize);
   maxr = min(h, m + halfSampleSize);
   
   for n = 1:w
      minc = max(1, n-halfSampleSize);
      maxc = min(w, n+halfSampleSize);
      
      %mind = max(-windowSize, 1-minc);
      mind=0;
      maxd = min(windowSize, w-maxc);
      
      sampleA = rightI(minr:maxr , minc:maxc);
      numBlocks = maxd - mind + 1;
      
      SADs = zeros(numBlocks,1);
      
      for i = mind : maxd
          sampleB = leftI(minr:maxr, (minc+i):(maxc+i));
          blockIndex = i-mind+1;
          SADs(blockIndex, 1) = sum(sum(abs(sampleA-sampleB)));
      end
      
      [temp, sorted] = sort(SADs);
      bestMatchIndex = sorted(1,1);
      d = bestMatchIndex + mind - 1;
      
      if ((bestMatchIndex == 1) || (bestMatchIndex == numBlocks))
          dispmap(m,n)=d;
      else
          C1=SADs(bestMatchIndex-1);
          C2=SADs(bestMatchIndex);
          C3=SADs(bestMatchIndex+1);
          dispmap(m,n) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
      end
   end
end

%imshow(dispmap);

end

