A GUI pode ser exportada como arquivo .exe MAS s� ir� funcionar em computadores que tenham matlab, pois chama o coder do matlab. caso queira uma GUI independente sera nescessario retirar todas as fun��es especificas ao MATLAB (plot, contour, ...).


as fun��es prontas
f1, f2, f3, f4 e f5 s�o fun��es das listas passadas em sala

a fun��o f5 NAO possui limita��es logo s� pdoe ser usada com m�todos OSR a n�o ser que fun��es restritivas sejam adicionadas.
f5 = "   x(1)^2 - 3*x(1)*x(2) + 4*x(2)^2 + x(1) - x(2)  "
caso queira testar a inser��o de fun��o por texto � s� copiar o text entre aspas acima ^ ou adicionar uma fun��o escrita de forma similar

Na inser��o por texto voce pode adicionar fun��es do MATLAB como sin() exp() pow() e acredito que fun��es que voce tenha feito tamb�m.

As restri��es de penalidade s�o fun��es cujo nome � da forma pXcY ou pXhY. X referente � fun��o fX e Y referente ao numero da condi��o. ent�o na hora de adicionar as penalidades por exemplo da fun��o f2, deve-se adicionar p2c1 (condi��o 1) e p2c2 (condi��o 2) (pode ser em qualquer ordem, clicando em +1 apos cada fun��o).

Para uso de restri��es de barreira as fun��es tem nome bXcY/pXhY pois usa-se a mesma restri��o de igualdade da penalidade.

no caso dos gradientes destas fun��es eles devem ser feitos n�o a partir da propria fun��o pXcY/pXhY mas do quadrado dela, por exemplo
em p2c1 temos: 2*x(1) + x(2) - 2
mas em seu grad temos o grad de (2*x(1) + x(2) - 2)^2
grad_p2c1: d/dx(1) -> 2*2*(2*x(1)+x(2)-2);
           d/dx(2) -> 2*(2*x(1)+x(2)-2);

a fun��o f4 possui 5 vari�veis, portanto n�o pode ser plotada.
A GUI s� plta fun��es de 2 e 1 vari�veis.

o numero m�ximo de itera��es � o mesmo para todas as etapas (OCR, OSR, Busca Linear), acho que seria melhor se eu adiciona-se mais quadros de inser��o para cada m�todo.

As posi��es em que as janelas aparecem foram escolhidas com base em uma tela de 1920x1080, mas eu tenho que adequa-las �s outras telas. Caso na sua tela elas se sobreponham, verifique se n�o pode mudar a resolu��o da tela para 1920x1080, se quiser.

H� 3 bot�es "?" que tiram duvidas sobre valores padr�o e como inserir novos valores.

Bot�es cujo texto est� em branco est�o desativados (alguns se ativam ap�s inser��o dos dados, outros precisam terminar de ser implementados).