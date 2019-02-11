nb_de_canaux = input('Entrer le nombre de canaux')
nb_de_pulse = input('Entrer la valeur nb de pulse')
nb_Intensite = input('Entrer le nombre d''Intensite')
nb_de_configuration=input('Entrer le nombre de configuration')
f = input('Indiquer les valeurs des differentes intensités');
Intervalle = input('Indiquer un intervalle pour la configuration'); 
Legende = input('entrer legende (attention même nombre de caractères)')
whos
z=1;
a=nb_de_pulse*nb_Intensite;
n=1;
e=1;
zzzz=['b-x ';'g-x ';'r-x ';'c-x ';'m-x ';'y-x '];
nomconfig=['Tripolaire Transverse A1';'Tripolaire Transverse A2';'Tripolaire Transverse A3';'Tripolaire Transverse A4';'Tripolaire Transverse B1';'Tripolaire Transverse B2';'Tripolaire Transverse B3';'Tripolaire Transverse B4';'Tripolaire Transverse C1';'Tripolaire Transverse C2';'Tripolaire Transverse C3';'Tripolaire Transverse C4'];

if nb_de_pulse*nb_Intensite*nb_de_configuration ~= length (datastart)
    disp 'erreur dans le une des 3 premières entrées'
else disp 'les 3 premièresentrées sont ok'
end

for n=1:nb_de_configuration
    for y=1:a
    
        pulse = mod((y-1),nb_de_pulse)+1;
        courant=floor((y-1)/nb_de_pulse)+1;
        config=floor((y-1)/a)+n;
        z=y+a*(n-1);
        
           Signal1(pulse,courant,config,:)=data(datastart(1,z):dataend(1,z));
           Signal2(pulse,courant,config,:)=data(datastart(2,z):dataend(2,z));
           Signal3(pulse,courant,config,:)=data(datastart(3,z):dataend(3,z));
           Signal4(pulse,courant,config,:)=data(datastart(4,z):dataend(4,z));
           Signal5(pulse,courant,config,:)=data(datastart(5,z):dataend(5,z));
           Signal6(pulse,courant,config,:)=data(datastart(6,z):dataend(6,z));

    end
end

final= zeros(nb_de_canaux,nb_de_configuration,nb_Intensite);
for nombre_EMG=1:nb_de_canaux

variable= zeros(nb_de_configuration,nb_Intensite);
for configconfig=1:nb_de_configuration
    moyenne = [0];
for courantcourant=1:nb_Intensite
    vect = [0]; 
for pulsepulse=1:nb_de_pulse
    C=eval(['Signal',num2str(nombre_EMG)]);
    A=squeeze(C(pulsepulse,courantcourant,configconfig,:));
    vect(pulsepulse) = sqrt((sum((C(pulsepulse,courantcourant,configconfig,Intervalle)).^2))/length(Intervalle)); 
end
 moyenne (courantcourant) = mean(vect);
 ecart_type = std(vect);
end
 variable(configconfig,:)=moyenne;
end

maximale=max(max(variable));
variable2=variable(:,:)/maximale;

final(nombre_EMG,:,:)=variable2;
end

final2=zeros(nb_de_canaux,nb_de_configuration);
for k=1:nb_de_canaux;
    xxx=[0];
    for l=1:1:nb_de_configuration;
        xxx(l)=max(final(k,l,:)-min(final(k,l,:)));
    end
    final2(k,:)=xxx;
end

final3=final;
for i=1:nb_de_canaux
        if max(final2(i,:))<0.7
            disp(['le muscle ' num2str(i), ' n''a pas été activé à sa valeur maximale']);
            final3(i,:,:)=0;
        end
end
final4=final3;
final4=final4.*(final4>.1);
somme=sum(final4.*(final4>.1));
somme=squeeze(somme);
    

for e=1:nb_de_configuration
    D=final3(:,e,:);
    D=squeeze(D);
    D=D';
    G=final4(:,e,:);
    G=squeeze(G);
    G=G';
    figure (e);
    set(figure,'Units','Normalized','Outerposition',[0 0 1 1]);

   
    
    
  kk=zeros(length(1:nb_Intensite),6);
     for yy=1:nb_Intensite 
         kk(yy,:)=G(yy,:)/somme(e,yy);
     end
     
     
     for xx=1:6

    plot(f,D(:,xx),[num2str(zzzz(xx,:))],'linewidth',1.5);
    hold on

    end
    
    set(gca,'DefaultTextFontSize',7)
    title(['Configuration ', num2str(nomconfig(e,:))]);
    legend(Legende, 'Location', 'BestOutside','Orientation','Horizontal')
    ylabel('Activation normalisée')
    xlabel('Intensité envoyée µA')

    saveName = (['Configuration ', num2str(nomconfig(e,:))]);
    saveas(gcf, saveName, 'jpg');   
 print([saveName],'-depsc')    
    saveas(gcf, saveName, 'fig');
    close all
    
    
    
  

end


