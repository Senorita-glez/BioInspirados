clc,clear
dim = 100;
escala = 8;
hFig = figure('Name', 'Juego de la Vida', 'NumberTitle', 'off', 'Position', [150, 150, dim*escala, dim*escala]);
axis tight;
axis off;

% Crear una matriz inicial aleatoria
mundo = randi([0, 1], dim, dim);

% Bucle principal del juego
while isvalid(hFig)
    % Visualizar el estado actual
    imagesc(mundo);
    title('Juego de la Vida');
    colormap(gca, 'gray');
    axis tight;
    drawnow;

    mundo = actualizarJuego(mundo, dim);

    % Pausa para una mejor visualización
    pause(0.1);
end

function countV = contarVecinos(estadoActual, x, y, dim)
    countV = 0;
    
    % Coordenadas vecinas en una cuadrícula toroidal
    vecinasX = [x-1, x-1, x-1, x, x, x+1, x+1, x+1];
    vecinasY = [y-1, y, y+1, y-1, y+1, y-1, y, y+1];

    for i = 1:numel(vecinasX)
        % Asegurar que las coordenadas estén en el rango correcto
        vecinaX = mod(vecinasX(i)-1, dim) + 1;
        vecinaY = mod(vecinasY(i)-1, dim) + 1;
        
        countV = countV + estadoActual(vecinaX, vecinaY);
    end
end

function nuevoEstado = actualizarJuego(estadoActual, dim)
    nuevoEstado = zeros(dim, dim);
    for x = 1:dim
        for y = 1:dim
            vecinosVivos = contarVecinos(estadoActual, x, y, dim);
            % Aplicar reglas del juego de la vida
            if estadoActual(x, y) == 1 && (vecinosVivos < 2 || vecinosVivos > 3)
                nuevoEstado(x, y) = 0; % Muere por soledad o superpoblación
            elseif estadoActual(x, y) == 0 && vecinosVivos == 3
                nuevoEstado(x, y) = 1; % Nace si tiene exactamente 3 vecinos vivos
            else
                nuevoEstado(x, y) = estadoActual(x, y); % Mantiene el estado actual
            end
        end
    end
end