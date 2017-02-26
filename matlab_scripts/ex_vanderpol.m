function ex_vanderpol
clc;

function xdot=f(x,u)
    theta=x(3);
    delta=x(5);
    v=x(4);
    xdot=[v*cos(delta)*cos(theta);v*cos(delta)*sin(theta);v*sin(delta)/3;u(1);u(2)];
end

function draw_field(xmin,xmax,ymin,ymax)
    Mx=xmin:2:xmax;
    My=ymin:2:ymax;
    [X1,X2]=meshgrid(Mx,My);
    VX=X2;
    VY=-(0.01*X1.^2-1).*X2-X1;
    VX=VX./sqrt(VX.^2+VY.^2);
    VY=VY./sqrt(VX.^2+VY.^2);
    quiver(Mx,My,VX,VY);
end
% ---------- main ---------- %
x=[0;5;pi/2;5;0.5];  % x,y,theta,v,delta
dt=0.01;
for t=0:dt:10
    clf(); hold on; axis([-50,50,-30,30]);
    vdp=[x(2);-(0.01*x(1)^2-1)*x(2)-x(1)];
    w=[10;angle(vdp)]; % consigne vitesse, cap
    ubar=[w(1); 3*sawtooth(w(2)-x(3))];
    u=10*(ubar-[x(4)*cos(x(5));x(4)*sin(x(5))/3]);
    x=x+f(x,u)*dt;
    draw_car(x);
    draw_field(-50,50,-30,30)
    drawnow();
end
end