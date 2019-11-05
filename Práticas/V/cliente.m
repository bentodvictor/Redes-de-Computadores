% CLIENTE - conecta a um servidro e lê uma mensagem
%
% Uso - mensagem = cliente(host, porta, numero_tentativas)
% Ex.: dados = cliente(localhost, 3000);

function mensagem = cliente(host, porta, numero_tentativas)

    import java.net.Socket
    import java.io.*

    if (nargin < 3)
        numero_tentativas = 20; % colocar -1 para infinito
    end
    
    tentativas   	 = 0;
    soquete_entrada  = [];
    mensagem         = [];

    while true

        tentativas = tentativas + 1;
        if ((numero_tentativas > 0) && (tentativas > numero_tentativas))
            fprintf(1, 'Muitas tentativas\n');
            break;
        end
        
        try
            fprintf(1, 'Tentativa %d conectando a %s:%d\n', ...
                    tentativas, host, porta);

            % tenta estabelecer a conexão TCP
            soquete_entrada = Socket(host, porta);

            % inicia um fluxo de bytes na entrada do soquete
            fluxo_entrada   = soquete_entrada.getInputStream;
            d_fluxo_entrada = DataInputStream(fluxo_entrada);

            fprintf(1, 'Conectado ao servidor\n');

            % leitura dos dados do soquete - aguarda um pouco de tempo antes
            pause(0.5);
            bytes_disponiveis = fluxo_entrada.available;
            fprintf(1, 'Lendo %d bytes\n', bytes_disponiveis);
            
            mensagem = zeros(1, bytes_disponiveis, 'uint8');
            for k = 1:bytes_disponiveis
                mensagem(k) = d_fluxo_entrada.readByte;
            end
            
            mensagem = char(mensagem);
            
            % termina a conexão
            soquete_entrada.close;
            break;
            
        catch
            if ~isempty(soquete_entrada)
                soquete_entrada.close;
            end

            % espera um pouco antes de tentar novamente
            pause(1);
        end
    end
end