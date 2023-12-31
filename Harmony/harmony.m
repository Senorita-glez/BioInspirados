clc;
clear;
N = 4;
poblacion = 10000;
raccept = 0.95;
rpa = 0.2;
BW = 0.0085;
NI = 20;
lims = [
     0 1200;
     0 1200;
    -0.55 0.55;
    -0.55 0.55;
];
mejores = [];
corridas = 1;
cero_gordo = 0.00001;
for c = 1:corridas
    c
    HM = [];
    for n=1:poblacion
        temp = [];
        for i = 1:size(lims, 1)
            li = lims(i, 1);
            ls = lims(i, 2);
            pub = li + (ls-li) * rand;
            pub = transpose(pub);
            temp = [temp, pub];
        end
        HM = [HM; temp];
    end
    HM = [HM, FO(HM)];
    new = zeros(size(HM, 1), 1);
    HM  = [HM new];
    for it = 1:NI
        it
        newX = zeros(1, 4);
        for n = 1:N
            %n
            r1 = rand; 
            if r1 < raccept 
                index = randi(N,1,1);
                r2 = rand;
                if r2 < rpa
                    rand3 = -1 + 2 * rand;
                    newX(:, n) = HM(index, n) + BW * rand3;
                else
                    newX(:, n) = HM(index, n);
                end
            else
                muestra = randGene(lims);
                newX(:, n) = muestra(1, n);
            end
        end
        newX;
        newX = mcota(newX, lims);
        newX(1, 5)= FO(newX);
        %reglas de dev 
        [p, b] = devRules(HM);
        [px, bx] = devRules(newX);
        %px
        %px(1,:)
        %p
        if px(1,end) < p(end,end)
            p(end, :) = px(1,:);
        end   
        HM = sortrows(p, 6);

        if ~isempty(b) && ~isempty(bx)
            if bx(1,5) > b(end,5)
                b(1, :) = bx(1,:);
            end      
        end
        if ~isempty(b)
            HM = [b; HM];
        end
        %p
    end
    %HM
    mejores = [mejores; HM(1, :)];
end
mejores = sortrows(mejores, 6)
disp('Promedio FO')
mean(mejores(:, 5))
disp('Desviación estandar FO')
var(mejores(:, 5))
%disp('Promedio violación de restricciones')
%mean(mejores(:, 6))
%disp('Desviación estandar violación de restricciones')
%var(mejores(:, 6))

%//////////////////////////////////////////////////////////////////
%/////////////////////////////////////////////////////////FUNCIONES
%//////////////////////////////////////////////////////////////////
function fx = FO(HM)
    x1 = HM(:, 1);
    x2 = HM(:, 2);
    fx = 3*x1 + 0.000001*x1.^3 + 2*x2 + (0.000002/3)*x2.^3;
end

function RndomGen = randGene(lims)
    RndomGen = [];
    for i = 1:size(lims, 1)
        li = lims(i, 1);
        ls = lims(i, 2);
        poblacion_val = li + (ls - li) * rand;
        poblacion_val = transpose(poblacion_val);
        RndomGen = [RndomGen, poblacion_val];
    end
    RndomGen = RndomGen;
end

function [devRule, adoc] = devRules(table)
    adoc = [];
    %new = zeros(size(table, 1), 1);
    %table  = [table new];
    for i = 1:size(table, 1)
        x1 = table(i, 1);
        x2 = table(i, 2);
        x3 = table(i, 3);
        x4 = table(i, 4);
        %desigualdades 
        g1 = -(x4) + (x3) - 0.55;
        g2 = -(x3) + (x4) - 0.55;
        %igualdades
        h3 = 1000*(sin(-(x3) - 0.25)) + 1000*(sin(-(x4) - 0.25)) + 894.8 - (x1);
        h4 = 1000*(sin((x3) - 0.25)) + 1000*(sin((x3) - (x4) - 0.25)) + 894.8 - (x2);
        h5 = 1000*(sin((x4) - 0.25)) + 1000*(sin((x4) - (x3) - 0.25)) + 1294.8;
        h3(h3 < 0.00001) = 0;
        h4(h4 < 0.00001) = 0;
        h5(h5 < 0.00001) = 0;
        %table(i, 6) = abs(h3) + abs(h4) + abs(h5);
        table(i, 6) = max(0,g1) + max(0,g2) + abs(h3) + abs(h4) + abs(h5);
    end
    devRule = sortrows(table, 6);
    adoc = table(:, 6) <= 0.0003;
    if ~isempty(adoc)
        filas_seleccionadas = adoc;
        adoc = sortrows(table(filas_seleccionadas, :), 5);
    end
end

function cotas = mcota(x, lims)
    for i =1:length(x)-2
        li = lims(i, 1);
        ls = lims(i, 2);
        while x(:, i) > ls || x(:, i) < li
            if x(:, i) > ls
                x(:, i) = (2 * ls) - x(:, i);
            elseif x(:, i) < li
                x(:, i) = (2 * li) - x(:, i);
            end
        end
    end
    cotas = x;
end


