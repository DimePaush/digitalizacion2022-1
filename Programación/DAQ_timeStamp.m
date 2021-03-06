%% Setup puerto serie
%%Busca los puertos serie
serialportlist

%Asignar un objeto serial y su tasa de baudios
s=serialport("/dev/ttyACM0",115200);
configureTerminator(s,"CR/LF")
%% Set up de la captura
%Nombre de la variable
name="analogRead";
figure('Name',name,'NumberTitle','off');

%Creamos una linea animada
h=animatedline;

%Coloca lineas horizontales al plot
ax=gca;
ax.YGrid='on';

%Tiempo durante el cual se va a medir
measureTime=seconds(10);
t=seconds(0);

%% Lectura y ploteo
%Libera el buffer para puerto serial
flush(s);
%Obtiene la fecha del sistema y la guarda como el momento inicial
startTime=datetime('now');

%while 1 %grabado infinito
while t<=measureTime %Grabado con tiempo fijo
    
    %Lectura del valor actual del sensor
    data=readline(s);
    data=str2double(data);
    
    %Tiempo transcurrido
    t=datetime('now')-startTime;
    addpoints(h,datenum(t),data);
    
    %Ajusta los limites de x
    ax.XLim=datenum([t-seconds(5) t]);
    
    %Coloca un formato de fechas al eje x
    datetick('x','keeplimits');
    
    %Actualiza toda la info a la linea animada
    drawnow
    
    %Momento final de la muestra
    endTime=datetime('now');
end

%% Guardado de datos
%Obtención de los datos desde la linea animada
[~,dataPoints]=getpoints(h);

%Vector de tiempo total
time=startTime:(endTime-startTime)/(numel(dataPoints)-1):endTime;

%% Ploteo de la señal capturada
figure
plot(time,dataPoints)
ylabel(name+"[Adim]")
title(name)
grid on

%% Guardado en ASCII
data=table(time',dataPoints','VariableNames',["DateTime" name]);
writetable(data,"./Output/"+datestr(startTime)+"_"+name);
