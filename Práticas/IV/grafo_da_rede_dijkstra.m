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

s=1;        % testando o algoritmo com uma origem apenas
distancia(s) = 0;
for k = 1:n
    temp = [];
    for h = 1:n
         if visitado(h) == 0   % ainda não está no caminho mais curto;
             temp=[temp distancia(h)];
         else
             temp=[temp inf];
         end
    end
     [t, u] = min(temp);    % inicia no nó com a menor distancia até a origem
     visitado(u) = 1;       % marca como visitado --> faz parte do caminho mais curto;
     for v = 1:n            % para cada vizinho de u;
         if ((custo(u,v) + distancia(u)) < distancia(v))
             distancia(v) = distancia(u) + custo(u,v);   % atualiza a distancia para um valor menor;
             precedente(v) = u;                           % atualiza o precedente de v;
         end             
     end
end

% quem está mais longe ?
[L,d]=max(distancia);










