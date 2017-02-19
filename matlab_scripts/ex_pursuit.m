function ex_pursuit

function  xdot  = f(x,u)   % state : x =(x,y,theta)
xdot=[u(1)*cos(x(3)); u(1)*sin(x(3)); u(2)];
end


init;
xa=[-10;-10;1];
xb=[-5;-5;0];
dt=0.02;
for t=0:dt:10,
    clf(); hold on; axis([-30,30,-30,30]); axis square;           
    v=[3;sin(0.2*t)];     
    u=[1;0];
    draw_tank(xa,'blue');  draw_tank(xb,'red');    
    xa=xa+f(xa,u)*dt;
    xb=xb+f(xb,v)*dt;
    drawnow();
end;
end
