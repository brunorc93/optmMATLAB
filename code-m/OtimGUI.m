%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Código criado com base em MATLAB R2016a %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% MATLAB R2016a possui fimplicit %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% fimplict ja comentado onde deve ser inserido %%%%%%
%%%%%%%%%%%% ezplot nao funciona pois a entrada e de uma %%%%%%%
%%%%%%%%%%%% variavel vetorial apenas (x) %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function OtimGUI
    % Add folders to path
    addpath('equations/Functions');
    addpath('equations/Functions/Grad');
    addpath('equations/Functions/Hess');
    addpath('equations/Restrictions');
    addpath('equations/Restrictions/Grad');
    addpath('equations/Restrictions/Hess');

    % Add the UI components
    gui = adicionarElementos;
    % Make figure visible after adding components
    % gui.janela.Visible = 'on';
    gui.x_o = 0;
    gui.n = 0;
    gui.f_button_active = 0;
    gui.f_text = '';
    gui.function = '';
    gui.g_button_active = 0;
    gui.g_text = '';
    gui.grad = '';
    gui.h_button_active = 0;
    gui.h_text = '';
    gui.hess = '';
    gui.OCR = '';
    gui.OSR = '';
    gui.LSearch = '';
    gui.x_m = 0;
    gui.plotdata = 0;
    gui.tempo = 0;
    gui.n_passos = 0;
    gui.TOL_OCR = power(10,(-1*5));
    gui.TOL_OSR = power(10,(-1*5));
    gui.TOL_LSearch = power(10,(-1*5)); % tolerancia ou da (delta_alfa)
    gui.n_Max_iter = 500; 
    gui.armijo_m = 0.3;
    gui.restricao_c = {};
    gui.restricao_h = {};
    gui.grad_restricao_c = {};
    gui.grad_restricao_h = {};
    gui.hess_restricao_c = {};
    gui.hess_restricao_h = {};
    gui.rp_o = 1;
    gui.beta_p = 10;
    gui.rb_o = 10;
    gui.beta_b = 0.1;
    gui.restricoes_can_check = 0;
    gui.erros_na_minimizacao = '';
    
    function gui = adicionarElementos
        tela = get(0,'screensize');
        gui.tela_x = tela(3);
        gui.tela_y = tela(4);
        gui.tamanho_x = 470;
        gui.tamanho_y = 400;
        pos_janela_out = [(gui.tela_x-gui.tamanho_x)/2-gui.tela_x/4,(gui.tela_y-gui.tamanho_y)/2,gui.tamanho_x,gui.tamanho_y];
        %%%%%%%%%%%%%%%%%%%%%%% JANELA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.janela = figure('Visible','on',...
                        'Resize','off',...
                        'Tag','janela',...
                        'OuterPosition',pos_janela_out);
        %%%%%%%%%%%%%%%%%%%%%%% LINHA AZUL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.lineAxes = axes('Parent',gui.janela,...
              'Units','pixels',...
              'Position',[85,200,gui.tamanho_y,gui.tamanho_y],...
              'Visible','off');
          line([0,0],[0,gui.tamanho_y-200],'Parent',gui.lineAxes);
        %%%%%%%%%%%%%%%%%%%%%%% RADIO BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.rBtn_OCR = uicontrol(gui.janela,'Style','radiobutton',...
              'String','OCR',...
              'Position',[10,gui.tamanho_y-105,45,15],...
              'Callback',@radioButtonOCR);          
          gui.rBtn_OSR = uicontrol(gui.janela,'Style','radiobutton',...
              'String','OSR',...
              'Position',[60,gui.tamanho_y-105,45,15],...
              'Callback',@radioButtonOSR);    
        %%%%%%%%%%%%%%%%%%%%%%% POP UP MENUS DE TIPOS DE minimizacoes %%%%%%%%
          pop_menu_pos1 = [10,gui.tamanho_y-130,200,15];
          pop_menu_pos2 = [10,gui.tamanho_y-160,200,15];
          pop_menu_pos3 = [10,gui.tamanho_y-190,200,15];    
          gui.puMenu_OCR = uicontrol(gui.janela,'Style','popupmenu',...
              'String',{'Metodo de Otimizacao C/ Restricoes',...
                          '---metodos indiretos---',...
                          'penalidade','barreira',...
                          '---outros metodos---'},...
              'Position',pop_menu_pos1,...
              'Visible','off',...
              'Callback',@popupMenuOCR);
          gui.puMenu_OSR = uicontrol(gui.janela,'Style','popupmenu',...
              'String',{'Metodo de Otimizacao S/ Restricoes',...
                          'univariante',...
                          'powell',...
                          'Steepest Descent',...
                          'Fletcher-Reeves',...
                          'BFGS',...
                          'Newton-Raphson'},...
              'Position',pop_menu_pos2,...
              'Visible','off',...
              'Callback',@popupMenuOSR);
          gui.puMenu_LSearch = uicontrol(gui.janela,'Style','popupmenu',...
              'String',{'Metodo de busca linear',...
                          'passo constante',...
                          'passo incremental',...
                          'armijo',...
                          'bissecao',...
                          'secao aurea'},...
              'Position',pop_menu_pos3,...
              'Visible','off',...
              'Callback',@popupMenuLSearch);    
        %%%%%%%%%%%%%%%%%%%%%%% TEXTOS DE TOL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.puTOL_OCR = uicontrol(gui.janela,'Style','text',...
              'String','TOL',...
              'Visible','off',...
              'Position',[215,gui.tamanho_y-135,25,15]);
          gui.puTOL_OSR = uicontrol(gui.janela,'Style','text',...
              'String','TOL',...
              'Visible','off',...
              'Position',[215,gui.tamanho_y-165,25,15]);
          gui.puTOL_LSearch = uicontrol(gui.janela,'Style','text',...
              'String','TOL',...
              'Visible','off',...
              'Position',[215,gui.tamanho_y-195,25,15]);    
        %%%%%%%%%%%%%%%%%%%%%%% CAIXA DE INSERCAO DE TOL %%%%%%%%%%%%%%%%%%%%%
          gui.editTOL_OCR = uicontrol(gui.janela,'Style','edit',...
              'Visible','off',...
              'Position',[255,gui.tamanho_y-135,23,15],...
              'Callback',@editTOL_OCRcall);
          gui.editTOL_OSR = uicontrol(gui.janela,'Style','edit',...        
              'Visible','off',...
              'Position',[255,gui.tamanho_y-165,23,15],...
              'Callback',@editTOL_OSRcall);
          gui.editTOL_LSearch = uicontrol(gui.janela,'Style','edit',...
              'Visible','off',...
              'Position',[255,gui.tamanho_y-195,23,15],...
              'Callback',@editTOL_LSearchcall);
        %%%%% CAIXA E TEXTO ESPECIFICOS PARA METODOD E ARMIJO %%%%%%%%%%%%%%%%
          gui.puArmijo_m = uicontrol(gui.janela,'Style','text',...
              'String','m:',...
              'Visible','off',...
              'Position',[215,gui.tamanho_y-220,25,15]);    
          gui.editArmijo_m = uicontrol(gui.janela,'Style','edit',...
              'Visible','off',...
              'Position',[255,gui.tamanho_y-220,23,15],...
              'Callback',@edit_m_armijo_call);
        %%%%%%%%%%%%%%%%%%%%%%% BOTAO DE DUVIDA E TEXTO AUXILIAR %%%%%%%%%%%%%
          gui.puTOL_help = uicontrol(gui.janela,'Style','text',...
              'String','10^-___',...
              'Visible','off',...
              'Position',[235,gui.tamanho_y-105,45,15]);
          gui.TOL_q = uicontrol(gui.janela,'Style','pushbutton',...
              'String','?',...
              'Visible','off',...
              'Position',[215,gui.tamanho_y-105,15,15],...
              'Callback',@TOL_duvida);
        %%%%%%%%%%%%%%%%%%%%%%% TEXTO E CAIXA DE INSERCAO DE NMAXIT %%%%%%%%%%
          gui.nmaxIt_text = uicontrol(gui.janela,'Style','text',...
              'String','numero maximo de iteracoes:',...
              'Visible','off',...
              'HorizontalAlignment','left',...
              'Position',[10,gui.tamanho_y-220,170,15]);
          gui.nmaxIt_edit = uicontrol(gui.janela,'Style','edit',...
              'Visible','off',...
              'Position',[155,gui.tamanho_y-220,40,15],...
              'Callback',@n_max_it_call);
        %%%%%%%%%%%%%%%%%%%%%%% BOTAO DE MINIMIZAR %%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.minimize = uicontrol(gui.janela,'Style','pushbutton',...
              'String','M I N I M I Z A R',...
              'Position',[185,gui.tamanho_y-250,90,20],...
              'Enable','inactive',...
              'ForegroundColor',[1,1,1],...
              'Callback',@minimiza);
        %%%%%%%%%%%%%%%%%%%%%%% TEXTOS DE RESPOSTA (AUXILIAR) %%%%%%%%%%%%%%%%
          gui.sText_metodo = uicontrol(gui.janela,'Style','text',...
              'String','metodo usado:',...
              'HorizontalAlignment','left',...
              'Position',[15,gui.tamanho_y-280,100,15]);
          gui.sText_tempo = uicontrol(gui.janela,'Style','text',...
              'String','tempo de execucao:',...        
              'HorizontalAlignment','left',...
              'Position',[15,gui.tamanho_y-310,100,15]);
          gui.sText_passos = uicontrol(gui.janela,'Style','text',...
              'String','numero de passos no metodo:',...        
              'HorizontalAlignment','left',...
              'Position',[15,gui.tamanho_y-340,150,15]);    
          gui.x_m_text = uicontrol(gui.janela,'Style','text',...
              'String','ponto de minimo:',...        
              'HorizontalAlignment','left',...
              'Position',[15,gui.tamanho_y-370,100,15]);
          gui.x_o_text = uicontrol(gui.janela,'Style','text',...
              'String','ponto de inicio:',...
              'HorizontalAlignment','left',...
              'Position',[15,gui.tamanho_y-390,100,15]);
        %%%%%%%%%%%%%%%%%%%%%%% TEXTOS AUXILIARES P INSERCAO DE DADOS DE F %%%
          gui.sText_funcao = uicontrol(gui.janela,'Style','text',...
              'String','Funcao:',...
              'Position',[286,gui.tamanho_y-135,63,15]);
          gui.sText_n = uicontrol(gui.janela,'Style','text',...
              'String','n:',...
              'Position',[297,gui.tamanho_y-105,15,15]);
          gui.sText_x_o = uicontrol(gui.janela,'Style','text',...
              'String','x_o:',...
              'Position',[297+70,gui.tamanho_y-105,25,15]);
          gui.sText_grad = uicontrol(gui.janela,'Style','text',...
              'String','grad(f):',...
              'Position',[297,gui.tamanho_y-165,40,15]);
          gui.sText_hess = uicontrol(gui.janela,'Style','text',...
              'String','Hess(f):',...
              'Position',[297,gui.tamanho_y-195,45,15]);
        %%%%%%%%%%%%%% QUADROS E BOTOES  DE INSERCAO DE DADOS DA FUNCAO %%%%%%
          gui.nInput = uicontrol(gui.janela,'Style','edit',...
              'Position',[297+15,gui.tamanho_y-105,40,15],...
              'Callback',@nIcall);
          gui.nInput_q = uicontrol(gui.janela,'Style','pushbutton',...
              'String','?',...
              'Position',[297+15+40,gui.tamanho_y-105,15,15],...
              'Callback',@n_duvida);
          gui.fInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Position',[285 + 60,gui.tamanho_y-135,92,15],...
              'Visible','off',...
              'Callback',@fIcall);
          gui.xInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Position',[297+95,gui.tamanho_y-105,45,15],...
              'Visible','off',...
              'Callback',@xIcall);
          gui.gInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Position',[285 + 60,gui.tamanho_y-165,92,15],...
              'Visible','off',...
              'Callback',@gIcall);
          gui.hInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Position',[285 + 60,gui.tamanho_y-195,92,15],...
              'Visible','off',...
              'Callback',@hIcall);
        %%%%%%%%%%%%%%%%%%%%%%% CHECK BOXES DE INSERCAO DE DADOS DA F %%%%%%%%
          gui.xCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-105,15,15]);
          gui.fCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-135,15,15]);
          gui.gCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-165,15,15]);
          gui.hCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-195,15,15]);
        %%%%%%%%%%%%%%%%%%%%%%% RESPOSTAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.mAns = uicontrol('Parent',gui.janela,...
              'Style','text',...
              'String',' ',...
              'HorizontalAlignment','left',...
              'Position',[180,gui.tamanho_y-280,100,15]);
          gui.tAns = uicontrol('Parent',gui.janela,...
              'Style','text',...
              'String',' ',...
              'HorizontalAlignment','left',...
              'Position',[180,gui.tamanho_y-310,100,15]);
          gui.npAns = uicontrol('Parent',gui.janela,...
              'Style','text',...
              'String',' ',...
              'HorizontalAlignment','left',...
              'Position',[180,gui.tamanho_y-340,100,15]);
          gui.xmAns = uicontrol('Parent',gui.janela,...
              'Style','text',...
              'String',' ',...
              'HorizontalAlignment','left',...
              'Position',[100,gui.tamanho_y-370,300,15]);
          gui.x0Ans = uicontrol('Parent',gui.janela,...
              'Style','text',...
              'String',' ',...
              'HorizontalAlignment','left',...
              'Position',[100,gui.tamanho_y-390,300,15]);
        %%%%%%%%%%%%%%%%%%%%%%% BOTAO DE RESETAR INPUTS %%%%%%%%%%%%%%%%%%%%%%
          gui.resetAll = uicontrol('Parent',gui.janela,...
              'Style','pushbutton',...
              'String','Reset',...
              'Position',[gui.tamanho_x-55,10,40,20],...
              'Callback',@resetCall);
        %%%%%%%%%%%%%%%%%%%%%% INSERCAO DAS FUNCOES DE RESTRICAO %%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%% TEXTO AUXILIAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.sText_restricao = uicontrol(gui.janela,'Style','text',...
              'String','RESTRICOES h(x) e c(x):',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[297,gui.tamanho_y-220,90,15]);
        %%%%%%%%%%%%%%%%%%%%%% BOTAO DE INSERCAO DE DADOS DAS RESTRICOES %%%%%
          gui.restricaoInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Visible','off',...
              'Position',[285 + 100,gui.tamanho_y-220,52,15],...
              'Callback',@restricaoIcall);
        %%%%%%%%%%%%%%%%%%%%%% CHECKBOX DAS RESTRICOES %%%%%%%%%%%%%%%%%%%%%%%
          gui.restricaoCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-220,15,15]);
        %%%%%%%%%%%%%%%%%%%%%% INSERCAO DE GRAD/HESS_RESTRICAO %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%% TEXTO AUXILIAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          gui.sText_GeH_restricao = uicontrol(gui.janela,'Style','text',...
              'String','grad/H(RESTRICAO):',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[297,gui.tamanho_y-240,120,15]);
        %%%%%%%%%%%%%%%%%%%% BOTAO DE INSERCAO DE DADOS DE G/H_F. RESTRICOES %    
          gui.GeH_restricaoInput = uicontrol(gui.janela,'Style','pushbutton',...
              'String','Inserir',...
              'Visible','off',...
              'Position',[285 + 100,gui.tamanho_y-240,52,15],...
              'Callback',@GeH_restricaoIcall);
        %%%%%%%%%%%%%%%%%%%%%% CHECKBOX DE G/H_F. RESTRICOES %%%%%%%%%%%%%%%%%
          gui.GeH_restricaoCheck = uicontrol(gui.janela,'Style','checkbox',...
              'Enable','inactive',...
              'Value',0,...
              'Visible','off',...
              'Position',[297+95+50,gui.tamanho_y-240,15,15]);
        %%%%%%%%%%%%%%%%%%%%%% TEXTO AUXILIAR PARA R_Po R_Bo BETA_B BETA_P %%%    
          gui.sText_r_p_o = uicontrol(gui.janela,'Style','text',...
              'String','rp_o:',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[297,gui.tamanho_y-295,70,15]);
          gui.sText_r_b_o = uicontrol(gui.janela,'Style','text',...
              'String','rb_o:',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[297,gui.tamanho_y-325,70,15]);
          gui.sText_beta_p = uicontrol(gui.janela,'Style','text',...
              'String','beta_p:',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[367,gui.tamanho_y-295,70,15]);
          gui.sText_beta_b = uicontrol(gui.janela,'Style','text',...
              'String','beta_b:',...
              'HorizontalAlignment','left',...
              'Visible','off',...
              'Position',[367,gui.tamanho_y-325,70,15]);
        %%%%%%%%%%%%%%%%%%%%%% CAIXAS DE INSERCAO PARA R_P R_B BETA_B BETA_P %
          gui.rp_o_Input = uicontrol(gui.janela,'Style','edit',...
              'Position',[337,gui.tamanho_y-295,20,15],...
              'Visible','off',...
              'Callback',@rp_o_Icall);
          gui.rb_o_Input = uicontrol(gui.janela,'Style','edit',...
              'Position',[337,gui.tamanho_y-325,20,15],...
              'Visible','off',...
              'Callback',@rb_o_Icall);
          gui.beta_p_Input = uicontrol(gui.janela,'Style','edit',...
              'Position',[417,gui.tamanho_y-295,20,15],...
              'Visible','off',...
              'Callback',@beta_p_Icall);
          gui.beta_b_Input = uicontrol(gui.janela,'Style','edit',...
              'Position',[417,gui.tamanho_y-325,20,15],...
              'Visible','off',...
              'Callback',@beta_b_Icall);    
        %%%%%%%%%%%%%%%%%%%%%% BOTAO DE DUVIDA PARA R_P R_B BETA_B BETA_P %%%%
          gui.help_ocr_restricao = uicontrol(gui.janela,'Style','pushbutton',...
              'String','?',...
              'Visible','off',...
              'Position',[362,gui.tamanho_y-265,20,15],...
              'Callback',@ocr_restricoes_duvida);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    function beta_p_Icall(source,eventdata)
        gui.beta_p = 10; % valor padrao
        var = get(gui.beta_p_Input,'String');
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.beta_p = num;
            end
        end
    end

    function beta_b_Icall(source,eventdata)
        gui.beta_b = 0.1; % valor padrao
        var = get(gui.beta_b_Input,'String');
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.beta_b = num;
            end
        end
    end

    function editTOL_OCRcall(source,eventdata)
        var = get(gui.editTOL_OCR,'String');
        if isempty(var)
            gui.TOL_OCR = power(10,(-1*5));
        else
            num = str2double(var);
            if isnan(num) 
                gui.TOL_OCR = power(10,(-1*5));
            else
                gui.TOL_OCR = power(10,(-1*num));
            end
        end        
    end

    function editTOL_OSRcall(source,eventdata)
        var = get(gui.editTOL_OSR,'String');
        if isempty(var)
            gui.TOL_OSR = power(10,(-1*5));
        else
            num = str2double(var);
            if isnan(num) 
                gui.TOL_OSR = power(10,(-1*5));
            else
                gui.TOL_OSR = power(10,(-1*num));
            end
        end
    end

    function editTOL_LSearchcall(source,eventdata)
        var = get(gui.editTOL_LSearch,'String');
        if strcmp(gui.puTOL_LSearch.String,'TOL')
            if isempty(var)
                gui.TOL_LSearch = power(10,(-1*5));
            else
                num = str2double(var);
                if isnan(num) 
                    gui.TOL_LSearch = power(10,(-1*5));
                else
                    gui.TOL_LSearch = power(10,(-1*num));
                end
            end
        else if strcmp(gui.puTOL_LSearch.String,'da')
                if isempty(var)
                    gui.TOL_LSearch = 0.01;
                else
                    num = str2double(var);
                    if isnan(num) 
                        gui.TOL_LSearch = 0.01;
                    else
                        gui.TOL_LSearch = power(10,num);
                    end
                end
            end
        end
    end

    function edit_m_armijo_call(source,eventdata)
        gui.armijo_m = 0.3; % valor padrao
        var = get(gui.nInput,'String');        
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.armijo_m = num;
            end
        end    
    end

    function fIcall(source,eventdata)
        gui.janela_f = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-295,450,300]);
        gui.f_text = uicontrol('Parent',gui.janela_f,...
                'Style','text',...
                'String',{'Abaixo ha 2 interruptores. Apenas um pode estar ativo.',...
                          'Apos pressionar o botao desejado deve-se escrever na caixa de texto a FUNCAO. Para o primeiro botao escreve-se a FUNCAO por extenso com variaveis x(1), x(2),... x(n) e valores numericos, como no exemplo.',...
                          'Para o segundo botao deve ser escrito o nome da FUNCAO como no arquivo MatLab desta e este arquivo deve estar disponivel no caminho do MATLAB (preferencialmente no mesmo diretorio deste programa)'},...
                'HorizontalAlignment','left',...
                'Position',[10,75,410,110]);
        % primeiro botao para INSERCAO da FUNCAO por texto
        gui.f_Btn_1 = uicontrol(gui.janela_f,'Style','togglebutton',...
        'String','a*x(i)^n + b*sin(x(j)) + c*exp(x(k))',...
        'Position',[35,40,205,30],...
        'Callback',@fBtn1call);
        % segundo bota para INSERCAO da FUNCAO por @func, deve
        % existir arquivo.m no path do matlab!
        gui.f_Btn_2 = uicontrol(gui.janela_f,'Style','togglebutton',...
        'String','nome da FUNCAO',...
        'Position',[285,40,115,30],...
        'Callback',@fBtn2call);        
        gui.fEdit = uicontrol('Parent',gui.janela_f,...
                'Style','edit',...
                'Enable','inactive',...
                'HorizontalAlignment','left',...
                'Position',[10,10,415,20],...
                'Callback',@fEcall,...
                'BackgroundColor',[0,0,0]);
        update()
    end

    function fBtn1call(source,eventdata)
       gui.f_Btn_2.Value = 0;
       if gui.f_Btn_1.Value == 1
           gui.fEdit.Enable = 'on';
           gui.fEdit.BackgroundColor = [1,1,1];
       else
           gui.fEdit.Enable = 'inactive';
           gui.fEdit.BackgroundColor = [0,0,0];
       end
       gui.f_button_active = 1;              
       gui.fCheck.Value = 0;
       gui.fInput.String = 'Inserir';
       gui.function = '';
       gui.f_text = '';       
       gui.gCheck.Value = 0;
       gui.gInput.String = 'Inserir';
       gui.grad = '';
       gui.g_text = '';
       gui.hCheck.Value = 0;
       gui.hInput.String = 'Inserir';
       gui.hess = '';
       gui.h_text = '';         
       gui.gInput.Visible = 'off';
       gui.hInput.Visible = 'off';                
       gui.gCheck.Visible = 'off';
       gui.hCheck.Visible = 'off';
       update()
    end

    function fBtn2call(source,eventdata)
       gui.f_Btn_1.Value = 0;
       if gui.f_Btn_2.Value == 1
           gui.fEdit.Enable = 'on';
           gui.fEdit.BackgroundColor = [1,1,1];
       else
           gui.fEdit.Enable = 'inactive';
           gui.fEdit.BackgroundColor = [0,0,0];
       end
       gui.f_button_active = 2;              
       gui.fCheck.Value = 0;
       gui.fInput.String = 'Inserir';
       gui.function = '';
       gui.f_text = '';       
       gui.gCheck.Value = 0;
       gui.gInput.String = 'Inserir';
       gui.grad = '';
       gui.g_text = '';
       gui.hCheck.Value = 0;
       gui.hInput.String = 'Inserir';
       gui.hess = '';
       gui.h_text = '';
       gui.gInput.Visible = 'off';
       gui.hInput.Visible = 'off';                
       gui.gCheck.Visible = 'off';
       gui.hCheck.Visible = 'off';
       update()
    end

    function fEcall(source,eventdata)
        gui.f_text = get(gui.fEdit,'String');
        if gui.f_button_active == 1
            % transforma texto em FUNCAO
            gui.f_text = strcat('@(x) ',gui.f_text);
            gui.function = str2func(gui.f_text);
        else if gui.f_button_active == 2
            	%transforma texto em @func
                gui.function = str2func(gui.f_text);
            end
        end        
        gui.fCheck.Value = 1;
        gui.fInput.String = 'Modificar';        
        gui.gInput.Visible = 'on';
        gui.hInput.Visible = 'on';                
        gui.gCheck.Visible = 'on';
        gui.hCheck.Visible = 'on';
        update()
    end
    
    function gIcall(source,eventdata)
        gui.janela_g = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-295,450,300]);
        gui.g_text = uicontrol('Parent',gui.janela_g,...
                'Style','text',...
                'String',{'Abaixo ha 3 interruptores. Apenas um pode estar ativo.',...
                          'O primeiro funcionam da mesma forma que para FUNCAO f',...
                          'O segundo dispensa o input do gradiente e usa o metodo das diferencas finitas para calcula-lo'},...
                'HorizontalAlignment','left',...
                'Position',[10,85,410,110]);
        % segundo botao para INSERCAO da FUNCAO por @func, deve
        % existir arquivo.m no path do matlab!
        gui.g_Btn_1 = uicontrol(gui.janela_g,'Style','togglebutton',...
        'String','nome da FUNCAO',...
        'Position',[30,35,180,30],...
        'Callback',@gBtn1call);        
        % terceiro botao para uso do Metodo das diferencas finitas
        gui.g_Btn_2 = uicontrol(gui.janela_g,'Style','togglebutton',...
        'String','Metodo das diferencas Finitas',...
        'Position',[225,35,180,30],...
        'Callback',@gBtn2call);        
        gui.gEdit = uicontrol('Parent',gui.janela_g,...
                'Style','edit',...
                'Enable','inactive',...
                'HorizontalAlignment','left',...
                'Position',[10,10,415,20],...
                'Callback',@gEcall,...
                'BackgroundColor',[0,0,0]);
        update()
    end

    function gBtn1call(source,eventdata)
       gui.g_Btn_2.Value = 0;  
       if gui.g_Btn_1.Value == 1
           gui.gEdit.Enable = 'on';
           gui.gEdit.BackgroundColor = [1,1,1];
       else
           gui.gEdit.Enable = 'inactive';
           gui.gEdit.BackgroundColor = [0,0,0];
       end
       gui.g_button_active = 1;
       gui.gCheck.Value = 0;
       gui.gInput.String = 'Inserir';       
       gui.grad = '';
       gui.g_text = '';
       update()
    end

    function gBtn2call(source,eventdata)       
       gui.g_Btn_1.Value = 0;
       gui.gEdit.Enable = 'inactive';
       gui.gEdit.BackgroundColor = [0,0,0];
       gui.g_button_active = 2;       
       gui.gCheck.Value = 1;
       gui.gInput.String = 'Modificar';
       update();
       gui.g_text = 'mdfGrad';      
       gui.grad = str2func(gui.g_text);
    end  

    function gEcall(source,eventdata)
        gui.g_text = get(gui.gEdit,'String');
        if gui.g_button_active == 2
            % transforma texto em FUNCAO
            %%%%%%%%%%%%% MODIFICAR PARA TEXTO COM VARIOS OUTPUTS
            gui.g_text = strcat('@(x) ',gui.g_text);
            gui.grad = str2func(gui.g_text);
        else if gui.g_button_active == 1
            	%transforma texto em @func
                gui.grad = str2func(gui.g_text);
            end
        end        
        gui.gCheck.Value = 1;
        gui.gInput.String = 'Modificar';    
        update();
    end
    
    function GeH_restricaoIcall(source,eventdata)
        gui.janela_geh_restricao = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-295,450,300]);
        gui.geh_restricao_text = uicontrol('Parent',gui.janela_geh_restricao,...
                'Style','text',...
                'String',{'O primeiro dos 2 botoes vai carregar como FUNCAO gradiente a FUNCAO grad_(nome da FUNCAO penalidade/barreira) e como FUNCAO hessiana a FUNCAO hess_(nome da FUNCAO penalidade/barreira), portanto devem existir no caminho do matlab estas FUNCOES.',...
                '',...
                'O segundo botao vai gerar o gradiente e a hessiana a partir do Metodo das diferencas finitas aplicados a FUNCAO penalidade/barreira'},...
                'HorizontalAlignment','left',...
                'Position',[10,75,410,110]);
        % primeiro botao para INSERCAO da FUNCAO por texto
        gui.geh_restricao_Btn_1 = uicontrol(gui.janela_geh_restricao,'Style','togglebutton',...
        'String','prefixo_(nome da FUNCAO)',...
        'Position',[35,25,170,30],...
        'Callback',@GeH_restricao_Btn1call);
        % segundo bota para INSERCAO da FUNCAO por @func, deve
        % existir arquivo.m no path do matlab!
        gui.geh_restricao_Btn_2 = uicontrol(gui.janela_geh_restricao,'Style','togglebutton',...
        'String','Metodo das diferencas Finitas',...
        'Position',[225,25,170,30],...
        'Callback',@GeH_restricao_Btn2call,...
        'Enable','inactive',...
        'ForegroundColor',[1,1,1]);
        update()
    end

    function GeH_restricao_Btn1call(source,eventdata)
        gui.geh_restricao_Btn_2.Value = 0;
        if gui.geh_restricao_Btn_1.Value == 1
            gui.GeH_restricaoInput.String = 'Modificar';
            gui.GeH_restricaoCheck.Value = 1;
            if ~isempty(gui.restricao_h)
                for i = 1:1:length(gui.restricao_h)
                    gui.grad_restricao_h{i} = str2func(strcat('grad_',func2str(gui.restricao_h{i})));
                    gui.hess_restricao_h{i} = str2func(strcat('hess_',func2str(gui.restricao_h{i})));
                end
            end
            if ~isempty(gui.restricao_c)
                for i = 1:1:length(gui.restricao_c)
                    gui.grad_restricao_c{i} = str2func(strcat('grad_',func2str(gui.restricao_c{i})));
                    gui.hess_restricao_c{i} = str2func(strcat('hess_',func2str(gui.restricao_c{i})));
                end
            end
        else
            gui.GeH_restricaoInput.String = 'Inserir';
            gui.GeH_restricaoCheck.Value = 0;
            gui.grad_restricao_c = {};
            gui.grad_restricao_h = {};
            gui.hess_restricao_c = {};
            gui.hess_restricao_h = {};
        end
        update();
    end

    function GeH_restricao_Btn2call(source,eventdata)
        gui.geh_restricao_Btn_1.Value = 0;
        if gui.geh_restricao_Btn_2.Value == 1
            gui.GeH_restricaoInput.String = 'Modificar';
            gui.GeH_restricaoCheck.Value = 1;
            gui.grad_funcao_restricao = @mdfGrad;
            gui.hess_funcao_restricao = @mdfHess;
        else
            gui.GeH_restricaoInput.String = 'Inserir';
            gui.GeH_restricaoCheck.Value = 0;            
            gui.grad_funcao_restricao = '';
            gui.hess_funcao_restricao = '';
        end
        update()
    end

    function hIcall(source,eventdata)
        gui.janela_h = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-295,450,300]);
        gui.h_text = uicontrol('Parent',gui.janela_h,...
                'Style','text',...
                'String',{'Abaixo ha 3 interruptores. Apenas um pode estar ativo.',...
                          'O primeiro funcionam da mesma forma que para FUNCAO f',...
                          'O segundo dispensa o input do gradiente e usa o metodo das diferencas finitas para calcula-lo'},...
                'HorizontalAlignment','left',...
                'Position',[10,85,410,110]);
        % primeiro botao para INSERCAO da FUNCAO por @func, deve
        % existir arquivo.m no path do matlab!
        gui.h_Btn_1 = uicontrol(gui.janela_h,'Style','togglebutton',...
        'String','nome da FUNCAO',...
        'Position',[30,35,180,30],...
        'Callback',@hBtn1call);
        % segundo botao para uso do Metodo das diferencas finitas
        gui.h_Btn_2 = uicontrol(gui.janela_h,'Style','togglebutton',...
        'String','Metodo das diferencas Finitas',...
        'Position',[225,35,180,30],...
        'Callback',@hBtn2call);        
        % terceiro botao para uso do Metodo das diferencas finitas
        gui.hEdit = uicontrol('Parent',gui.janela_h,...
                'Style','edit',...
                'Enable','inactive',...
                'HorizontalAlignment','left',...
                'Position',[10,10,415,20],...
                'Callback',@hEcall,...
                'BackgroundColor',[0,0,0]);
        update()
    end

    function hBtn1call(source,eventdata)
       gui.h_Btn_2.Value = 0;
       if gui.h_Btn_1.Value == 1
           gui.hEdit.Enable = 'on';
           gui.hEdit.BackgroundColor = [1,1,1];
       else
           gui.hEdit.Enable = 'inactive';
           gui.hEdit.BackgroundColor = [0,0,0];
       end
       gui.h_button_active = 1;       
       gui.hCheck.Value = 0;
       gui.hInput.String = 'Inserir';
       gui.hess = '';
       gui.h_text = '';
       update()
    end

    function hBtn2call(source,eventdata)
       gui.h_Btn_1.Value = 0;
       gui.hEdit.Enable = 'inactive';
       gui.hEdit.BackgroundColor = [0,0,0];
       gui.h_button_active = 2;       
       gui.hCheck.Value = 1;
       gui.hInput.String = 'Modificar';
       update();
       gui.h_text = 'mdfHess';      
       %%%%%%%%%% DEFINIR HESS %%%%%%%%
       gui.hess = str2func(gui.h_text);
    end    

    function hEcall(source,eventdata)
        gui.h_text = get(gui.hEdit,'String');
        if gui.h_button_active == 1
            %transforma texto em @func
            gui.hess = str2func(gui.h_text);
        end        
        gui.hCheck.Value = 1;
        gui.hInput.String = 'Modificar';
        update();
    end

    function minimiza(source,eventdata)
        minimizado = 0; % false
        if gui.rBtn_OCR.Value == 1
            escolhaOCR();
            str = get(gui.puMenu_OCR, 'String');
            val = get(gui.puMenu_OCR,'Value');
            switch str{val}
                case 'penalidade'
                     [gui.x_m,gui.plotdata,gui.n_passos,gui.tempo,gui.erros_na_minimizacao] = gui.OCR(...
                         gui.x_o,...
                         gui.function,...
                         gui.grad,...
                         gui.hess,...
                         gui.restricao_h,...
                         gui.restricao_c,...
                         gui.grad_restricao_h,...
                         gui.grad_restricao_c,...
                         gui.hess_restricao_h,...
                         gui.hess_restricao_c,...
                         gui.LSearch,...
                         gui.OSR,...
                         gui.TOL_OCR,...
                         gui.TOL_OSR,...
                         gui.TOL_LSearch,...
                         gui.n_Max_iter,...
                         gui.armijo_m,...
                         gui.rp_o,...
                         gui.beta_p);
                case 'barreira'
                    [gui.x_m,gui.plotdata,gui.n_passos,gui.tempo,gui.erros_na_minimizacao] = gui.OCR(...
                         gui.x_o,...
                         gui.function,...
                         gui.grad,...
                         gui.hess,...
                         gui.restricao_h,...
                         gui.restricao_c,...
                         gui.grad_restricao_h,...
                         gui.grad_restricao_c,...
                         gui.hess_restricao_h,...
                         gui.hess_restricao_c,...
                         gui.LSearch,...
                         gui.OSR,...
                         gui.TOL_OCR,...
                         gui.TOL_OSR,...
                         gui.TOL_LSearch,...
                         gui.n_Max_iter,...
                         gui.armijo_m,...
                         gui.rp_o,...
                         gui.beta_p,...
                         gui.rb_o,...
                         gui.beta_b);
            end   
            checagemDeErrosNaMinimizacao();
            x_m_string = '[';
            x_m_string = strcat(x_m_string,{'  '});
            for i = 1:1:length(gui.x_m);
                x_m_string = strcat(x_m_string,num2str(gui.x_m(i)));
                x_m_string = strcat(x_m_string,{'  '});
            end
            x_m_string = strcat(x_m_string,']');
            gui.xmAns.String = x_m_string;
            minimizado = 1;
        else if gui.rBtn_OSR.Value == 1
                escolhaOSR();
                [gui.x_m,gui.plotdata,gui.n_passos,gui.tempo,gui.erros_na_minimizacao] = gui.OSR(...
                    gui.x_o,... x_o
                    gui.function,... fi
                    gui.grad,... g_fi
                    gui.hess,... h_fi
                    gui.LSearch,... busca_lin
                    gui.TOL_OSR,... tolerancia
                    gui.TOL_LSearch,... tolerancia_lsearch
                    gui.n_Max_iter,... n_max_iter
                    gui.armijo_m,... m
                    false,... ocr_flag
                    0,... f
                    0,... g_f
                    0,... h_f
                    0,... restr_f_h
                    0,... restr_f_c
                    0,... restr_g_h
                    0,... restr_g_c
                    0,... restr_h_h
                    0,... restr_h_c
                    0,... rp_k
                    0); % rb_K
                x_m_string = '[';
                x_m_string = strcat(x_m_string,{'  '});
                for i = 1:1:length(gui.x_m);
                    x_m_string = strcat(x_m_string,num2str(gui.x_m(i)));
                    x_m_string = strcat(x_m_string,{'  '});
                end
                x_m_string = strcat(x_m_string,']');
                gui.xmAns.String = x_m_string;
                minimizado = 1;
                checagemDeErrosNaMinimizacao();
            end
        end
        if gui.n <= 2 && minimizado == 1
            pos_graf_out = [(gui.tela_x)/4+gui.tamanho_x/2,(gui.tela_y)/4,gui.tela_y/2,gui.tela_y/2];
            gui.janelaGraf = figure('Visible','on',...
                    'Resize','on',...
                    'Tag','grafico',...
                    'OuterPosition',pos_graf_out);
            gui.graf = axes('Parent',gui.janelaGraf,...
                    'Units','pixels',...
                    'Position',[40,40,gui.tela_y/2-90,gui.tela_y/2-180]);
            plotResultados();
        end
        if minimizado == 1
            gui.npAns.String = num2str(gui.n_passos);
            gui.tAns.String = strcat(num2str(gui.tempo),' s');
            gui.mAns.String = pegarMetodo();
        end
    end

    function nIcall(source,eventdata)
        var = get(gui.nInput,'String');
        if (isempty(var))
            gui.fInput.Visible = 'off';
            gui.gInput.Visible = 'off';
            gui.hInput.Visible = 'off';
            gui.xInput.Visible = 'off';
            gui.fCheck.Visible = 'off';
            gui.gCheck.Visible = 'off';
            gui.hCheck.Visible = 'off';
            gui.xCheck.Visible = 'off';
        else
            num = str2double(var);
            if (isnan(num))
                gui.fInput.Visible = 'off';
                gui.gInput.Visible = 'off';
                gui.hInput.Visible = 'off';                
                gui.xInput.Visible = 'off';
                gui.fCheck.Visible = 'off';
                gui.gCheck.Visible = 'off';
                gui.hCheck.Visible = 'off';
                gui.xCheck.Visible = 'off';
            else
                gui.fInput.Visible = 'on';
                gui.xInput.Visible = 'on';
                gui.fCheck.Visible = 'on';
                gui.xCheck.Visible = 'on';
                gui.x_o = zeros(1,num);
                gui.x_m = zeros(1,num);
                gui.n = num;                              
                gui.fCheck.Value = 0;
                gui.fInput.String = 'Inserir';
                gui.function = '';
                gui.f_text = '';    
            end
        end
        update()
    end

    function n_duvida(source,eventdata)
        gui.janela_n = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-195,230,200]);
        gui.n_d_text = uicontrol('Parent',gui.janela_n,...
                'Style','text',...
                'String',{'para poder inserir a FUNCAO, primeiro deve-se indicar o numero de variaveis (n) da FUNCAO.',...
                'n deve ser um numero inteiro.',...
                'caso n seja <= 2, um grafico sera plotado.'},...
                'HorizontalAlignment','left',...
                'Position',[10,0,200,100]);
        update()
    end

    function n_max_it_call(source,eventdata)
        gui.n_Max_iter = 500; % valor padrao
        var = get(gui.nmaxIt_edit,'String');        
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.n_Max_iter = num;
            end
        end
    end

    function ocr_restricoes_duvida(source,eventdata)
        gui.janela_restricoes = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-195,330,200]);
        gui.restricoes_q_text = uicontrol('Parent',gui.janela_restricoes,...
                'Style','text',...
                'String',{'os valores de rp_o, rb_o, beta_p e beta_b sao opcionais. caso se esteja usando a FUNCAO penalidade, rb_o e beta_b nao sao nescessarios.',...
                'seus valores padrao sao respectivamente 1, 10, 10, 0.1. caso qualquer valor nao numerico seja informado, serao usados os valores padrao.'},...
                'HorizontalAlignment','left',...
                'Position',[10,0,300,100]);
        update()
    end

    function popupMenuOCR(source,eventdata)
        gui.GeH_restricaoInput.String = 'Inserir';
        gui.GeH_restricaoCheck.Value = 0;
        gui.restricaoCheck.Value = 0;
        gui.restricaoInput.String = 'Inserir';
        puOCRval = get(gui.puMenu_OCR,'Value');
        if puOCRval >=3 && puOCRval <=4
            gui.puMenu_OSR.Visible = 'on';
            gui.puTOL_OSR.Visible = 'on';
            gui.editTOL_OSR.Visible = 'on';
        else
            gui.puMenu_OSR.Visible = 'off';
            gui.puTOL_OSR.Visible = 'off';
            gui.editTOL_OSR.Visible = 'off';
            set(gui.puMenu_OSR,'Value',1);        
            gui.puMenu_LSearch.Visible = 'off';
            gui.puTOL_LSearch.Visible = 'off';  
            gui.editTOL_LSearch.Visible = 'off';  
        end
        if puOCRval == 3            
            gui.sText_restricao.Visible = 'on';
            gui.restricaoCheck.Visible = 'on';
            gui.restricaoInput.Visible = 'on';
            gui.sText_r_p_o.Visible = 'on';
            gui.sText_beta_p.Visible = 'on';
            gui.sText_r_b_o.Visible = 'off';
            gui.sText_beta_b.Visible = 'off';
            gui.rp_o_Input.Visible = 'on';
            gui.beta_p_Input.Visible = 'on';
            gui.rb_o_Input.Visible = 'off';
            gui.beta_b_Input.Visible = 'off';            
            gui.help_ocr_restricao.Visible = 'on';
        else if puOCRval == 4                
                gui.sText_restricao.Visible = 'on';
                gui.restricaoCheck.Visible = 'on';
                gui.restricaoInput.Visible = 'on';
                gui.sText_r_p_o.Visible = 'on';
                gui.sText_beta_p.Visible = 'on';
                gui.sText_r_b_o.Visible = 'on';
                gui.sText_beta_b.Visible = 'on';
                gui.rp_o_Input.Visible = 'on';
                gui.beta_p_Input.Visible = 'on';
                gui.rb_o_Input.Visible = 'on';
                gui.beta_b_Input.Visible = 'on';
                gui.help_ocr_restricao.Visible = 'on';
            else                
                gui.sText_restricao.Visible = 'off';
                gui.restricaoCheck.Visible = 'off';
                gui.restricaoInput.Visible = 'off';
                gui.sText_r_p_o.Visible = 'off';
                gui.sText_beta_p.Visible = 'off';
                gui.sText_r_b_o.Visible = 'off';
                gui.sText_beta_b.Visible = 'off';
                gui.rp_o_Input.Visible = 'off';
                gui.beta_p_Input.Visible = 'off';
                gui.rb_o_Input.Visible = 'off';
                gui.beta_b_Input.Visible = 'off';
                gui.help_ocr_restricao.Visible = 'off';                
            end
        end            
        update()
    end

    function popupMenuOSR(source,eventdata)
        puOSRval = get(gui.puMenu_OSR,'Value');
        if puOSRval ~= 1
            gui.puMenu_LSearch.Visible = 'on';
            gui.puTOL_LSearch.Visible = 'on';
            gui.editTOL_LSearch.Visible = 'on';
        else
            gui.puMenu_LSearch.Visible = 'off';
            gui.puTOL_LSearch.Visible = 'off';
            gui.editTOL_LSearch.Visible = 'off';
            set(gui.puMenu_LSearch,'Value',1);
        end
        update()
    end

    function popupMenuLSearch(source,eventdata)
        str = get(gui.puMenu_LSearch, 'String');
        val = get(gui.puMenu_LSearch,'Value');
        switch str{val}
            case 'passo constante'
                gui.puTOL_LSearch.String = 'da';
            case 'passo incremental'
                gui.puTOL_LSearch.String = 'da';
            case 'armijo'
                gui.puTOL_LSearch.String = 'da';
            case 'bissecao'
                gui.puTOL_LSearch.String = 'TOL';
            case 'secao aurea'
                gui.puTOL_LSearch.String = 'TOL';
            otherwise
                gui.puTOL_LSearch.String = 'TOL';
        end
        update()
    end

    function radioButtonOSR(source,eventdata)        
        set(gui.puMenu_OSR,'Value',1);
        set(gui.puMenu_OCR,'Value',1);
        set(gui.puMenu_LSearch,'Value',1);
        gui.rBtn_OCR.Value = 0;        
        gui.puMenu_OSR.Visible = 'on';
        gui.puMenu_OCR.Visible = 'off';
        gui.puTOL_OSR.Visible = 'on';
        gui.puTOL_OCR.Visible = 'off';
        gui.editTOL_OSR.Visible = 'on';
        gui.editTOL_OCR.Visible = 'off';
        gui.puMenu_OSR.Position = [10,gui.tamanho_y-130,200,15];
        gui.puTOL_OSR.Position = [215,gui.tamanho_y-135,25,15];
        gui.editTOL_OSR.Position = [255,gui.tamanho_y-135,23,15];
        gui.puMenu_LSearch.Position = [10,gui.tamanho_y-160,200,15];
        gui.puTOL_LSearch.Position = [215,gui.tamanho_y-165,25,15];        
        gui.editTOL_LSearch.Position = [255,gui.tamanho_y-165,23,15];
        gui.puMenu_LSearch.Visible = 'off';
        gui.puTOL_LSearch.Visible = 'off';
        gui.editTOL_LSearch.Visible = 'off';
        gui.puTOL_help.Visible = 'on';
        gui.TOL_q.Visible = 'on';
        gui.sText_restricao.Visible = 'off';
        gui.restricaoCheck.Visible = 'off';
        gui.restricaoInput.Visible = 'off';
        gui.sText_r_p_o.Visible = 'off';
        gui.sText_beta_p.Visible = 'off';
        gui.sText_r_b_o.Visible = 'off';
        gui.sText_beta_b.Visible = 'off';
        gui.rp_o_Input.Visible = 'off';
        gui.beta_p_Input.Visible = 'off';
        gui.rb_o_Input.Visible = 'off';
        gui.beta_b_Input.Visible = 'off';
        gui.help_ocr_restricao.Visible = 'off';
        gui.sText_GeH_restricao.Visible = 'off';
        gui.GeH_restricaoInput.Visible = 'off';
        gui.GeH_restricaoInput.String = 'Inserir';
        gui.GeH_restricaoCheck.Visible = 'off';
        gui.GeH_restricaoCheck.Value = 0;
        gui.restricaoCheck.Value = 0;
        gui.restricaoInput.String = 'Inserir';
        update()
        if gui.rBtn_OSR.Value == 0             
            gui.puMenu_OSR.Visible = 'off';
            gui.puTOL_OSR.Visible = 'off';
            gui.editTOL_OSR.Visible = 'off';
            gui.puTOL_help.Visible = 'off';
            gui.TOL_q.Visible = 'off';
        end
    end

    function radioButtonOCR(source,eventdata)
        gui.rBtn_OSR.Value = 0;        
        set(gui.puMenu_OSR,'Value',1);
        set(gui.puMenu_OCR,'Value',1);
        set(gui.puMenu_LSearch,'Value',1);
        gui.puMenu_OCR.Visible = 'on';
        gui.puTOL_OCR.Visible = 'on';
        gui.editTOL_OCR.Visible = 'on';
        gui.sText_restricao.Visible = 'on';
        gui.sText_restricao.String = 'RESTRICOES h/c(x):';
        gui.restricaoCheck.Visible = 'on';
        gui.restricaoInput.Visible = 'on';        
        puOCRval = get(gui.puMenu_OCR,'Value');
        if puOCRval==1 || puOCRval == 2 || puOCRval >= 5
            gui.puMenu_OSR.Visible = 'off';
            gui.puTOL_OSR.Visible = 'off';
            gui.editTOL_OSR.Visible = 'off';
            set(gui.puMenu_OSR,'Value',1);   
            gui.puMenu_LSearch.Visible = 'off';
            gui.puTOL_LSearch.Visible = 'off';
            gui.editTOL_LSearch.Visible = 'off';
            set(gui.puMenu_LSearch,'Value',1);
        end
        gui.puMenu_OSR.Position = [10,gui.tamanho_y-160,200,15];
        gui.puTOL_OSR.Position = [215,gui.tamanho_y-165,25,15];
        gui.editTOL_OSR.Position = [255,gui.tamanho_y-165,23,15];
        gui.puMenu_LSearch.Position = [10,gui.tamanho_y-190,200,15];
        gui.puTOL_LSearch.Position = [215,gui.tamanho_y-195,25,15];
        gui.editTOL_LSearch.Position = [255,gui.tamanho_y-195,23,15];
        gui.puTOL_help.Visible = 'on';
        gui.TOL_q.Visible = 'on';
        update()
        if gui.rBtn_OCR.Value == 0             
            gui.puMenu_OCR.Visible = 'off';
            gui.puTOL_OCR.Visible = 'off';
            gui.editTOL_OCR.Visible = 'off';
            gui.puTOL_help.Visible = 'off';
            gui.TOL_q.Visible = 'off';
            gui.sText_restricao.Visible = 'off';
            gui.restricaoCheck.Visible = 'off';
            gui.restricaoInput.Visible = 'off';
            gui.sText_r_p_o.Visible = 'off';
            gui.sText_beta_p.Visible = 'off';
            gui.sText_r_b_o.Visible = 'off';
            gui.sText_beta_b.Visible = 'off';
            gui.rp_o_Input.Visible = 'off';
            gui.beta_p_Input.Visible = 'off';
            gui.rb_o_Input.Visible = 'off';
            gui.beta_b_Input.Visible = 'off';
            gui.help_ocr_restricao.Visible = 'off';
            gui.sText_GeH_restricao.Visible = 'off';
            gui.GeH_restricaoInput.Visible = 'off';
            gui.GeH_restricaoInput.String = 'Inserir';
            gui.GeH_restricaoCheck.Visible = 'off';
            gui.GeH_restricaoCheck.Value = 0;
            gui.restricaoCheck.Value = 0;
            gui.restricaoInput.String = 'Inserir';
        end
    end

    function restricaoIcall(source,eventdata)
         gui.restricoes_can_check = 1;
         gui.janela_restricao = figure('Resize','on',...
                   'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-350,450,355],...
                   'CloseRequestFcn',@restricoes_janela_close_req);
         gui.restricao_text = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String',{'Abaixo deve-se inserir o nome das FUNCOES de RESTRICAO, cujo arquivo *.m tem de estar no path do MATLAB, preferencialmente, no mesmo diretorio deste arquivo',...
                           'onde h_k(x) = 0 e c_l(x) <=0. Deve ter portanto como entrada x, apenas',...
                           'ou seja, h_k sao as RESTRICOES de igualdade e c_l sao as RESTRICOES de desigualdade',...
                           'para o segundo botao apertado, pode-se inserir a FUNCAO em formato texto similar a INSERCAO da FUNCAO f',...
                           'Apos escolhida a forma de insercao e digitada a FUNCAO, clica-se em "+1"',...
                           'para apagar a ultima FUNCAO digitada, clica-se no botao "-1" ao lado da respectiva RESTRICAO, e para apagar todas, no botao "reset"'},...
                 'HorizontalAlignment','left',...
                 'Position',[10,105,410,155]);
         gui.restricoes_toggle_nome = uicontrol('Parent',gui.janela_restricao,... 
                 'Style','togglebutton',...
                 'String','nome da FUNCAO',...
                 'Position',[40,100,160,20],...
                 'Callback',@restricao_toggle_nome_call);
         gui.restricoes_toggle_f_por_text = uicontrol('Parent',gui.janela_restricao,... 
                 'Style','togglebutton',...
                 'String','a*x(i)^b + sin(x(j) + exp(x(k))*c',...
                 'Position',[230,100,160,20],...
                 'Callback',@restricao_toggle_texto_call,...
                 'Enable','inactive',...
                 'ForegroundColor',[1 1 1]);
         gui.restricao_igualdade_text = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String','h_k(x):',...
                 'HorizontalAlignment','left',...
                 'Position',[10,60,38,20]);
         gui.restricao_igualdade_count = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String','0',...
                 'HorizontalAlignment','left',...
                 'Position',[275,65,38,15]);
         gui.restricao_igualdade_edit = uicontrol('Parent',gui.janela_restricao,...
                 'Style','edit',...
                 'HorizontalAlignment','left',...
                 'Position',[50,60,215,20]);
         gui.restricao_igualdade_M1 = uicontrol('Parent',gui.janela_restricao,...
                 'Style','pushbutton',...
                 'String','+1',...
                 'HorizontalAlignment','left',...
                 'Position',[300,60,25,20],...
                 'Callback',@restricao_igualdade_M1_call,...
                 'Enable','inactive',...
                 'ForegroundColor',[1 1 1]);
         gui.restricao_igualdade_m1 = uicontrol('Parent',gui.janela_restricao,...
                 'Style','pushbutton',...
                 'String','-1',...
                 'HorizontalAlignment','left',...
                 'Position',[330,60,25,20],...
                 'Callback',@restricao_igualdade_m1_call);
         gui.restricoes_count_help = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String','count:',...
                 'HorizontalAlignment','left',...
                 'Position',[265,80,38,15]);
         gui.restricao_desigualdade_text = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String','c_l(x):',...
                 'HorizontalAlignment','left',...
                 'Position',[10,30,38,20]);
         gui.restricao_desigualdade_count = uicontrol('Parent',gui.janela_restricao,...
                 'Style','text',...
                 'String','0',...
                 'HorizontalAlignment','left',...
                 'Position',[275,35,38,15]);
         gui.restricao_desigualdade_edit = uicontrol('Parent',gui.janela_restricao,...
                 'Style','edit',...
                 'HorizontalAlignment','left',...
                 'Position',[50,30,215,20]);
         gui.restricao_desigualdade_M1 = uicontrol('Parent',gui.janela_restricao,...
                 'Style','pushbutton',...
                 'String','+1',...
                 'HorizontalAlignment','left',...
                 'Position',[300,30,25,20],...
                 'Callback',@restricao_desigualdade_M1_call,...
                 'Enable','inactive',...
                 'ForegroundColor',[1 1 1]);
         gui.restricao_desigualdade_m1 = uicontrol('Parent',gui.janela_restricao,...
                 'Style','pushbutton',...
                 'String','-1',...
                 'HorizontalAlignment','left',...
                 'Position',[330,30,25,20],...
                 'Callback',@restricao_desigualdade_m1_call);
         gui.restricoes_reset = uicontrol('Parent',gui.janela_restricao,...
                 'Style','pushbutton',...
                 'String','RESET',...
                 'Position',[370,30,50,50],...
                 'Callback',@restricao_reset_call);
         % deve existir arquivo.m no path do matlab!
        update()
    end

    function restricoes_janela_close_req(source,eventdata)
        gui.restricoes_can_check = 0;
        delete(gui.janela_restricao);
    end

    function restricao_toggle_nome_call(source,eventdata)
        if gui.restricoes_toggle_nome.Value == 1
            gui.restricao_igualdade_M1.Enable = 'on';
            gui.restricao_desigualdade_M1.Enable = 'on';
            gui.restricao_igualdade_M1.ForegroundColor = [0 0 0];
            gui.restricao_desigualdade_M1.ForegroundColor = [0 0 0];
        else
            gui.restricao_igualdade_M1.Enable = 'off';
            gui.restricao_desigualdade_M1.Enable = 'off';
            gui.restricao_igualdade_M1.ForegroundColor = [1 1 1];
            gui.restricao_desigualdade_M1.ForegroundColor = [1 1 1];
        end
    end

    function restricao_toggle_texto_call(source,eventdata)
        % abilitar botao
    end

    function restricao_igualdade_M1_call(source,eventdata)
        k_h_num = str2double(gui.restricao_igualdade_count.String);
        k_h_num = k_h_num+1;
        gui.restricao_igualdade_count.String = num2str(k_h_num);
        h_aux_text = get(gui.restricao_igualdade_edit,'String');
        h_aux_k_func = str2func(h_aux_text);
        gui.restricao_h{k_h_num}=h_aux_k_func;
        update()
    end

    function restricao_igualdade_m1_call(source,eventdata)
        k_h_num = str2double(gui.restricao_igualdade_count.String);
        if k_h_num ~= 0
            k_h_num = k_h_num-1;
            gui.restricao_igualdade_count.String = num2str(k_h_num);
            for i = 1:1:k_h_num
               restricao_h_aux{i} = gui.restricao_h{i}; 
            end
            if k_h_num == 0
                gui.restricao_h = {};
            else
                gui.restricao_h = restricao_h_aux;
            end
        end
        update()
    end

    function restricao_desigualdade_M1_call(source,eventdata)
        l_c_num = str2double(gui.restricao_desigualdade_count.String);
        l_c_num = l_c_num+1;
        gui.restricao_desigualdade_count.String = num2str(l_c_num);
        c_aux_text = get(gui.restricao_desigualdade_edit,'String');
        c_aux_l_func = str2func(c_aux_text);
        gui.restricao_c{l_c_num}=c_aux_l_func;
        update()
    end    

    function restricao_desigualdade_m1_call(source,eventdata)
        l_c_num = str2double(gui.restricao_desigualdade_count.String);
        if l_c_num ~= 0
            l_c_num = l_c_num-1;        
            gui.restricao_desigualdade_count.String = num2str(l_c_num);
            for i = 1:1:l_c_num
               restricao_c_aux{i} = gui.restricao_c{i}; 
            end
            if l_c_num == 0
                gui.restricao_c = {};    
            else
                gui.restricao_c = restricao_c_aux;
            end
        end
        update()
    end   

    function restricao_reset_call(source,eventdata)
        %retira todos c's e h's
        gui.restricao_igualdade_count.String = '0';
        gui.restricao_desigualdade_count.String = '0';
        update()
    end

    function rp_o_Icall(source,eventdata)
        gui.rp_o = 1; % valor padrao
        var = get(gui.rp_o_Input,'String');
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.rp_o = num;
            end
        end
    end

    function rb_o_Icall(source,eventdata)
        gui.rb_o = 10; % valor padrao
        var = get(gui.rb_o_Input,'String');
        if ~isempty(var)
            num = str2double(var);
            if ~isnan(num)
                gui.rb_o = num;
            end
        end
    end

    function resetCall(source,eventdata)
        %reset all values        
        set(gui.puMenu_OSR,'Value',1);
        set(gui.puMenu_OCR,'Value',1);
        set(gui.puMenu_LSearch,'Value',1);
        gui.rBtn_OCR.Value = 0;        
        gui.rBtn_OSR.Value = 0;
        gui.puMenu_OSR.Visible = 'off';
        gui.puMenu_OCR.Visible = 'off'; 
        gui.puMenu_LSearch.Visible = 'off';                
        gui.puTOL_OSR.Visible = 'off';        
        gui.puTOL_LSearch.Visible = 'off';        
        gui.puTOL_OCR.Visible = 'off';
        gui.puTOL_help.Visible = 'off';
        gui.editTOL_OCR.Visible = 'off';
        gui.editTOL_OSR.Visible = 'off';
        gui.editTOL_LSearch.Visible = 'off';
        gui.gCheck.Visible = 'off';
        gui.gInput.Visible = 'off';
        gui.hCheck.Visible = 'off';
        gui.hInput.Visible = 'off';        
        gui.sText_restricao.Visible = 'off';
        gui.restricaoCheck.Visible = 'off';
        gui.restricaoInput.Visible = 'off';
        gui.xCheck.Value = 0;
        gui.xInput.String = 'Inserir';        
        gui.fCheck.Value = 0;
        gui.fInput.String = 'Inserir';
        gui.gCheck.Value = 0;
        gui.gInput.String = 'Inserir';
        gui.hCheck.Value = 0;
        gui.hInput.String = 'Inserir';        
        gui.restricaoCheck.Value = 0;
        gui.restricaoInput.String = 'Inserir';
        gui.x_o = 0;
        gui.f_button_active = 0;
        gui.f_text = '';
        gui.function = '';
        gui.g_button_active = 0;
        gui.g_text = '';
        gui.grad = '';
        gui.h_button_active = 0;
        gui.h_text = '';
        gui.hess = '';
        gui.x0Ans.String = '';
        gui.mAns.String = '';
        gui.tAns.String = '';
        gui.mpAns.String = '';
        gui.xmAns.String = '';
        gui.restricao_c = {};
        gui.restricao_h = {};
        gui.grad_restricao_c = {};
        gui.grad_restricao_h = {};
        gui.hess_restricao_c = {};
        gui.hess_restricao_h = {};
        gui.TOL_q.Visible = 'off';
        gui.sText_restricao.Visible = 'off';
        gui.restricaoCheck.Visible = 'off';
        gui.restricaoInput.Visible = 'off';
        gui.sText_r_p_o.Visible = 'off';
        gui.sText_beta_p.Visible = 'off';
        gui.sText_r_b_o.Visible = 'off';
        gui.sText_beta_b.Visible = 'off';
        gui.rp_o_Input.Visible = 'off';
        gui.beta_p_Input.Visible = 'off';
        gui.rb_o_Input.Visible = 'off';
        gui.beta_b_Input.Visible = 'off';
        gui.help_ocr_restricao.Visible = 'off';        
        gui.sText_GeH_restricao.Visible = 'off';
        gui.GeH_restricaoInput.Visible = 'off';
        gui.GeH_restricaoInput.String = 'Inserir';
        gui.GeH_restricaoCheck.Visible = 'off';
        gui.GeH_restricaoCheck.Value = 0;
        update()
    end

    function TOL_duvida(source,eventdata)
        gui.janela_TOL = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-155,330,240]);
        gui.TOL_d_text = uicontrol('Parent',gui.janela_TOL,...
                'Style','text',...
                'String',{'na caixa de INSERCAO ao lado de "TOL", deve se inserir a potencia de 1/10 que sera a tolerancia da etapa de minimizacao ao lado. Caso a caixa fique em branco ou seja inserido um valor nao numerico, sera usada TOL padrao = 10^-5',...
                'no caso de estar escrito "da" : delta_alfa, o valor da padrao = 0.01 (10^-2)',...
                'Para o Metodo de armijo tambem podera ser informado o valor de "m", cujo valor padrao e 0.3',...
                'O valor padrao do numero maximo de iteracoes e 500'},...
                'HorizontalAlignment','left',...
                'Position',[10,5,300,140]);
        update()
    end

    function xIcall(source,eventdata)
        gui.janela_x = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-195-50,320,250]);    
        % gui.xBtn_1 = uicontrol('Parent','gui.janela_x',...
        %     'Style','togglebutton',...
        %     'String','');
        gui.xEdit = uicontrol('Parent',gui.janela_x,...
                'Style','edit',...
                'HorizontalAlignment','left',...
                'Position',[10,20,285,20],...
                'Callback',@xEcall);
        gui.x_text = uicontrol('Parent',gui.janela_x,...
                'Style','text',...
                'String',{'Inserir x_o com os valores x_o(i) separados por espacos, por exemplo "2 2 2 0 3 1 5".',...
                          'O numero de termos inseridos a serem lidos sera n. caso sejam inseridos mais termos estes serao ignorados. caso sejam inseridos menos termos sera adotado o valor 0 para os demais.',...
                          'Para numeros nao inteiros deve-se usar ".", exemplo: "50.413"'},...
                'HorizontalAlignment','left',...
                'Position',[10,45,285,110]);
        update()
    end

    function xEcall(source,eventdata)
        gui.x_o = zeros(1,gui.n);
        var = get(gui.xEdit,'String');
        num = str2num(var); %#ok<ST2NM>        
        for i = 1:1:min(gui.n,length(num))
            gui.x_o(i) = num(i);
        end
        x_o_string = '[  ';
        x_o_string = strcat(x_o_string,{'  '});
        for i = 1:1:length(gui.x_o);
            x_o_string = strcat(x_o_string,num2str(gui.x_o(i)));
            x_o_string = strcat(x_o_string,{'  '});
        end
        x_o_string = strcat(x_o_string,']');
        gui.x0Ans.String = x_o_string;
        gui.xCheck.Value = 1;
        gui.xInput.String = 'Modif.';
        update()
    end

    %%%% FUNCOES INDEPENDENTES DE CALLBACK %%%%%%%%%%%%%%%%%%%%%%%%%

    function update()
        if gui.restricoes_can_check == 1
            if ~strcmp(gui.restricao_igualdade_count.String,'0') || ~strcmp(gui.restricao_desigualdade_count.String,'0')
                gui.restricaoCheck.Value = 1;            
                gui.sText_GeH_restricao.Visible = 'on';
                gui.GeH_restricaoInput.Visible = 'on';
                gui.GeH_restricaoCheck.Visible = 'on';
                gui.GeH_restricaoInput.String = 'Inserir';
                gui.restricaoInput.String = 'Modificar';
            else
                gui.restricaoCheck.Value = 0;
                gui.sText_GeH_restricao.Visible = 'off';
                gui.GeH_restricaoInput.Visible = 'off';
                gui.GeH_restricaoCheck.Visible = 'off';
                gui.GeH_restricaoInput.String = 'Inserir';
                gui.restricaoInput.String = 'Inserir';
                gui.GeH_restricaoCheck.Value = 0;
                gui.restricao_c = {};
                gui.restricao_h = {};
                gui.grad_restricao_c = {};
                gui.grad_restricao_h = {};
                gui.hess_restricao_c = {};
                gui.hess_restricao_h = {};
            end
        end
        if gui.xCheck.Value == 1 &&...
                gui.fCheck.Value == 1 &&...
                gui.gCheck.Value == 1 &&...
                gui.hCheck.Value == 1 &&...
                gui.puMenu_LSearch.Value ~= 1
            if gui.rBtn_OCR.Value == 1
                if  gui.restricaoCheck.Value == 1  && gui.GeH_restricaoCheck.Value == 1              
                    gui.minimize.Enable = 'on';
                    gui.minimize.ForegroundColor = [0,0,0];
                else
                    gui.minimize.Enable = 'inactive';
                    gui.minimize.ForegroundColor = [1,1,1];            
                    gui.OCR = '';
                    gui.OSR = '';
                    gui.LSearch = '';
                end
            else if gui.rBtn_OSR.Value == 1                    
                gui.minimize.Enable = 'on';
                gui.minimize.ForegroundColor = [0,0,0];
                end
            end
        else
            gui.minimize.Enable = 'inactive';
            gui.minimize.ForegroundColor = [1,1,1];            
            gui.OCR = '';
            gui.OSR = '';
            gui.LSearch = '';
        end
        if gui.puMenu_LSearch.Value ~= 1            
            gui.nmaxIt_edit.Visible = 'on';
            gui.nmaxIt_text.Visible = 'on';
        else
            gui.nmaxIt_edit.Visible = 'off';
            gui.nmaxIt_text.Visible = 'off';
        end        
        str = get(gui.puMenu_LSearch, 'String');
        val = get(gui.puMenu_LSearch,'Value');
        if strcmp(str(val),'armijo')
            gui.puArmijo_m.Visible = 'on' ;
            gui.editArmijo_m.Visible = 'on';
        else
            gui.puArmijo_m.Visible = 'off' ;
            gui.editArmijo_m.Visible = 'off';
        end
    end

    function escolhaOCR()
        str = get(gui.puMenu_OCR, 'String');
        val = get(gui.puMenu_OCR,'Value');
        switch str{val}
            case 'penalidade'
                gui.OCR = str2func('penalidade');
                escolhaOSR();
            case 'barreira'
                gui.OCR = str2func('barreira');
                escolhaOSR();
            otherwise
                error('escolha um Metodo de otimizacao sem RESTRICOES, atencao as opcoes que servem como classificadores, ex.: ---- XXXX -----');
        end
    end

    function escolhaOSR()
        str = get(gui.puMenu_OSR, 'String');
        val = get(gui.puMenu_OSR,'Value');
        switch str{val}
            case 'univariante'
                gui.OSR = str2func('univariante');
            case 'powell'
                gui.OSR = str2func('powell');
            case 'Steepest Descent'
                gui.OSR = str2func('steepest');
            case 'Fletcher-Reeves'
                gui.OSR = str2func('f_reeves');
            case 'BFGS'
                gui.OSR = str2func('bfgs');
            case 'Newton-Raphson'
                gui.OSR = str2func('n_raphson');
            otherwise
                error('escolha um Metodo de otimizacao sem RESTRICOES, a opcao inicial e apenas o indicador do tipo de metodo');
        end
        escolhaLSearch();
    end

    function escolhaLSearch()
        str = get(gui.puMenu_LSearch, 'String');
        val = get(gui.puMenu_LSearch,'Value');
        switch str{val}
            case 'passo constante'
                gui.LSearch = str2func('min_p_cte_Fun');
            case 'passo incremental'
                gui.LSearch = str2func('min_p_inc_Fun');
            case 'armijo'
                gui.LSearch = str2func('min_armijo_Fun');
            case 'bissecao'
                gui.LSearch = str2func('min_biss_Fun');
            case 'secao aurea'
                gui.LSearch = str2func('min_aur_Fun');
            otherwise
                error('escolha um Metodo de otimizacao sem RESTRICOES, a opcao inicial e apenas o indicador do tipo de metodo');
        end
    end

    function error(string_do_erro)
        %%%
        gui.janela_error = figure('Resize','on',...
                  'OuterPosition',[gui.tela_x/4+gui.tamanho_x/2,(gui.tela_y+gui.tamanho_y)/2-155,330,240]);
        gui.error_texto = uicontrol('Parent',gui.janela_error,...
                'Style','text',...
                'String',string_do_erro,...
                'HorizontalAlignment','left',...
                'Position',[10,5,300,140]);
        update()
    end

    function plotResultados()
        % 1 passo : desenhar as curvas de nivel ou grafico da FUNCAO
        if gui. n == 1            
            title_text = pegarMetodo();
            limite = 1.5*max([gui.x_o(1),gui.x_m(1)]);
            x1 = -limite:0.1:limite;
            for i = 1:1:length(x1)
                f_x1(i) = gui.function(x1(i));
            end
            f_xo = gui.function(gui.x_o);
            for i = 1:1:length(gui.plotdata)
                f_data(i) = gui.function(gui.plotdata(i));
            end
            plot(x1,f_x1,'-k');
            hold on
            plot(gui.plotdata,f_data,'*-b');
            hold on
            plot(gui.x_o,f_xo,'sr'); 
            title(title_text)
        else if gui.n == 2
                title_text = pegarMetodo();
                limite = 1.5*max(abs([gui.x_o(1),gui.x_m(1),gui.x_o(2),gui.x_m(2),gui.plotdata(1,:),gui.plotdata(2,:)]));
                x1 = -limite:0.1:limite;
                x2 = -limite:0.1:limite;
                f_x1x2 = zeros(length(x1),length(x2));
                for i = 1:1:length(x1)
                    for j = 1:1:length(x2)
                        f_x1x2(i,j) = gui.function([x2(j),x1(i)]);
                    end
                end                
                contour('Parent',gui.graf,x1,x2,f_x1x2,'ShowText','on')
                hold on
                plot(gui.plotdata(1,:),gui.plotdata(2,:),'*-b');
                hold on
                plot(gui.x_o(1),gui.x_o(2),'sr');
                hold on
                if gui.rBtn_OCR.Value == 1
                    % plot RESTRICOES
                    if ~isempty(gui.restricao_h)
                        for i = 1:1:length(gui.restricao_h)
                            %%fimplicit(gui.restricao_h{i},'--g')
                            hold on
                        end
                    end
                    if ~isempty(gui.restricao_c)
                        for i = 1:1:length(gui.restricao_c)
                            %%fimplicit(gui.restricao_c{i},'.-r')
                            hold on
                        end
                    end
                end
                title(title_text)    
            else if gui.n >2
                    error('');
                end
            end
        end
    end

    function metodo_string = pegarMetodo()
        if gui.rBtn_OCR.Value == 1
            str = get(gui.puMenu_OCR, 'String');
            val = get(gui.puMenu_OCR,'Value');
            metodo_string = str{val};
        else if gui.rBtn_OSR.Value == 1
                str = get(gui.puMenu_OSR, 'String');
                val = get(gui.puMenu_OSR,'Value');
                metodo_string = str{val};
            end
        end
    end

    function checagemDeErrosNaMinimizacao()
        if isempty(gui.erros_na_minimizacao);
            %%% nao houveram erros     
            texto_aux = strcat('nenhuma das etapas da minimizacao precisou de mais de .',num2str(gui.n_Max_iter));
            texto = strcat(texto_aux,'. iteracoes');
            error(texto)
        else if length(gui.erros_na_minimizacao) == 3
                if strcmp(gui.erros_na_minimizacao{1},'')
                    texto_1 = strcat('a etapa de busca linear da minimizacao nao chegou ao numero maximo de iteracoes nenhuma vez que foi chamada');
                else
                    texto_aux_1 = strcat('a etapa de busca linear da minimizacao chegou ao numero maximo de iteracoes .',num2str(gui.erros_na_minimizacao{2}));
                    texto_1 = strcat(texto_aux_1,'. vezes');
                end
                if strcmp(gui.erros_na_minimizacao{3},'')
                    texto_2 = strcat('a etapa de otimizacao sem RESTRICOES da minimizacao nao chegou ao numero maximo de iteracoes');
                else
                    texto_2 = strcat('a etapa de otimizacao sem RESTRICOES da minimizacao chegou ao numero maximo de iteracoes');
                end                
                error({texto_1,'',texto_2});
            else if length(gui.erros_na_minimizacao) == 5
                    if strcmp(gui.erros_na_minimizacao{1},'')
                        texto_1 = strcat('a etapa de busca linear da minimizacao nao chegou ao numero maximo de iteracoes nenhuma vez que foi chamada');
                    else
                        texto_aux_1 = strcat('a etapa de busca linear da minimizacao chegou ao numero maximo de iteracoes .',num2str(gui.erros_na_minimizacao{2}));
                        texto_1 = strcat(texto_aux_1,'. vezes');
                    end
                    if strcmp(gui.erros_na_minimizacao{3},'')
                        texto_2 = strcat('a etapa de otimizacao SEM RESTRICOES da minimizacao nao chegou ao numero maximo de iteracoes nenhuma vez que foi chamada');
                    else
                        texto_aux_2 = strcat('a etapa de otimizacao SEM RESTRICOES da minimizacao chegou ao numero maximo de iteracoes .',num2str(gui.erros_na_minimizacao{4}));
                        texto_2 = strcat(texto_aux_2,'. vezes');
                    end
                    if strcmp(gui.erros_na_minimizacao{5},'')
                        texto_3 = strcat('a etapa de otimizacao COM RESTRICOES da minimizacao nao chegou ao numero maximo de iteracoes');
                    else
                        texto_3 = strcat('a etapa de otimizacao COM RESTRICOES da minimizacao chegou ao numero maximo de iteracoes');
                    end 
                    error({texto_1,'',texto_2,'',texto_3});
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% funcoes de minimizacao %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------% 
%-------- O S R -----------------------------------------------%
% gui.OSR(gui.x_o,gui.function,gui.grad,gui.hess,gui.LSearch,gui.TOL_OSR,gui.TOL_LSearch,gui.n_Max_iter,gui.armijo_m);

