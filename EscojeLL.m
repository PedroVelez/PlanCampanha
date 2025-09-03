function [x,y]=EscojeLL(nP);
[X,Y]=ginput(nP);
[x,y]=m_xy2ll(X,Y);
m_plot(x,y,'or-');
for i1=1:nP
    fprintf('%1s;%7.5f;%7.5f;1\n ',num2str(i1),x(i1),y(i1))
end
return