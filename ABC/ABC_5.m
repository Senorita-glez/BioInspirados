clc;
clear;

lims = [
     -5 5;
     -5 5;
];
var = size(lims, 1);
SN = 1000;
FA = [];
limite = SN * var;
generaciones = 100;

for n=1:SN
    temp = [];
    for i = 1:size(lims, 1)
        li = lims(i, 1);
        ls = lims(i, 2);
        pub = li + (ls-li) * rand;
        pub = transpose(pub);
        temp = [temp, pub];
    end
    FA = [FA; temp];
end
FA;

FA = [FA, FO(FA)];
FA = [FA, transpose(zeros(1, SN))];
krand = transpose(randperm(SN));

for g = 1:generaciones
    phis = generatePhis(SN, size(lims, 1));
    actualizar = nuevasPosiciones(FA, phis, krand, var);
    actualizar = [actualizar, FO(actualizar)];
    
    for i = 1 : size(FA, 1)
        if actualizar(i, end) < FA(i, var+1)
            FA(i, 1:var+1) = actualizar(i, :);
            FA(i, end) = 0;
        else
            FA(krand(i), end) = FA(i, end) +1;
        end
    end

    for i = 1 : size(FA, 1)
        if FA(i, end) > limite
            FA(i, 1) = (rand() * 10) - 5;
            FA(i, 2) = (rand() * 10) - 5;
            FA(i, 3) = FO(FA(i, 1:2));
        end
    end
    
    FA;
    indices = mejoresIndex(FA, var, SN);
    num_mejores = round(SN/2);
    ini = 1;
    fin = num_mejores;
    for i = 1:2
        newk(ini:fin) = indices(i);
        ini = ini + num_mejores;
        fin = fin + num_mejores;
    end
    krand = newk(1,1:SN);
end

orden = sortrows(FA, var+1);
best = orden(1, :)

function FA = randPob(limites, SN)
    for n=1:SN
    temp = [];
    for i = 1:size(lims, 1)
        li = lims(i, 1);
        ls = lims(i, 2);
        pub = li + (ls-li) * rand;
        pub = transpose(pub);
        temp = [temp, pub];
    end
    FA = [FA; temp];
end
end


function phis = generatePhis(SN, var)
    phis = -1 + (1-(-1)).*rand(SN,var);
end

function fx = FO(HM)
    x1 = HM(:, 1);
    x2 = HM(:, 2);
    fx = x1.^2 + x2.^2;
end

function newPos = nuevasPosiciones(FA, phis, krand, var)
    newPos = [];
    for i = 1 : size(FA, 1)
        ab = krand(i);
        temp = [];
        for j = 1 : var
            temp = [temp FA(i,j) + phis(i, j) * (FA(i,j) - FA(ab, j))];
        end
        newPos = [newPos; temp];
    end
end

function indices = mejoresIndex(FA, var, SN)
    num_mejores = floor(SN/2);
    orden = sortrows(FA, var+1);
    indices = [];
    for i = 1:num_mejores
        indices = [indices find(ismember(FA(:, var+1), orden(i, var+1)))];
    end
end
