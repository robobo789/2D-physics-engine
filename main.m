clc, clear
dt = 0.0025;

w = World();

a = ones(8,3);
a(3:5, 3) = 0;
a(5,2) = 0;

s1 = ShapeConstructor(a,0.4 ,200, 1);
s2 = ShapeConstructor(a,0.4 ,200 , 1);
s3 = ShapeConstructor(a, 0.9, 1000, 10);

% w.addBody(s1, [-5,15]);
% w.addBody(s2, [2.5,15]);
w.addBody(s3, [5,20]);

for i = 1:5000
    w.applyGravity()
    w.update(dt)
    if mod(i,10)==0
        w.plotWorld()
        pause(0.0001)
    end
end