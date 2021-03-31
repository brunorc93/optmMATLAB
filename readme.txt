A GUI pode ser exportada como arquivo .exe MAS só irá funcionar em computadores que tenham matlab, pois chama o coder do matlab. caso queira uma GUI independente sera nescessario retirar todas as funções especificas ao MATLAB (plot, contour, ...).


as funções prontas
f1, f2, f3, f4 e f5 são funções das listas passadas em sala

a função f5 NAO possui limitações logo só pdoe ser usada com métodos OSR a não ser que funções restritivas sejam adicionadas.
f5 = "   x(1)^2 - 3*x(1)*x(2) + 4*x(2)^2 + x(1) - x(2)  "
caso queira testar a inserção de função por texto é só copiar o text entre aspas acima ^ ou adicionar uma função escrita de forma similar

Na inserção por texto voce pode adicionar funções do MATLAB como sin() exp() pow() e acredito que funções que voce tenha feito também.

As restrições de penalidade são funções cujo nome é da forma pXcY ou pXhY. X referente à função fX e Y referente ao numero da condição. então na hora de adicionar as penalidades por exemplo da função f2, deve-se adicionar p2c1 (condição 1) e p2c2 (condição 2) (pode ser em qualquer ordem, clicando em +1 apos cada função).

Para uso de restrições de barreira as funções tem nome bXcY/pXhY pois usa-se a mesma restrição de igualdade da penalidade.

no caso dos gradientes destas funções eles devem ser feitos não a partir da propria função pXcY/pXhY mas do quadrado dela, por exemplo
em p2c1 temos: 2*x(1) + x(2) - 2
mas em seu grad temos o grad de (2*x(1) + x(2) - 2)^2
grad_p2c1: d/dx(1) -> 2*2*(2*x(1)+x(2)-2);
           d/dx(2) -> 2*(2*x(1)+x(2)-2);

a função f4 possui 5 variáveis, portanto não pode ser plotada.
A GUI só plta funções de 2 e 1 variáveis.

o numero máximo de iterações é o mesmo para todas as etapas (OCR, OSR, Busca Linear), acho que seria melhor se eu adiciona-se mais quadros de inserção para cada método.

As posições em que as janelas aparecem foram escolhidas com base em uma tela de 1920x1080, mas eu tenho que adequa-las às outras telas. Caso na sua tela elas se sobreponham, verifique se não pode mudar a resolução da tela para 1920x1080, se quiser.

Há 3 botões "?" que tiram duvidas sobre valores padrão e como inserir novos valores.

Botões cujo texto está em branco estão desativados (alguns se ativam após inserção dos dados, outros precisam terminar de ser implementados).