function ex_group
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        theta=x(3);v=x(4);
        xdot=[v*cos(theta); v*sin(theta); u(1); u(2)];
    end

init;
dt=0.1;  
x=[1;1;1;1];
u=[0;0];
for t=0:dt:40,
    clf; axis([-40,40,-40,40]); axis square; hold on;
    x=x+f(x,u)*dt;
    draw_tank(x,'black',0.5);  
    drawnow();
end;
end

