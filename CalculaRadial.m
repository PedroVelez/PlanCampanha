%Calculos en longitud
x=-13.3759; y=29.2106;
x0=-12.2848;y0=28.9796;


m=(y-y0)/(x-x0);
xf=linspace(x,x0,14);
yf=xf.*m-x0*m+y0;

for ii=1:length(yf)
       fprintf('%03d;%7.4f;%7.4f;1\n ',1000+ii-1,xf(ii),yf(ii))
end

plot(x,y,'sr');hold on
plot(x0,y0,'or');
plot(xf,yf,'ob-');

