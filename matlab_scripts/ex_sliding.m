function ex_sliding
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end

%------------------------------------------------------
    function [w,dw,ddw] = consigne(r,t)
        w = r*[cos(t);
               sin(3*t)];
        dw = r*[-sin(t);
                3*cos(3*t)];
        ddw = r*[-cos(t)
                 -9*sin(3*t)];
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
%------------------------------------------------------
    function u = commande_mg(x,w,dw)
        y = x(1:2); theta=x(3);
        dy = [x(4)*cos(x(3)); x(4)*sin(x(3))];
        ct=cos(theta); st=sin(theta);
        
        A = [-x(4)*st  ct;
              x(4)*ct  st];

        % Commande PD
        s = (w-y) + (dw - dy);
        K = 100;
        v = K*sign(s);
        u = A^(-1)*v;
    end
%-----------  Main  ------------
x=[10;0;1;1]; 
L=10;
E=[];
dt=0.01; 
for t=0:dt:10
    clf; axis([-30,30,-30,30]); axis square; hold on;
    draw_tank(x,'red');  
    % Consigne
    s=0:0.01:50; pw=L*[cos(s);sin(3*s)];
    plot(pw(1,:),pw(2,:),'magenta');
    [w,dw,ddw] = consigne(L,t);
    plot(w(1),w(2),'+red');
    % Commande
    %u=commande(x,w,dw,ddw);
    u=commande_mg(x,w,dw);
    % Error
    E = [E,abs(x(1)-w(1))+abs(x(2)-w(2))];
    x=x+f(x,u)*dt;
    drawnow();
end;
figure(2);plot(E);
end

