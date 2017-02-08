from roblib import *
import sys

def f(x,u):
	x=x.flatten()
	u=u.flatten()
	return (array([[x[3]*cos(x[2])], [x[3]*sin(x[2])], [u[0]],[u[1]]]))
    
def draw_ellipse(lx,ly):
	x = lx*sin(arange(0,2*pi,0.01))
	y = ly*cos(arange(0,2*pi,0.01))
	plot(x,y,'r')
	
def consigne0(Lx,Ly,ω,t):
    w = array([[Lx*sin(ω*t)], [Ly*cos(ω*t)]])
    dw = array([[Lx*cos(ω*t)*ω], [-Ly*sin(ω*t)*ω]])
    ddw = array([[0],[0]]) # array([[-Lx*sin(ω*t)*ω*ω], [-Ly*cos(ω*t)*ω*ω]])
    return w,dw,ddw
	
def consigne1(l,x,u):
    w = array([[x[0,0]-l*cos(x[2,0])], [x[1,0]-l*sin(x[2,0])]])
    dw = array([[x[3,0]*cos(x[2,0]) + l*u[0,0]*sin(x[2,0])],
                 [x[3,0]*sin(x[2,0]) - l*u[0,0]*cos(x[2,0])]])
    ddw = array([[0], [0]])
    return w,dw,ddw
	
def regulation(x,w,dw,ddw):
	xa = x[0,0]
	ya = x[1,0]
	θa = x[2,0]
	va = x[3,0]
	A = array([[-va*sin(θa), cos(θa)],[va*cos(θa), sin(θa)]])
	Ainv = inv(A)
	
	pos = array([[xa],[ya]])
	dpos = array([[va*cos(θa)], [va*sin(θa)]])
	e = w - pos
	de = dw - dpos
	v = e + 2*de + ddw
	u = Ainv @ v
	return u

fig = figure(0)
ax = fig.add_subplot(111, aspect='equal')

dt = 0.1
# x = [xa, ya, θa, va]
xa = array([[0],[1],[pi/3],[1]])
xb = array([[-1],[-1],[pi/3],[1]])
xc = array([[-1],[-1],[pi/3],[1]])

ua = array([[1],[1]])
ub = array([[1],[1]])
uc = array([[1],[1]])
Lx,Ly = 15,7
l = 6
ω = 0.1

for t in arange(0,120,dt) :
	pause(0.01)  
	cla()
	ax.set_xlim(-50,50)
	ax.set_ylim(-50,50)
	# draws
	draw_ellipse(Lx,Ly)
	draw_tank(xa)
	draw_tank(xb)
	draw_tank(xc)
	# consignes
	if(sys.argv[1] == '0'):
		ret = 5 # retard
		# Utilise consigne0 (centralisee)
		wa,dwa,ddwa = consigne0(Lx,Ly,ω,t)
		plot(wa[0,0],wa[1,0],'bo')
		wb,dwb,ddwb = consigne0(Lx,Ly,ω,t-ret)
		plot(wb[0,0],wb[1,0],'ro')
		wc,dwc,ddwc = consigne0(Lx,Ly,ω,t-2*ret)
		plot(wc[0,0],wc[1,0],'go')
	else:
		# Utilise consigne1 (relative)
		wa,dwa,ddwa = consigne0(Lx,Ly,ω,t)
		plot(wa[0,0],wa[1,0],'bo')
		wb,dwb,ddwb = consigne1(l,xa,ua)
		plot(wb[0,0],wb[1,0],'ro')
		wc,dwc,ddwc = consigne1(l,xb,ub)
		plot(wc[0,0],wc[1,0],'go')
			
	# commandes
	ua = regulation(xa,wa,dwa,ddwa)
	ub = regulation(xb,wb,dwb,ddwb)
	uc = regulation(xc,wc,dwc,ddwc)
	# misa a jour
	xa = xa + dt*f(xa,ua)
	xb = xb + dt*f(xb,ub)
	xc = xc + dt*f(xc,uc)
show()
