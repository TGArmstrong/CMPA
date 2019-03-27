cla;

Is = 0.01e-12;
Ib = 0.1e-12;
Gp = 0.1;
Vb = 1.3;

Ifunc = @(V) Is*(exp(1.2/0.025*V)-1) + Gp*V - Ib*exp(-1.2/0.025*(V+Vb));
V = linspace(-1.95,0.7,200);
I1 = Ifunc(V);
I2 = I1.*(1+0.2*(-1 + 2*rand(1,200)));
figure(1);
plot(V, I1, V, I2);

Pfit4I1 = polyfit(V,I1,4);
Pfit8I1 = polyfit(V,I1,8); 
Pfit4I2 = polyfit(V,I2,4); 
Pfit8I2 = polyfit(V,I2,8);

hold on;
plot(V,polyval(Pfit4I1,V));
hold on;
plot(V,polyval(Pfit8I1,V));
hold on;
plot(V,polyval(Pfit4I2,V));
hold on;
plot(V,polyval(Pfit8I2,V));
legend('I1 data', 'I2 data', 'I1 4th deg. fit', 'I1 8th deg. fit', 'I2 4th deg. fit', 'I2 8th deg. fit');
% Polynomial fits are not exact, but accuracy improves as degree increases

startpoints = [0 0 0 0];
Ifunc2 = @(Is,Ib,Vb,Gp,x) Is*(exp(1.2/0.025*x)-1) + Gp*x - Ib*exp(-1.2/0.025*(x+Vb));
fit2paramsI1 = fit(V',I1',Ifunc2,'Lower',[-Inf -Inf Vb Gp],'Upper',[+Inf +Inf Vb Gp],'StartPoint',startpoints);
fit3paramsI1 = fit(V',I1',Ifunc2,'Lower',[-Inf -Inf -Inf Gp],'Upper',[+Inf +Inf +Inf Gp],'StartPoint',startpoints);
fit4paramsI1 = fit(V',I1',Ifunc2,'Lower',[-Inf -Inf -Inf -Inf],'Upper',[+Inf +Inf +Inf +Inf],'StartPoint',startpoints);
fit2paramsI2 = fit(V',I2',Ifunc2,'Lower',[-Inf -Inf Vb Gp],'Upper',[+Inf +Inf Vb Gp],'StartPoint',startpoints);
fit3paramsI2 = fit(V',I2',Ifunc2,'Lower',[-Inf -Inf -Inf Gp],'Upper',[+Inf +Inf +Inf Gp],'StartPoint',startpoints);
fit4paramsI2 = fit(V',I2',Ifunc2,'Lower',[-Inf -Inf -Inf -Inf],'Upper',[+Inf +Inf +Inf +Inf],'StartPoint',startpoints);

figure(2);
cla;
plot(V,I1,V,I2);
hold on;
plot(fit2paramsI1);
hold on;
plot(fit3paramsI1,'b');
hold on;
plot(fit4paramsI1,'g');
hold on;
plot(fit2paramsI2,'y');
hold on;
plot(fit3paramsI2,'p');
hold on;
plot(fit4paramsI2,'o');
% The fits return very odd values. Fitting does not necessarily give
% physical values. However, the curves seem accurate. 
hold off;

inputs = V;
targets = I2;
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;
figure(3);
cla;
plotfit(net,inputs,targets);
% The neural net fits the data well. However, no device parameters can be
% read from it. 
