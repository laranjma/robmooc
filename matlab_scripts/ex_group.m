function ex_group
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        theta=x(3);v=x(4);
        xdot=[v*cos(theta); v*sin(theta); u(1); u(2)];
    end
%------------------------------------------------------
    function [w,dw,ddw] = consigne(a,i,m,t)
        w = [cos(a*t + 2*i*pi/m);
               sin(a*t + 2*i*pi/m)];
        dw = [-a*sin(a*t + 2*i*pi/m);
               a*cos(a*t + 2*i*pi/m)];
        ddw = [-a^2*cos(a*t + 2*i*pi/m);
               -a^2*sin(a*t + 2*i*pi/m)];
    end
%------------------------------------------------------
    function [w,dw,ddw] = consigne2(a,i,m,t)
        theta = a*t; ct = cos(theta); st = sin(theta);
        c = [cos(a*t + 2*i*pi/m); sin(a*t + 2*i*pi/m)];
        dc = a*[-sin(a*t + 2*i*pi/m); cos(a*t + 2*i*pi/m)];
        ddc = -a^2*c;
        D = [20 + 15*sin(a*t) 0;0 20];
        dD = [15*a*cos(a*t) 0; 0 0];
        ddD = [-15*a^2*sin(a*t) 0; 0 0];
        R = [ct -st;st  ct];
        dR = a*[-st -ct; ct -st];
        ddR = -a^2*R;
        w = R*D*c;
        dw = R*D*dc + R*dD*c + dR*D*c;
        ddw = R*D*ddc + R*ddD*c + ddR*D*c + 2*(dR*D*dc + R*dD*dc + dR*dD*c);
        
    end
%------------------------------------------------------
    function u = commande(x,w,dw,ddw)
        y = x(1:2); theta=x(3);
        dy = [x(4)*cos(x(3)); x(4)*sin(x(3))];
        ct=cos(theta); st=sin(theta);
        
        A = [-x(4)*st  ct;
              x(4)*ct  st];

        % Commande PD
        v = (w-y) + 2*(dw - dy) + ddw;
        u = A^(-1)*v;
    end
%-----------  Main  ------------

init;
dt=0.1;  
a = 0.1;
m=20;
X=10*randn(4,m);

for t=0:dt:40,
    clf; axis([-40,40,-40,40]); axis square; hold on;
    for i=1:m
        % consigne
        %[w,dw,ddw] = consigne(a,i,m,t);
        [w,dw,ddw] = consigne2(a,i,m,t);
        % commande
        u = commande(X(:,i),w,dw,ddw);
        X(:,i)=X(:,i)+f(X(:,i),u)*dt;
        draw_tank(X(:,i),'black',0.5);  
        plot(w(1),w(2),'+red');
    end;
    drawnow();
end;
end

