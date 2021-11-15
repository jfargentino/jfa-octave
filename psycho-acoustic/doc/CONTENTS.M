% Ensemble de fonctions utiles a l'analyse de sons STATIONNAIRES.
%
%
% * Fonctions psychoacoustiques :
%
%     BARK2HZ...............Conversion Bark -> Hertz.
%     CRITICAL_BAND.........Calcul des frequences limites d'une fenetre frequentielle.
%     HZ2BARK...............Conversion Hertz -> Bark.
%     THRESHOLD.............Seuil d'audition en fonction de la frequence.
%
%
% * Fonctions classiques de traitement de signaux :
%
%     DIRAC_SEQUENCE........Generation d'un peigne de dirac de largeurs fixes.
%     GET_LPSD..............Calcul et affichage de la DSP d'un son en dB.
%     GET_PSD...............Calcul et affichage de la DSP d'un son.
%     NORMALIZE.............Normalisation d'un signal temporel en energie.
%
%
% * Fonctions d'analyse de signaux numeriques :
%
%     ANALYSE_HARM..........Automatisation de MEAN_HARMONICS.
%     GET_ALL_TONES.........Detection des partiels d'un son.
%     GET_FUNDS.............Recherche des frequences fondamentales parmis un tableau de frequences.
%     GET_HARMONICS.........Detection de suites harmoniques d'un son.
%     GET_HARM_DIR..........Detection et sauvegarde de suites harmoniques des sons d'un repertoire.
%     MEAN_HARMONICS........Detection de suites harmoniques extrait de plusieurs fichiers wav.
%
%
% * Fonctions permettant la simplification de sons complexes :
%
%     ANALYSE_PERT..........Automatisation de MEAN_PERTINENTS.
%     ANALYSE_PERT_HARM.....Automatisation de MEAN_PERTINENT_HARMS.
%     CLONE_WAVE............Copie d'un fichier wave par le procede de MEAN_PERTINENTS.
%     DECIMATION............Procedure de decimation des composantes tonales d'un son.
%     GET_NOISE_BAND........Evaluation de niveaux de bandes de bruit equivalent a une DSP.
%     GET_PERTINENTS........Extraction des composantes pertinentes d'un son.
%     GET_PERT_DIR..........Processus d'extraction applique a tous les sons d'un repertoire.
%     GET_PERT_HARM.........Extraction des sequences harmoniques pertinentes.
%     MEAN_PERTINENTS.......Extraction et moyenne des composantes pertinentes de sons.
%     MEAN_PERT_HARM........Extraction et moyenne des sequences harmoniques pertinentes.
%     SYNTHETIZE............Synthese d'un son a partir de composantes pertinentes.
%     
%
%  * Fonctions diverses :
%
%     CELL2FILE.............Sauvegarde du cell dans un fichier texte.
%     CELL_FUSION...........Fusion de deux cellules representant des sequences harmoniques.
%     CELL_SORT.............Trie par ordre croissant des frequences fondamentales d'une cellule.
%     CUT_WAVFILE...........Decoupage d'un fichier wav en plusieurs fichiers.
%     FUSION................Fusion de deux tableaux d'une meme sequence harmonique en un seul.
%     GET_ALL_DIR...........Recuperation des noms des sous repertoires.
%     GET_ALL_FILES.........Recuperation de tous les noms de fichier contenant une chaine de char.
%     INSERTION.............Insertion d'un tableau de 25 niveaux de bruit dans un fichier.
%     NOISES2FILE...........Sauvegarde d'un tableau dans un fichier.
%     NOW2STR...............Affichage de la date et de l'heure.
%     PREPARE_DIR...........Preparation d'un repertoire de fichier wav en vu de leur traitement.
%     SEC2HOUR..............Conversion d'un nombre de secondes en heure, minutes, secondes, millisecondes.
%     TONES2FILE............Sauvegarde d'un tableau de frequences et d'amplitudes dans un fichier.
%
