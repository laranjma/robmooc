function ex_train
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
%-----------  Main  ------------
xa=[10;0;1;1]; 
dt=0.02;  
for t=0:dt:10,
    clf; axis([-30,30,-30,30]); axis square; hold on;
    ua=[0;0];
    draw_tank(xa,'red');
    xa=xa+f(xa,ua)*dt;
    drawnow();
end;
end

