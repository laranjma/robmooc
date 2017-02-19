function ex_potential

function xpoint=f(x,u)  %  x=[x,y,v,theta]
     xpoint=[x(3)*cos(x(4));
             x(3)*sin(x(4));
             u(1);u(2)];
end

%---------------- Main -------------------
x=[2;1;1;0];  % x,y,v,theta
dt=0.02;
for t=0:dt:4,
        phat=[t;t]; 
        qhat=[4;5]; 
        clf(); hold on;axis([-6,6,-6,6]); axis square;        
        u=[0;0];        
        x=x+f(x,u)*dt;                 
        draw_tank(x([1,2,4]),'red',0.1);
        plot(phat(1),phat(2),'oblack','LineWidth',3);
        plot(qhat(1),qhat(2),'ored','LineWidth',3);
        drawnow();
end;
end