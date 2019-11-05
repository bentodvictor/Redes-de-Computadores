clear all; close all; clc;
rand('twister', 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gera��o do grafo que 
% representa uma rede de comunica��o

num_nos  = 100;
figure(1);clf;hold on;
L = 1000; % lado da �rea onde est�o os n�s
R = 200;  % alcance maximo direto de um n� at� seus vizinhos 
posX = rand(1,num_nos)*L;
posY = rand(1,num_nos)*L;
matriz = zeros(num_nos); % matriz de conectividade
custo = ones(num_nos)*inf; % custo dos enlaces
for k = 1:num_nos
    plot(posX(k), posY(k), '.');
    text(posX(k), posY(k), num2str(k));
    for j = 1:num_nos
        distancia = sqrt((posX(k) - posX(j))^2 + (posY(k) - posY(j))^2);
        if distancia <= R
            matriz(k,j) = 1;   % tem um enlace;
            custo (k,j) = rand(1); % com custo aleat�rio entre 0 e 1
            line([posX(k) posX(j)], [posY(k) posY(j)], 'LineStyle', ':');
        else
            matriz(k,j) = 0;
            custo (k,j) = inf;
        end;
    end;
end;

% pergunta: Qual � caminho com o maior custo no grafo e quanto � o custo? 
% Algoritmo do caminho mais curto de Edsger Dijkstra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=num_nos; % n�mero de n�s na rede
% todos os n�s ainda n�o foram visitados;
visitado(1:n) = 0;

distancia(1:n) = inf;  % armazena a dist�ncia mais curta entre a origem e o n�
precedente(1:n) = 0;   % armazena o n� precedente no caminho mais curto entre 
                       % a origem e outro n�
					   
%%%%%%%%%%%%%%%%% Aqui inicia a implementa��o do algoritmo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					   
					   