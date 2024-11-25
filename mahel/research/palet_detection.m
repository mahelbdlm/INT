% Charger l'image
img = imread('palet1.jpg'); % Remplacez 'image_palet.jpg' par le nom de votre fichier image
grayImg = rgb2gray(img); % Convertir l'image en niveaux de gris

% Appliquer un filtre de Canny pour détecter les contours
edges = edge(grayImg, 'Canny');

% Trouver les contours et obtenir les points qui forment le contour
[B, L] = bwboundaries(edges, 'noholes');

% Calculer le rectangle englobant minimal
stats = regionprops(L, 'BoundingBox');
boundingBox = stats(1).BoundingBox;

% Extraire les coordonnées du rectangle englobant
x = boundingBox(1);
y = boundingBox(2);
width = boundingBox(3);
height = boundingBox(4);

% Calculer les distances entre les côtés du rectangle englobant
horizontalDistance = width;
verticalDistance = height;

% Afficher les résultats
imshow(img);
hold on;
% Tracer le rectangle englobant
rectangle('Position', boundingBox, 'EdgeColor', 'r', 'LineWidth', 2);

% Afficher les distances
text(x, y-10, sprintf('Width: %.2f px', horizontalDistance), 'Color', 'yellow', 'FontSize', 12);
text(x, y+height+10, sprintf('Height: %.2f px', verticalDistance), 'Color', 'yellow', 'FontSize', 12);

hold off;