%%%%% UNIVARIANTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = univariante(x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k)        
        % h_fi nao e usada neste metodo. porem pode ser usada para verificar
        % max/min
        % verificacao se foi colocado MAXITE, caso contrario usar padrao
        tic
        erros = {'',0,''};
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end
        if nargin < 9
            m = 0.3;
        end
        if nargin < 8 
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end
        n_iter = 0;        
        k=1;
        d_k = x_o*0;
        x_k = x_o;    
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%    
        while n_iter < n_max_iter    
            erro_k = '';
            if ocr_flag
                grad = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad = g_fi(x_k,fi);            
                else
                    grad = g_fi(x_k);
                end
            end
            norma_g = grad*grad';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end
            d_k(k)=1;
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            d_k(k)=0;
            k=k+1;
            if k > (length(x_o))
                k=1;
            end        
            n_iter = n_iter+1;        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end

%%%%% POWELL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = powell(x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k)
        % h_f nao e usada neste Metodo. porem pode ser usada para verificar
        % max/min
        tic
        erros = {'',0,''};
        % verificacao se foi colocado MAXITE, caso contrario usar padrao 
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end       
        if nargin < 9
            m = 0.3;
        end
        if nargin < 8
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end   
        n_iter = 0;        
        k=1;
        p=0;
        d_k = x_o*0;
        x_k = x_o;
        dp= x_o*0;    
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%    
        while n_iter < n_max_iter       
            erro_k = '';
            if ocr_flag
                grad = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad = g_fi(x_k,fi);            
                else
                    grad = g_fi(x_k);
                end
            end
            norma_g = grad*grad';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end        
            if p == 0
                d_k(k)=1;
            else
                if k <= (length(x_o) - p) && k>0
                    d_k(k+p)=1;
                elseif k == 0
                    d_k = dp(p,:);
                elseif k> (length(x_o)-p)
                    d_k = dp((k+p-length(x_o)),:);
                end
            end
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            d_k = d_k*0;    
            if p > length(x_o)
               p = 0;
               dp = x_o*0;
               k = 0;
            end        
            k=k+1;
            if k > (length(x_o))
                k=0;
                p=p+1;            
                dp(p,:) = [x_k - x_o]';
            end
            if k==1
                x_o = x_k;
                d_k = d_k*0;
            end    
            n_iter = n_iter+1;    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end    

