function ex_pursuit

function  xdot  = f(x,u)   % state : x =(x,y,theta)
xdot=[u(1)*cos(x(3)); u(1)*sin(x(3)); u(2)];
end

%------------------------------------------------------
    function u = commande(x,v,w,dw)
        p = x(1:2); theta=x(3);
        ct=cos(theta); st=sin(theta);
        
        A = [-1  x(2);
              0 -x(1)];
        b = v(1)*[ct;
                  st];
        % Commande PD
        c = (w-p) + dw;
        u = A^(-1)*(c - b);
    end
%----------------  Main  ------------------------

init;
xa=[-10;-10;1];
xb=[-5;-5;0];
dt=0.02;
for t=0:dt:20
    clf(); hold on; axis([-30,30,-30,30]); axis square;
    x = [ cos(xa(3))  sin(xa(3)) 0;
         -sin(xa(3))  cos(xa(3)) 0;
          0              0       1]*(xb-xa);
    w = [10;0];
    dw= [0;0];
    v=[3;sin(0.2*t)];     
    u = commande(x,v,w,dw); % commande follower
    draw_tank(xa,'blue');  draw_tank(xb,'red');    
    xa=xa+f(xa,u)*dt; % follower
    xb=xb+f(xb,v)*dt; % leader
    drawnow();
end;
end
