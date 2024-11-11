% Importar el SDK de RealSense
%addpath('path_to_librealsense_mex_files'); % Asegúrate de tener configurada la ruta correcta a las funciones de RealSense para MATLAB

% Configurar la cámara Intel RealSense D435i
%pipeline = realsense.pipeline();
%config = realsense.config();
%config.enable_stream(realsense.stream.depth, 640, 480, realsense.format.z16, 30);
%config.enable_stream(realsense.stream.color, 640, 480, realsense.format.rgb8, 30);

% Iniciar la cámara
%pipeline.start(config);

pipeline = connect();

% Capturar un fotograma de la cámara
frames = pipeline.wait_for_frames();
depth_frame = frames.get_depth_frame();
color_frame = frames.get_color_frame();

% Convertir los datos a imágenes de MATLAB
depth_img = depth_frame.get_data();
color_img = color_frame.get_data(); %Devuelve una fila
%Hay que usar reshape para que salga de la forma 3x640x480
%Y despues cambiar el orden a 480x640x3
%color_img = permute(color_img, [3, 2, 1]); --> [3,2,1] Intercambia
%reshape se cuenta en orden de columna!
color_img = permute(reshape(color_img',3,640,480), [3, 2, 1]); % Ajustar dimensiones para MATLAB

% Mostrar la imagen capturada
figure;
imshow(color_img);
title('Imagen Capturada - Color');

% Convertir la imagen a escala de grises para procesar objetos
gray_img = rgb2gray(color_img);

% Segmentación básica por umbral para detectar objetos
bw = imbinarize(gray_img, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);

% Mostrar la imagen binarizada
figure;
imshow(bw);
title('Imagen Binarizada para Detección de Objetos');

% Detectar contornos del objeto
contours = bwboundaries(bw);
hold on;
for k = 1:length(contours)
    boundary = contours{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
end
title('Contornos Detectados del Objeto');

% % Comparar con un modelo de referencia (asumimos que se tiene guardado)
% load('modelo_referencia.mat'); % Cargar el contorno de referencia previamente guardado
% ref_contour = modelo_referencia; % Contorno predefinido o referencia esperada
% 
% % Medir la discrepancia (por ejemplo, usando la distancia de Hausdorff)
% % Puedes ajustar esta parte para métodos más avanzados si es necesario
% discrepancia = hausdorffDistance(cell2mat(ref_contour), cell2mat(contours));
% 
% % Resultado de la comparación
% if discrepancia < 15 % Ajustar el umbral según lo necesario
%     disp('El objeto coincide con el modelo de referencia.');
% else
%     disp(['Discrepancia encontrada: ', num2str(discrepancia)]);
% end
% 
% % Finalizar y detener la cámara
pipeline.stop();