%%%%% STEEPEST DESCENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = steepest( x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k)
        % h_f nao e usada neste Metodo. porem pode ser usada para verificar
        % max/min
        tic
        erros = {'',0,''};
        % verificacao se foi colocado MAXITE, caso contrario usar padrao        
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end  
        if nargin < 9
            m = 0.3;
        end
        if nargin < 8 
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end   
        n_iter = 0;
        d_k = x_o*0;
        x_k = x_o;    
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%    
        while n_iter < n_max_iter
            erro_k = '';
            if ocr_flag
                grad = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad = g_fi(x_k,fi);            
                else
                    grad = g_fi(x_k);
                end
            end
            norma_g = grad*grad';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end
            d_k = -grad;        
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            n_iter = n_iter+1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%                
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end

%%%%% FLETCHER REEVES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = f_reeves( x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k)
        % h_f nao e usada neste Metodo. porem pode ser usada para verificar
        % max/min
        tic
        erros = {'',0,''};
        % verificacao se foi colocado MAXITE, caso contrario usar padrao       
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end   
        if nargin < 9
            m = 0.3;
        end
        if nargin < 8
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end    
        n_iter = 0;
        d_k = x_o*0;
        x_k = x_o;
        b_k = 0;        
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%    
        while n_iter < n_max_iter    
            erro_k = '';
            if ocr_flag
                grad = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad = g_fi(x_k,fi);            
                else
                    grad = g_fi(x_k);
                end
            end
            norma_g = grad*grad';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end    
            if n_iter == 0
                d_k = -grad;
            else
                b_k = (grad*grad')/(d_k*d_k');
                d_k = -grad + b_k*d_k;
            end    
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            n_iter = n_iter+1;    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end


