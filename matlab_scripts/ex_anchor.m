function ex_anchor
    function draw(x,u)
        clf(); axis([-30 30 -30 30]); axis square; hold on;
        draw_circle([0;0],10,'red');
        if(u==1) col='blue'; else col='green'; end;
        draw_tank(x,col);
        drawnow();
    end

    function xdot=f(x,u)
        xdot=[cos(x(3));sin(x(3));u];
    end

    function u=control(x)
        alpha=atan2(x(2),x(1));
        phi=pi+x(3)-alpha;
        if(phi<1/sqrt(2))
            u=1;
        else u=-sin(phi);
        end
        
    end

% ---------- main ---------- %
init;
x=[15;20;1]; dt=0.1;
for t=0:dt:100
    u=control(x);
    draw(x,u);
    x=x+f(x,u)*dt + 0.01*randn(3,1);
end

end


