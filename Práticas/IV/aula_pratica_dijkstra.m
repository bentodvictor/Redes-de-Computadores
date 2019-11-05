clear all; close all; clc;
rand('twister', 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geração do grafo que 
% representa uma rede de comunicação

num_nos  = 100;
figure(1);clf;hold on;
L = 1000; % lado da área onde estão os nós
R = 200;  % alcance maximo direto de um nó até seus vizinhos 
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
            custo (k,j) = rand(1); % com custo aleatório entre 0 e 1
            line([posX(k) posX(j)], [posY(k) posY(j)], 'LineStyle', ':');
        else
            matriz(k,j) = 0;
            custo (k,j) = inf;
        end;
    end;
end;

% pergunta: Qual é caminho com o maior custo no grafo e quanto é o custo? 
% Algoritmo do caminho mais curto de Edsger Dijkstra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=num_nos; % número de nós na rede
% todos os nós ainda não foram visitados;
visitado(1:n) = 0;

distancia(1:n) = inf;  % armazena a distância mais curta entre a origem e o nó
precedente(1:n) = 0;   % armazena o nó precedente no caminho mais curto entre 
                       % a origem e outro nó
					   
%%%%%%%%%%%%%%%%% Aqui inicia a implementação do algoritmo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					   
					   