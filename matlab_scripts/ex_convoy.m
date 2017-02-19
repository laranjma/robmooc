function ex_convoy
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v,s)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2);x(4)];
    end

%------------------------------------------------------
    function [w,dw] = consigne(Lx,Ly,a,t)
        w = [Lx*sin(a*t);
             Ly*cos(a*t)];
        dw = [Lx*a*cos(a*t);
              Ly*a*sin(a*t)];
    end

%------------------------------------------------------
    function u = commande(x,w,dw)
        y = x(1:2); theta=x(3);
        ct=cos(theta); st=sin(theta);
        dy = [x(4)*ct; x(4)*st];
        
        A = [-x(4)*st  ct;
              x(4)*ct  st];

        % Commande PD
        v = (w-y) + (dw - dy);
        u = A^(-1)*v;
    end
%-----------  Main  ------------
init;
xa=[10;0;1;1;0]; 
init;
Lx=20;Ly=5;a=0.1;
m=6; d=5;
S=[];ds=0.1;
X = [1:m;zeros(1,m);zeros(1,m);3*ones(1,m);zeros(1,m)];
dt=0.03; 
for t=0:dt:50
    clf; axis([-30,30,-30,30]); axis square; hold on;
    % Consigne leader
    s=0:0.01:2*pi; pw=[Lx*cos(s);Ly*sin(s)];
    plot(pw(1,:),pw(2,:),'magenta');
    if(xa(5) > ds)
        S=[S,xa];
        xa(5)=0;
    end
    [wa,dwa] = consigne(Lx,Ly,a,t);
    plot(wa(1),wa(2),'+red');
    % Commande leader
    ua = commande(xa,wa,dwa);
    draw_tank(xa,'red');
    xa=xa+f(xa,ua)*dt;
    % Followers
    for i=1:m
        j=size(S,2)-d*i/ds;
        if j>0,
            xai = S(:,j);
            wi = xai(1:2);
            dwi = xa(4)*[cos(xai(3)); sin(xai(3))];
            ui=commande(X(:,i),wi,dwi);
        else
            ui=[0.2;0];
        end
        X(:,i) = X(:,i)+f(X(:,i),ui)*dt;
        draw_tank(X(:,i),'black',0.5);
    end
    drawnow();
end;
end