%%%%% BFGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = bfgs( x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k,S_k)
        % h_f nao e usada neste Metodo. porem pode ser usada para verificar
        % max/min
        tic
        erros = {'',0,''};
        if nargin < 22
            %S_o = eye(length(x_o);
            %caso nao seja especificado um S_o, usa-se a identidade
            %pode-se usar uma FUNCAO do MATLAB. O S_o poderia ter sido
            %fornecido diretamente ao programa ou ate calculado da forma
            %abaixo, como indentidade:        
            S_k = x_o'*x_o*0;
            for i = 1:1:length(x_o)
            S_k(i,i) = 1;
            end
        end
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end           
        if nargin < 9
            m = 0.3;
        end
        % verificacao se foi colocado MAXITE, caso contrario usar padrao
        if nargin < 8
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end   
        n_iter = 0;
        d_k = x_o*0;
        x_k = x_o;
        grad_k = 0;
        grad_o = 0;    
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%        
        while n_iter < n_max_iter     
            erro_k = '';
            if ocr_flag
                grad_k = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad_k = g_fi(x_k,fi);            
                else
                    grad_k = g_fi(x_k);
                end
            end
            norma_g = grad_k*grad_k';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end
            if n_iter == 0
                grad_o = grad_k;
            else
                d_g = grad_k-grad_o;
                d_x = x_k - x_o;
                S_k = S_k + ...
                    (((d_x*(d_g'))+(d_g*S_k*(d_g')))*(d_x')*d_x)/((d_x*(d_g'))^2)-...
                    ((S_k*(d_g')*d_x)+(d_x'*((S_k*(d_g'))')))/(d_x*(d_g'));    
                grad_o = grad_k;
            end        
            aux = -[S_k]*grad_k';
            d_k = aux';
            x_o = x_k;            
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            n_iter = n_iter+1;    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%         
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end


%%%%% NEWTON RAPHSON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = n_raphson( x_o,fi,g_fi,h_fi,busca_lin,tolerancia,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k)
        tic
        erros = {'',0,''};
        % verificacao se foi colocado MAXITE, caso contrario usar padrao
        if nargin < 21
            rb_k = 0;
        end
        if nargin < 10
            ocr_flag = false;
        end  
        if nargin < 9
            m = 0.3;
        end
        if nargin < 8 
            n_max_iter = 500;
        end
        if nargin < 7 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia_lsearch = 10^(-5);
        end
        if nargin < 6 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end   
        n_iter = 0;
        d_k = x_o*0;
        x_k = x_o;        
        %%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,1) = x_o;
        %%%%%%%%%%%%%%%%%%%%%%    
        while n_iter < n_max_iter         
            erro_k = '';
            if ocr_flag
                grad = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k);
            else
                if strcmp(func2str(g_fi),'mdfGrad')
                    grad = g_fi(x_k,fi);            
                else
                    grad = g_fi(x_k);
                end
            end
            norma_g = grad*grad';
            norma_g = norma_g^(1/2);
            if norma_g < tolerancia
                break
            end
            if ocr_flag
                H = pseudo_h(x_k,f,g_f,h_f,restr_f_c,restr_h_h,restr_h_c,rp_k,rb_k);
            else
                if strcmp(func2str(h_fi),'mdfHess')
                    H = h_fi(x_k,g_fi,fi);            
                else
                    H = h_fi(x_k);
                end      
            end
            aux = -[inv(H)]*grad';        
            d_k = aux';
            [x_k,erro_k] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_lsearch,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            if ~strcmp(erro_k,'')
                if strcmp(erros{1},'')
                    erros{1} = erro_k;
                end
                erros{2} = erros{2} + 1;
            end
            n_iter = n_iter+1;        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot_data(:,n_iter+1) = x_k;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%         
        end    
        if n_iter == n_max_iter
            erros{3} = 'numero maximo de iteracoes metodo OSR';
        end
        x_min = x_k;
        tempo = toc;
        n_passos = n_iter;
end

%--------------------------------------------------------------%
%-------- O C R -----------------------------------------------%
% penalidade:
% gui.OCR(gui.x_o,gui.function,gui.grad,gui.hess,gui.restricao_h,gui.restricao_c,gui.grad_restricao_h,gui.grad_restricao_c,gui.hess_restricao_h,gui.hess_restricao_c,gui.LSearch,gui.OSR,gui.TOL_OCR,gui.TOL_OSR,gui.TOL_LSearch,gui.n_Max_iter,gui.armijo_m,gui.rp_o,gui.beta_p);
% barreira:
% gui.OCR(gui.x_o,gui.function,gui.grad,gui.hess,gui.restricao_h,gui.restricao_c,gui.grad_restricao_h,gui.grad_restricao_c,gui.hess_restricao_h,gui.hess_restricao_c,gui.LSearch,gui.OSR,gui.TOL_OCR,gui.TOL_OSR,gui.TOL_LSearch,gui.n_Max_iter,gui.armijo_m,gui.rp_o,gui.beta_p,gui.rb_o,gui.beta_b);

%%%%% PENALIDADE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [ x_min,plot_data,n_passos,tempo,erros ] = penalidade( x_o,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,busca_lin,f_osr,tolerancia,tolerancia_osr,tolerancia_lsearch,n_max_iter,m,rp_o,beta_p)
    tic
    erros = {'',0,'',0,''};
    if nargin < 19
        beta_p = 10;
    end
    if nargin < 18
        rp_o = 1;
    end
    % verificacao se foi colocado MAXITE, caso contrario usar padrao
    if nargin < 17
        m = 0.3;
    end
    if nargin < 16
        n_max_iter = 500;
    end
    if nargin < 15 % verificacao se foi colocada tolerancia, caso contrario usar padrao
        tolerancia_lsearch = 10^(-5);
    end
    if nargin < 13 % verificacao se foi colocada tolerancia, caso contrario usar padrao
        tolerancia = 10^(-5);
    end   
    n_iter = 0;
    x_k = x_o;
    rp_k = rp_o;
    % alvo: minimizar FUNCAO f_* = f + pnld_f
    %%%%%%%%%%%%%%%%%%%%%%
    plot_data(:,1) = x_o;
    %%%%%%%%%%%%%%%%%%%%%%        
    while n_iter < n_max_iter
        [x_k,~,~,~,erro_k] = f_osr(x_k,@pseudo_f,@pseudo_g,@pseudo_h,busca_lin,tolerancia_osr,tolerancia_lsearch,n_max_iter,m,true,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k);        
        % saidas -> x_min,plot_data,n_passos,tempo,erros
        % erro_k = {'erro b_lin','numero de erros b_lin','erro_osr')
        if ~strcmp(erro_k{3},'')
            if strcmp(erros{3},'')
                erros{3} = erro_k;
            end
            erros{4} = erros{4} + 1;
        end
        if ~strcmp(erro_k{1},'')
            if strcmp(erros{1},'')
                erros{1} = erro_k;
            end
            erros{2} = erros{2} + erro_k{2};
        end
        n_iter = n_iter+1;
        p_rpk_xkM1 = pseudo_f(x_k,f,restr_f_h,restr_f_c,rp_k) - f(x_k);
        if abs(p_rpk_xkM1) < tolerancia
            break
        end
        rp_k = rp_k*beta_p;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,n_iter+1) = x_k;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end    
    if n_iter == n_max_iter
            erros{5} = 'numero maximo de iteracoes metodo OCR';
    end
    x_min = x_k;
    tempo = toc;
    n_passos = n_iter;    
end


%%%%% BARREIRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_min,plot_data,n_passos,tempo,erros ] = barreira( x_o,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,busca_lin,f_osr,tolerancia,tolerancia_osr,tolerancia_lsearch,n_max_iter,m,rp_o,beta_p,rb_o,beta_b)
    tic
    erros = {'',0,'',0,''};
    if nargin < 21
        beta_b = 0.1;
    end
    if nargin < 20
        rb_o = 10;
    end
    if nargin < 19
        beta_p = 10;
    end
    if nargin < 18
        rp_o = 1;
    end
    % verificacao se foi colocado MAXITE, caso contrario usar padrao
    if nargin < 17
        m = 0.3;
    end
    if nargin < 16
        n_max_iter = 500;
    end
    if nargin < 15 % verificacao se foi colocada tolerancia, caso contrario usar padrao
        tolerancia_lsearch = 10^(-5);
    end
    if nargin < 13 % verificacao se foi colocada tolerancia, caso contrario usar padrao
        tolerancia = 10^(-5);
    end   
    n_iter = 0;
    x_k = x_o;
    rp_k = rp_o;   
    rb_k = rb_o;
    % alvo: minimizar FUNCAO f_* = f + pnld_f
    %%%%%%%%%%%%%%%%%%%%%%
    plot_data(:,1) = x_o;
    %%%%%%%%%%%%%%%%%%%%%%        
    while n_iter < n_max_iter
        [x_k,~,~,~,erro_k] = f_osr(x_k,@pseudo_f,@pseudo_g,@pseudo_h,busca_lin,tolerancia_osr,tolerancia_lsearch,n_max_iter,m,true,f,g_f,h_f,restr_f_h,restr_f_c,restr_g_h,restr_g_c,restr_h_h,restr_h_c,rp_k,rb_k);
        % erro_k = {'erro b_lin','numero de erros b_lin','erro_osr')
        if ~strcmp(erro_k{3},'')
            if strcmp(erros{3},'')
                erros{3} = erro_k;
            end
            erros{4} = erros{4} + 1;
        end
        if ~strcmp(erro_k{1},'')
            if strcmp(erros{1},'')
                erros{1} = erro_k;
            end
            erros{2} = erros{2} + erro_k{2};
        end
        n_iter = n_iter+1;
        p_rpk_xkM1 = pseudo_f(x_k,f,restr_f_h,restr_f_c,rp_k,rb_k) - f(x_k);
        if abs(p_rpk_xkM1) < tolerancia
            break
        end
        rp_k = rp_k*beta_p;
        rb_k = rb_k*beta_b;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_data(:,n_iter+1) = x_k;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end    
    if n_iter == n_max_iter
            erros{5} = 'numero maximo de iteracoes metodo OSR';
    end
    x_min = x_k;
    tempo = toc;
    n_passos = n_iter;         
end


%%%%% PSEUDO FUNCAO E SEU GRAD/HESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pseudo_f_value] = pseudo_f(x_k,f,restr_f_h,restr_f_c,rp_k,rb_k)
    if nargin < 6
        rb_k = 0;
    end
    if rb_k == 0 %caso penalidade
        pseudo_f_value = f(x_k);
        if ~isempty(restr_f_h)
            for i = 1:1:length(restr_f_h)
                pseudo_f_value = pseudo_f_value + (1/2)*rp_k*(restr_f_h{i}(x_k))^2;
            end
        end
        if ~isempty(restr_f_c)
            for i = 1:1:length(restr_f_c)
                pseudo_f_value = pseudo_f_value + (1/2)*rp_k*max(0,(restr_f_c{i}(x_k))^2);
            end
        end
    else %caso barreira
        pseudo_f_value = f(x_k);
        if ~isempty(restr_f_h)
            for i = 1:1:length(restr_f_h)
                pseudo_f_value = pseudo_f_value + (1/2)*rp_k*(restr_f_h{i}(x_k))^2;
            end
        end
        if ~isempty(restr_f_c)
            for i = 1:1:length(restr_f_c)
                pseudo_f_value = pseudo_f_value - 1*rb_k*(1/(restr_f_c{i}(x_k)));
            end
        end
    end
