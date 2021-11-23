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
measureTime=seconds(30);
t=seconds(0);

%Longitud de la lectura
numChars=4; %numero de carateres
numReads=100; %cantidad de numeros por lectura
n=0:numReads-1; %Vector de número de muestra
%% Lectura y ploteo
%Libera el buffer para puerto serial
flush(s);

%Leera una linea completa y nos dejara al inicio
readline(s);
%Obtiene la fecha del sistema y la guarda como el momento inicial
startTime=datetime('now');

%while 1 %grabado infinito
while t<=measureTime %Grabado con tiempo fijo
    
    %Lectura del valor actual del sensor
    %El +2 es para los caracteres CR/LF
    data=read(s,numReads*(numChars+2),'char');
    data=str2num(data);
    n=n+numReads;
    
    %Addpoints
    addpoints(h,n,data);
    
    %Ajusta los límites de x
    ax.XLim=[n(end)-1000 n(end)];
    
    %Actualiza toda la indo a la linea animada
    drawnow
       
    %Momento final de la muestra
    endTime=datetime('now');
    
    %Tiempo transcurrido
    t=endTime-startTime;
    title("Elapsed Time: "+seconds(t)+"s");
end

%% Guardado de datos
%Obtención de los datos desde la linea animada
[~,dataPoints]=getpoints(h);

%Vector de tiempo total
time=startTime:(endTime-startTime)/(numel(dataPoints)-1):endTime;
Ts=seconds(endTime-startTime)/numel(dataPoints); %Periodo de muestreo [s]
fs=1/Ts; %Frecuencia de muestreo Hz

%% Ploteo de la señal capturada
figure
plot(time,dataPoints)
xlabel('Muestra')
ylabel(name)

%% Guardado en ASCII
writematrix(dataPoints',"./Output/"+datestr(startTime)+"_fs"+fs+"Hz_"+name+".xlsx");
