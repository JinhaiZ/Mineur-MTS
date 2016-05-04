function g_t=rrcosf(alpha,T,nech,Tmax);

t=[-Tmax:T/nech:Tmax];
if (alpha==0)
    g_t=sinc(t/T);
else
    for q=1:length(t),
        if (abs(abs(t(q))-T/(4*alpha))<1e-10)
            g_t(q)=(2*alpha/(pi*sqrt(T)))*sin(pi*(1-alpha)/(4*alpha))+(alpha/sqrt(T))*cos(pi*(1-alpha)/(4*alpha));
        else
            g_t(q)=((4*alpha/pi)*cos(pi*(1+alpha)*t(q)/T)+(1-alpha)*sinc((1-alpha)*t(q)/T))./((1-(4*alpha*t(q)/T).^2)*sqrt(T));
        end,
    end,
end,
Ng=sqrt(g_t*g_t');
g_t=g_t/Ng;