end 


function [pseudo_g_value] = pseudo_g(x_k,f,g_f,restr_f_c,restr_g_h,restr_g_c,rp_k,rb_k)
    if nargin < 7
        rb_k = 0;
    end
    if rb_k == 0 %caso penalidade
        if strcmp(func2str(g_f),'mdfGrad')
            pseudo_g_value = g_f(x_k,f);
        else
            pseudo_g_value = g_f(x_k);
        end        
        if ~isempty(restr_g_h)
            for i = 1:1:length(restr_g_h)
                pseudo_g_value = pseudo_g_value + (1/2)*rp_k*(restr_g_h{i}(x_k));
            end
        end        
        if ~isempty(restr_g_c)
            for i = 1:1:length(restr_g_c)
                if ~isempty(restr_f_c) && max(restr_f_c{i}(x_k),0) ~=0
                    pseudo_g_value = pseudo_g_value + (1/2)*rp_k*(restr_g_c{i}(x_k));
                end
            end
        end
    else %caso barreira
        if strcmp(func2str(g_f),'mdfGrad')
            pseudo_g_value = g_f(x_k,f);
        else
            pseudo_g_value = g_f(x_k);
        end        
        if ~isempty(restr_g_h)
            for i = 1:1:length(restr_g_h)
                pseudo_g_value = pseudo_g_value + (1/2)*rp_k*(restr_g_h{i}(x_k));
            end
        end
        if ~isempty(restr_g_c)
            for i = 1:1:length(restr_g_c)
                pseudo_g_value = pseudo_g_value - 1*rb_k*(restr_g_c{i}(x_k));
            end
        end
    end
