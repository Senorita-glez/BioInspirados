filas = 50;
columnas = 50;

hFig = figure('Name', 'Juego de la Vida', 'NumberTitle', 'off', 'Position', [150, 130, filas * 10, columnas * 10]);
axis tight;
axis off;

% Crear una matriz inicial aleatoria
mundo = randi([0, 1], filas, columnas);

% Bucle principal del juego
while isvalid(hFig)
    % Visualizar el estado actual
    imagesc(mundo);
    title('Juego de la Vida');
    colormap(gca, 'gray');
    axis tight;
    drawnow;

    mundo = actualizarJuego(mundo);

    % Pausa para una mejor visualización
    pause(0.1);
end

function countV = contarVecinos(estadoActual, x, y, filas, columnas)
    countV = 0;
    
    if x-1 > 0 && y-1 > 0
        countV = countV + estadoActual(x-1, y-1);
    end
    if x-1 > 0
        countV = countV + estadoActual(x-1, y);
    end
    if y-1 > 0
        countV = countV + estadoActual(x, y-1);
    end
    if x+1 <= filas && y+1 <= columnas
        countV = countV + estadoActual(x+1, y+1);
    end
    if x+1 <= filas
        countV = countV + estadoActual(x+1, y);
    end
    if y+1 <= columnas
        countV = countV + estadoActual(x, y+1);
    end
    if x+1 <= filas && y-1 > 0
        countV = countV + estadoActual(x+1, y-1);
    end
    if x-1 > 0 && y+1 <= columnas
        countV = countV + estadoActual(x-1, y+1);
    end
end

function nuevoEstado = actualizarJuego(estadoActual)
    [filas, columnas] = size(estadoActual);
    nuevoEstado = zeros(filas, columnas);

    for x = 1:filas
        for y = 1:columnas

            vecinosVivos = contarVecinos(estadoActual, x, y, filas, columnas);
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
