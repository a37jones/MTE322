%% Givens
Pr = 400;
Fpr = -200;
lp = 300; % mm (extra 10mm shaft)
Fa = 600; % Axial applied force
Fr = 1200; % Radial force, can be in any direction (Z or Y)
housingCloseDist = 90; % Distance from tip of tool to close face of housing (extra 10mm shaft)
housingFarDist = 250; % Distance from tip of tool to far face of housing (extra 10mm shaft)
Ax = 600;

bearingWidth = 20; % Assumed bearing width

Lh = 3000; % Hours
n = 8000; % Rpm


%%Variables we need to find
syms Ay Az By Bz

Fry = 0;
Frx = 0;

radialMIN = 10^100;

outputs = [0 0 0 0 0];
figure1 = figure();
% for la = housingCloseDist-10 + bearingWidth/2 : housingCloseDist + 35 - bearingWidth/2
%     for lb = housingFarDist - 35 + bearingWidth/2 : housingFarDist - bearingWidth/2
%         tempMax = 0;
%         for theta = 0 : 5 : 359
la = 90;
lb = 240;
theta = 180;
            Frz = Fr*sind(theta);
            Fry = Fr*cosd(theta);
            
            eqn1 = Fry + Ay + By + Pr == 0;
            eqn2 = By*(lb-la)+Pr*(lp-la) -(Fry*la) ==0;
            eqn3 = Frz + Az + Bz == 0;
            eqn4 = Bz*(lb-la) - (Frz*la) == 0;

            [A,B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4],[Ay, Az, By, Bz]);
            X  = linsolve(A,B);

            Ar = sqrt(X(1,1)^2 + X(2,1)^2);
            Br = sqrt(X(3,1)^2 + X(4,1)^2);
            
            if abs(Ar) + abs(Br) > tempMax
                tempMax = abs(Ar) + abs(Br);
            end
%         end
% 
        if tempMax < radialMIN
                radialMIN = tempMax;
                outputs = [la lb theta Ar Br];
        end
% 
%          plot(lb-(housingFarDist - 169),radialMIN,'.')
%             hold on;
%           
%     end
% end

outputs


%% Finding theta value
figure2 = figure();

outputs2 = [0 0 0 0 0 0 0 0 0];
radialMAX = 0;

for theta = 0 : 359
            Frz = Fr*sind(theta);
            Fry = Fr*cosd(theta);
            
            eqn1 = Fry + Ay + By + Pr == 0;
            eqn2 = By*(outputs(1,2)-outputs(1,1))+Pr*(lp-outputs(1,1)) -(Fry*outputs(1,1)) ==0;
            eqn3 = Frz + Az + Bz == 0;
            eqn4 = Bz*(outputs(1,2)-outputs(1,1)) - (Frz*outputs(1,1)) == 0;

            [C,D] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4],[Ay, Az, By, Bz]);
            Y  = linsolve(C,D);

            Ar = sqrt(Y(1,1)^2 + Y(2,1)^2);
            Br = sqrt(Y(3,1)^2 + Y(4,1)^2);

            if abs(Ar) + abs(Br) > radialMAX
                radialMAX = abs(Ar) + abs(Br);
                outputs2 = [outputs(1,1) outputs(1,2) theta Ar Y(1,1) Y(2,1) Br Y(3,1) Y(4,1)];
            end


            plot(theta,Ar + Br,'.')
            hold on;
end

outputs2

%% Calculating static and dynamic load
L10 = (Lh*60*n)/10^6;