end


function [pseudo_h_value] = pseudo_h(x_k,f,g_f,h_f,restr_f_c,restr_h_h,restr_h_c,rp_k,rb_k)
    if nargin < 9
        rb_k = 0;
    end
    if rb_k == 0 %caso penalidade
        if strcmp(func2str(h_f),'mdfHess')
            pseudo_h_value = h_f(x_k,g_f,f);
        else
            pseudo_h_value = h_f(x_k);
        end        
        if ~isempty(restr_h_h)
            for i = 1:1:length(restr_h_h)
                pseudo_h_value = pseudo_h_value + (1/2)*rp_k*(restr_h_h{i}(x_k));
            end
        end        
        if ~isempty(restr_h_c)
            for i = 1:1:length(restr_h_c)
                if ~isempty(restr_f_c) && max(restr_f_c{i}(x_k),0) ~=0
                    pseudo_h_value = pseudo_h_value + (1/2)*rp_k*(restr_h_c{i}(x_k));
                end
            end
        end
    else %caso barreira
        if strcmp(func2str(h_f),'mdfHess')
            pseudo_h_value = h_f(x_k,g_f,f);
        else
            pseudo_h_value = h_f(x_k);
        end        
        if ~isempty(restr_h_h)
            for i = 1:1:length(restr_h_h)
                pseudo_h_value = pseudo_h_value + (1/2)*rp_k*(restr_h_h{i}(x_k));
            end
        end
        if ~isempty(restr_h_c)
            for i = 1:1:length(restr_h_c)
                pseudo_h_value = pseudo_h_value - 1*rb_k*(restr_h_c{i}(x_k));
            end
        end
    end
