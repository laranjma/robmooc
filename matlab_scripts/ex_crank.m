function ex_crank
%----------------------------------------------
    function draw()
        clf(); hold on; axis([-4,8,-4,8]); axis square;
        draw_circle(c,r,'black',2);
        plot([0,z(1),y(1)],[0,z(2),y(2)],'magenta','LineWidth',3);
        drawnow();
    end
%-----------------------------------------------
init; x=[-1;1];
L1=4;L2=3;c=[1;2];r=4;
z=L1*[cos(x(1));sin(x(1))];
y=z+L2*[cos(x(1)+x(2));sin(x(1)+x(2))];
draw();
end