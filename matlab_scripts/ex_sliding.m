function ex_sliding
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
%-----------  Main  ------------
x=[10;0;1;1]; 
dt=0.01; 
for t=0:dt:3,
    clf; axis([-30,30,-30,30]); axis square; hold on;
    draw_tank(x,'red');  
    u=[0;0];
    x=x+f(x,u)*dt;
    drawnow();
end;
end