end 

%--------------------------------------------------------------%
%-------- BUSCA LINEAR ----------------------------------------%
function [prox_x,erros] = chamadaDaBuscaLin(fi,x_k,d_k,busca_lin,tolerancia_ou_da,n_max_iter,m,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)
    b_lin_str = func2str(busca_lin);
    erros = '';
    if nargin<8
        ocr_flag = false;
    end
    if nargin < 7 
        m = 0.3;
    end
    if nargin < 6
        n_max_iter = 500;
    end
    if nargin < 5
        switch(b_lin_str)
            case 'min_p_cte_Fun'
                tolerancia_ou_da = 0.01; % da
            case 'min_p_inc_Fun'
                tolerancia_ou_da = 0.01; % da
            case 'min_armijo_Fun'
                tolerancia_ou_da = 0.01; % da
            case 'min_biss_Fun'
                tolerancia_ou_da = power(10,-5); % tolerancia
            case 'min_aur_Fun'       
                tolerancia_ou_da = power(10,-5); % tolerancia
        end
    end       
    switch(b_lin_str)
        case 'min_p_cte_Fun'
            [alfa,erros] = busca_lin(fi,x_k,d_k,tolerancia_ou_da,n_max_iter,false,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            prox_x = x_k + alfa*d_k;
        case 'min_p_inc_Fun'
            [alfa,erros] = busca_lin(fi,x_k,d_k,tolerancia_ou_da,n_max_iter,false,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            prox_x = x_k + alfa*d_k;
        case 'min_armijo_Fun'
            [alfa,erros] = busca_lin(fi,x_k,d_k,tolerancia_ou_da,m,n_max_iter,false,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            prox_x = x_k + alfa*d_k;
        case 'min_biss_Fun'
            alfas_intervalo = min_p_cte_Fun(fi,x_k,d_k,0.01,n_max_iter,true,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);        
            intervalo(:,1) = x_k + alfas_intervalo(1)*d_k;
            intervalo(:,2) = x_k + alfas_intervalo(2)*d_k;
            [prox_x,erros] = busca_lin(intervalo,fi,tolerancia_ou_da,n_max_iter,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            prox_x = prox_x';
        case 'min_aur_Fun'
            alfas_intervalo = min_p_cte_Fun(fi,x_k,d_k,0.01,n_max_iter,true,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);        
            intervalo(:,1) = x_k + alfas_intervalo(1)*d_k;
            intervalo(:,2) = x_k + alfas_intervalo(2)*d_k;
            [prox_x,erros] = busca_lin(intervalo,fi,tolerancia_ou_da,n_max_iter,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k);
            prox_x = prox_x';
    end
end


%%%%% PASSO CONSTANTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ a_k,erros ] = min_p_cte_Fun(fi,x_k,d_k,delta_alfa,n_max_iter,flag,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)  
        erros = '';
        % verificacao se foi usada flag de retorno de intervalo, caso contrario usar padrao
        if nargin < 6 % flag que ajuda o programa a retornar 2 ou 1 valores
                    % importante caso apos este venha a ser usado o metodo da
                    % bisseccao ou secao aurea
            flag = false; 
        end
        if nargin < 5 % verificacao se foi colocado MAXITE, caso contrario usar padrao
            n_max_iter = 500;
        end
        if nargin < 4 % verificacao se foi colocado delta alfa, caso contrario usar padrao
            delta_alfa = 0.01;
        end    
        n_iter = 0;    
        a_i = 0; % setando primeiro termo como x0 recebido
        x_i = (x_k+a_i*d_k);                 
        a_k = 0;
        % 1 passo e definir em que sentido andar ou seja, + ou -
        a_iP = a_i + delta_alfa;
        x_iP = (x_k+a_iP*d_k);
        if ocr_flag
            f_iP = pseudo_f(x_iP,f,restr_f_h,restr_f_c,rp_k,rb_k);
            f_i = pseudo_f(x_i,f,restr_f_h,restr_f_c,rp_k,rb_k);
        else
            f_iP = fi(x_iP);    
            f_i = fi(x_i);
        end
        if f_iP > f_i  % se para a direcao positiva o valor subir
            delta_alfa = -delta_alfa; % tentar direcao negativa
            a_iN = a_i + delta_alfa;
            x_iN = (x_k+a_iN*d_k);
            if ocr_flag
                f_iN = pseudo_f(x_iN,f,restr_f_h,restr_f_c,rp_k,rb_k);            
            else
                f_iN = fi(x_iN);
            end
            if f_iN > f_i % se para direcao negativa o valor continuar a subir
                n_max_iter = -1; % retorna o a_k setado como 0 anteriormente pois o programa nao passa pelo loop
            end
        end
        while n_iter <= n_max_iter
            a_i1 = a_i + delta_alfa;
            x_i1 = (x_k+a_i1*d_k);
            if ocr_flag
                f_i1 = pseudo_f(x_i1,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_i1 = fi(x_i1);
            end
    %         if n_iter<50
    %             f_i1
    %             f_i
    %             a_k
    %             a_i1
    %             a_i
    %         end       
            if f_i1<f_i           
                if flag % caso nao tenha sido posta a flag de retorno de intervalo
                    % o programa nao roda esta parte
                    a_k(1) = a_i;
                    a_k(2) = a_i1;
                else
                    a_k = a_i1;
                end
            else
                break
            end
            a_i = a_i1;
            f_i = f_i1;
            n_iter=n_iter+1;
        end
        if n_iter >= n_max_iter && n_max_iter ~= -1
            erros = 'numero maximo de iteracoes metodo de busca linear';
        end
        if a_k == 0
            if flag
                a_k = [0+abs(delta_alfa),0-abs(delta_alfa)];
            end
        end
        if n_iter >= n_max_iter && n_max_iter ~= -1 && flag
            a_k = [a_k(1),a_k(2)+5000*delta_alfa];
        end
end


%%%%% PASSO INCREMENTAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ a_k,erros ] = min_p_inc_Fun(fi,x_k,d_k,delta_alfa,n_max_iter,flag,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)     
        erros = '';
        % verificacao se foi usada flag de retorno de intervalo, caso contrario usar padrao
        if nargin < 6 % flag que ajuda o programa a retornar 2 ou 1 valores
                    % importante caso apos este venha a ser usado o metodo da
                    % bisseccao ou secao aurea
            flag = false; 
        end
        if nargin < 5 % verificacao se foi colocado MAXITE, caso contrario usar padrao
            n_max_iter = 500;
        end
        if nargin < 4 % verificacao se foi colocado delta alfa, caso contrario usar padrao
            delta_alfa = 0.01;
        end    
        n_iter = 0;    
        a_i = 0; % setando primeiro termo como x0 recebido
        x_i = (x_k+a_i*d_k);         
        a_k = 0;
        % 1 passo e definir em que sentido andar ou seja, + ou -
        a_iP = a_i + delta_alfa;
        x_iP = (x_k+a_iP*d_k);
        if ocr_flag
            f_iP = pseudo_f(x_iP,f,restr_f_h,restr_f_c,rp_k,rb_k);
            f_i = pseudo_f(x_i,f,restr_f_h,restr_f_c,rp_k,rb_k);
        else
            f_iP = fi(x_iP);  
            f_i = fi(x_i);  
        end
        if f_iP > f_i  % se para a direcao positiva o valor subir
            delta_alfa = -delta_alfa; % tentar direcao negativa
            a_iN = a_i + delta_alfa;
            x_iN = (x_k+a_iN*d_k);
            if ocr_flag
                f_iN = pseudo_f(x_iN,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_iN = fi(x_iN);
            end
            if f_iN > f_i % se para direcao negativa o valor continuar a subir
                n_max_iter = 0; % retorna o a_k setado como 0 anteriormente pois o programa nao passa pelo loop
            end
        end
        while n_iter <= n_max_iter
            a_i1 = a_i + delta_alfa;
            x_i1 = (x_k+a_i1*d_k);
            if ocr_flag
                f_i1 = pseudo_f(x_i1,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_i1 = fi(x_i1);
            end
            delta_f = f_i - f_i1;
            if delta_f<0
                a_k = a_i;
                if flag % caso nao tenha sido posta a flag de retorno de intervalo
                    % o programa nao roda esta parte
                    a_k(2) = a_i1;
                end
                break
            end
            a_i = a_i1;
            f_i = f_i1;
            n_iter=n_iter+1;
            if a_i == 2*delta_alfa
                delta_alfa = 2*delta_alfa;
            end
        end
        if n_iter >= n_max_iter && n_max_iter ~= 0
            erros = 'numero maximo de iteracoes metodo de busca linear';
        end
end


%%%%% ARMIJO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ a_k,erros ] = min_armijo_Fun(fi,x_k,d_k,delta_alfa,m,n_max_iter,flag,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)     
        erros = '';
        % verificacao se foi usada flag de retorno de intervalo, caso contrario usar padrao
        if nargin < 7 % flag que ajuda o programa a retornar 2 ou 1 valores
                    % importante caso apos este venha a ser usado o metodo da
                    % bisseccao ou secao aurea
            flag = false; 
        end
        if nargin < 6 % verificacao se foi colocado MAXITE, caso contrario usar padrao
            n_max_iter = 500;
        end    
        if nargin < 5 % verificacao se foi colocado m, caso contrario usar padrao
            m = 0.3;
        end    
        if nargin < 4 % verificacao se foi colocado delta alfa, caso contrario usar padrao
            delta_alfa = 0.01;
        end    
        n_iter = 0;    
        a_i = 0; % setando primeiro termo como x0 recebido
        x_i = (x_k+a_i*d_k);              
        a_k = 0;
        % 1 passo e definir em que sentido andar ou seja, + ou -
        a_iP = a_i + delta_alfa;
        x_iP = (x_k+a_iP*d_k);
        if ocr_flag
            f_iP = pseudo_f(x_iP,f,restr_f_h,restr_f_c,rp_k,rb_k);
            f_i = pseudo_f(x_i,f,restr_f_h,restr_f_c,rp_k,rb_k);
        else
            f_iP = fi(x_iP);  
            f_i = fi(x_i);   
        end
        f_0 = f_i;
        if f_iP > f_i  % se para a direcao positiva o valor subir
            delta_alfa = -delta_alfa; % tentar direcao negativa
            a_iN = a_i + delta_alfa;
            x_iN = (x_k+a_iN*d_k);
            if ocr_flag
                f_iN = pseudo_f(x_iN,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_iN = fi(x_iN);
            end
            if f_iN > f_i % se para direcao negativa o valor continuar a subir
                n_max_iter = 0; % retorna o a_k setado como 0 anteriormente pois o programa nao passa pelo loop
            end
        end
        while n_iter <= n_max_iter
            if a_i ~= 0
                if f_i > (f_0 - m*a_i)
                    a_k = a_i;
                    if flag % caso nao tenha sido posta a flag de retorno de intervalo
                    % o programa nao roda esta parte
                        a_k(2) = a_i1;
                    end
                    break
                end
            end
            a_i1 = a_i + delta_alfa;
            x_i1 = (x_k+a_i1*d_k);
            if ocr_flag
                f_i1 = pseudo_f(x_i1,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_i1 = fi(x_i1);
            end
            a_i = a_i1;
            f_i = f_i1;
            n_iter=n_iter+1;
        end
        if n_iter >= n_max_iter && n_max_iter ~= 0
            erros = 'numero maximo de iteracoes metodo de busca linear';
        end
end


%%%%% BISSECCAO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_k,erros ] = min_biss_Fun(intervalo,fi,tolerancia,n_max_iter,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)   
        erros = '';
        % verificacao se foi colocado MAXITE, caso contrario usar padrao
        if nargin < 4 
            n_max_iter = 500;
        end
        if nargin < 3 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end    
        x_k = intervalo(:,1);
        n_iter = 0;
        x_0 = intervalo(:,1);
        x_fim = intervalo(:,2);
        if ocr_flag
            f_0 = pseudo_f(x_0,f,restr_f_h,restr_f_c,rp_k,rb_k);
            f_b = pseudo_f(x_fim,f,restr_f_h,restr_f_c,rp_k,rb_k);
        else
            f_0 = fi(x_0);
            f_b = fi(x_fim);    
        end
        while n_iter <= n_max_iter
            x_m = (x_0 + x_fim)/2;
            x_p1 = (x_m + x_0)/2;
            x_p2 = (x_m + x_fim)/2;
            if ocr_flag
                f_p1 = pseudo_f(x_p1,f,restr_f_h,restr_f_c,rp_k,rb_k);
                f_p2 = pseudo_f(x_p2,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_p1 = fi(x_p1);
                f_p2 = fi(x_p2);
            end
            if f_p1<f_p2
                x_fim = x_m;
                x_m = x_p1;
            else
                x_0 = x_m;
                x_m = x_p2;
            end
            % criterio de convergencia:
            if abs(x_fim-x_0) < tolerancia
                x_k = x_m;
                break
            end         
            n_iter=n_iter+1;
        end
        if n_iter >= n_max_iter 
            x_k = x_m;
            erros = 'numero maximo de iteracoes metodo de busca linear';
        end
end


%%%%% SECAO AUREA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ x_k,erros ] = min_aur_Fun(intervalo_ab,fi,tolerancia,n_max_iter,ocr_flag,f,restr_f_h,restr_f_c,rp_k,rb_k)   
        erros = '';
        % verificacao se foi colocado MAXITE, caso contrario usar padrao
        if nargin < 4 
            n_max_iter = 500;
        end
        if nargin < 3 % verificacao se foi colocada tolerancia, caso contrario usar padrao
            tolerancia = 10^(-5);
        end    
        x_k = intervalo_ab(:,1);
        ra = (sqrt(5)+1)/2;
        n_iter = 0;
        x_a = intervalo_ab(:,1);
        x_b = intervalo_ab(:,2);
        if ocr_flag
            f_a = pseudo_f(x_a,f,restr_f_h,restr_f_c,rp_k,rb_k);
            f_b = pseudo_f(x_b,f,restr_f_h,restr_f_c,rp_k,rb_k);
        else
            f_a = fi(x_a);
            f_b = fi(x_b);    
        end
        while n_iter <= n_max_iter
            x_pd = (x_b - x_a)/ra + x_a;
            x_pe = (x_b - x_a)*(1-1/ra) + x_a ;
            if ocr_flag
                f_pd = pseudo_f(x_pd,f,restr_f_h,restr_f_c,rp_k,rb_k);
                f_pe = pseudo_f(x_pe,f,restr_f_h,restr_f_c,rp_k,rb_k);
            else
                f_pd = fi(x_pd);
                f_pe = fi(x_pe);
            end
            if f_pd<f_pe
                x_a = x_pe;
            else
                x_b = x_pd;
            end
            % criterio de convergencia:
            if abs(x_b-x_a) < tolerancia
                x_k = (x_a + x_b)/2;
                break
            end         
            n_iter=n_iter+1;
        end
        if n_iter >= n_max_iter 
            x_k = (x_a + x_b)/2;
            erros = 'numero maximo de iteracoes metodo de busca linear';            
        end
end


%--------------------------------------------------------------%
%-------- GRAD por MDF ----------------------------------------%
function [grad_vec] = mdfGrad(x_i,funct_f) 
    d_x = 10^-10;
    grad_vec = zeros(1,length(x_i));
    for i = 1:1:length(x_i)
        x_aux_M = x_i;
        x_aux_m = x_i;
        x_aux_M(i) = x_aux_M(i)+d_x;
        x_aux_m(i) = x_aux_m(i)-d_x;
        grad_vec(i) = (funct_f(x_aux_M)-funct_f(x_aux_m))/(2*d_x);
    end
end


%-------- HESS por MDF ----------------------------------------%
function [ H ] = mdfHess(x_i,grad_f,funct_f)        
    d_x = 10^-5;
    H = zeros(length(x_i),length(x_i));        
    for i = 1:1:length(x_i)
        for j = 1:1:length(x_i)
            x_aux_M = x_i;
            x_aux_m = x_i;
            x_aux_M(j) = x_aux_M(j)+d_x;
            x_aux_m(j) = x_aux_m(j)-d_x;
            if strcmp(func2str(grad_f),'mdfGrad')
                grad_M = grad_f(x_aux_M,funct_f);
                grad_m = grad_f(x_aux_m,funct_f);            
            else
                grad_M = grad_f(x_aux_M);
                grad_m = grad_f(x_aux_m);
            end
            H(i,j) = (grad_M(i) - grad_m(i))/(2*d_x);
        end
    end
end