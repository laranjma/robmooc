function ex_auv3d
%------------------------------------------------
    function draw(x,w)
        clf;axis([-20,40,-15,40,-10,25]);
        axis square;hold on;
        Auv0=[ 0  0  10  0   0   10   0   0 ;
            -1  1   0 -1  -0.2  0  0.2  1 ;
            0  0   0  0   1    0   1   0] ;        
        w0 = 0.1*Auv0;
        Auv0=[Auv0;ones(1,length(Auv0))]; 
        w0=[w0;ones(1,length(Auv0))]; 
        E=eulermat(x(7),x(6),x(5)); %phi,theta,psi
        R= [E,[x(1);x(2);x(3)];0 0 0 1];
        Rw=[E,[w(1);w(2);w(3)];0 0 0 1];       
        Auv=R*Auv0; 
        w1 = Rw*w0; 
        plot3(Auv(1,:),Auv(2,:),Auv(3,:),'blue');
        plot3(w1(1,:),w1(2,:),w1(3,:),'red'); %consigne
        plot3(Auv(1,:),Auv(2,:),0*Auv(3,:),'black'); % shadow
        drawnow();
    end
%------------------------------------------------------
    function xdot = f(x,u)
        v=x(4); psi=x(5); theta=x(6); phi=x(7);
        ct=cos(theta); st=sin(theta); tt=tan(theta);
        cf=cos(phi); sf=sin(phi); cp=cos(psi); sp=sin(psi);
        xdot=[v*ct*cp;v*ct*sp;-v*st;u(1);
            (sf/ct)*v*u(2)+(cf/ct)*v*u(3);
            cf*v*u(2)-sf*v*u(3);
            -0.1*sf*ct+tt*(sf*v*u(2)+cf*v*u(3))];
    end

%------------------------------------------------------
    function [w,dw,ddw] = consigne(r,f1,f2,f3,t)
    w = r*[sin(f1*t) + sin(f2*t);
           cos(f1*t) + cos(f2*t);
                       sin(f3*t)];
    dw = r*[f1*cos(f1*t) + f2*cos(f2*t);
          -f1*sin(f1*t)- f2*sin(f2*t);
                        f3*cos(f3*t)];
    ddw = r*[-f1^2*sin(f1*t)- f2^2*sin(f2*t)
             -f1^2*cos(f1*t)- f2^2*cos(f2*t);
                             -f3^2*sin(f3*t)];
    
    end

%------------------------------------------------------
    function u = commande(x,w,dw,ddw)
        v=x(4); psi=x(5); theta=x(6); phi=x(7);

        ct=cos(theta); st=sin(theta);
        cf=cos(phi); sf=sin(phi); cp=cos(psi); sp=sin(psi);
        
        p = x(1:3);
        dp = [v*ct*cp;v*ct*sp;-v*st];
        
        A1 = [ct*cp, -v*ct*sp, -v*st*cp;
              ct*sp,  v*ct*cp, -v*st*sp;
                -st,        0,    -v*ct];
        A2 = [  1,          0,          0;
              	0,	(sf/ct)*v,  (cf/ct)*v;
                0,       cf*v,      -sf*v]; 
        A = A1*A2;
        
        vv = 0.04*(w-p) + 0.4*(dw-dp) + ddw;
        u = A^(-1)*vv;
    end
%----------------  Main  ------------------------
init; dt=0.1;
x=[0;0;2;0.5;0;0;0]; %px,py,pz,v,psi,theta,phi
r = 20; f1 = 0.01; f2 = 6*f1; f3 = 3*f1;
for t=0:dt:50
    [w,dw,ddw] = consigne(r,f1,f2,f3,t);
    u=commande(x,w,dw,ddw);
    x=x+dt*f(x,u);
    draw(x,w);
end
end

