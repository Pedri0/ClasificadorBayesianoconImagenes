clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.
    
for i = 1:3
    if i == 1
            tipo = "Cachete";
        elseif i== 2
            tipo = "Pico";
        else
            tipo = "Cuello";
    end
    for j = 1:50
        imagen = strcat('goose-mugshot-',num2str(j),'.jpg');
        datosImagen = imread(imagen);
        datosImagenGris = rgb2gray(datosImagen);
        
        img = imshow(datosImagenGris);
        roii = drawassisted(img);
        bw = createMask(roii);

        pixelsWithinMask = datosImagenGris(bw);
        [pixelCounts,grayLevels] = imhist(pixelsWithinMask);

        bw1=uint8(bw);
        imagenSegmentada = bw1.*datosImagenGris;
        %img3 = imshow(imagenSegmentada);
        imwrite(bw,strcat('mascaraImagen',num2str(j),tipo,'.jpg'));
        imwrite(imagenSegmentada,strcat('mascaraImagenGris',num2str(j),tipo,'.jpg'));
        
        
        matrizCoocurrencia = graycomatrix(imagenSegmentada);
        estadisticaSegundoOrden = graycoprops(matrizCoocurrencia);
        contraste = estadisticaSegundoOrden.Contrast;
        correlacion = estadisticaSegundoOrden.Correlation;
        energia = estadisticaSegundoOrden.Energy;
        homogeneidad = estadisticaSegundoOrden.Homogeneity;
        
        media = mean(pixelCounts);
        varianza = var(pixelCounts);
        asimetria = skewness(pixelCounts);
        curtosis = kurtosis(pixelCounts);
        entropia = entropy(pixelCounts);
        %covarianza = cov(pixelCounts,pixelCounts);

        %PrimerOrden = table(media,varianza,asimetria,curtosis,entropia);
        %SegundoOrden = table([covarianza]);
        nivelGrises = grayLevels(:);
        pixeles = pixelCounts(:);
        Histograma = table(nivelGrises,pixeles);
        fila = strcat('imagen',num2str(j));
        Datos = table({fila},media,varianza,asimetria,curtosis,entropia,contraste,correlacion,energia,homogeneidad);
        writetable(Histograma,strcat('Histograma_de_imagen_',num2str(j),tipo,'.csv'));
        writetable(Datos,strcat('DatosZona',tipo,'.csv'),'WriteMode','Append');
    end
end