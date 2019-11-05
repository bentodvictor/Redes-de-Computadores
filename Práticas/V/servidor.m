% SERVIDOR Escreve uma mensagem na porta especificada
% 
% Uso - servidor(mensagem, porta_saida, numero_tentativas)
% Ex.: 
% mensagem = char(mod(1:1000, 255)+1);
% servidor(mensagem, 3000, 10);

function servidor(mensagem, porta_saida, numero_tentativas)

    import java.net.ServerSocket
    import java.io.*

    if (nargin < 3)
        numero_tentativas = 20; % colocar -1 para infinito
    end

    tentativas             = 0;

    soquete_servidor  = [];
    soquete_saida     = [];

    while true

        tentativas = tentativas + 1;

        try
            if ((numero_tentativas > 0) && (tentativas > numero_tentativas))
                fprintf(1, 'Muitas tentativas\n');
                break;
            end

            fprintf(1, ['Tentativa %d aguardando cliente conectar neste ' ...
                        'host na porta : %d\n'], tentativas, porta_saida);

            % aguarda por 1 segundo para o cliente conectar ao soquete do servidor
            soquete_servidor = ServerSocket(porta_saida);
            soquete_servidor.setSoTimeout(1000);

            soquete_saida = soquete_servidor.accept;


            fprintf(1, 'Cliente conectado\n');

            fluxo_saida   = soquete_saida.getOutputStream;
            d_fluxo_saida = DataOutputStream(fluxo_saida);            
                
            % coloca os dados na saída DataOutputStream
            % Converte em um fluxo de bytes
            fprintf(1, 'Escrevendo %d bytes\n', length(mensagem))
            d_fluxo_saida.writeBytes(char(mensagem));
            d_fluxo_saida.flush;
            
            % mostra os dados do soquete
            disp(soquete_saida );            
            
            % fecha a conexão
            soquete_servidor.close;
            soquete_saida.close;
            break;
            
        catch
            if ~isempty(soquete_servidor)
                soquete_servidor.close
            end

            if ~isempty(soquete_saida)
                soquete_saida.close
            end

            % aguarda antes de tentar novamente
            pause(1);
        end
    end
end