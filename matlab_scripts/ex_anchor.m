function ex_anchor
    function draw(x)
        clf(); axis([-30 30 -30 30]); axis square; hold on;
        draw_tank(x,'black');
        drawnow();
    end
        
x=[15;20;1];
draw(x);

end


