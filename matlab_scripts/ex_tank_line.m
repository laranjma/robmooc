function ex_tank_line
    function xdot=f(x,u)
        theta=x(3);
        xdot=[cos(theta);sin(theta);u];
    end
a=[-30;-4];b=[30;6];
x=[-20;-10;4];  % x,y,theta
dt=0.1;
for t=0:dt:10;
    clf(); hold on; axis([-30 30 -30 30]); axis square;
    u=0;
    x=x+f(x,u)*dt;
    draw_tank(x,'blue');
    plot([a(1);b(1)],[a(2);b(2)],'red');
    drawnow();
end
end

