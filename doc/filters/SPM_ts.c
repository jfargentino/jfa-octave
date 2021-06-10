/************************************************************************//** 
* @ingroup Ts
* @file    : SPM_ts.c 
* @remark Project  :  Strada 
* @version : 0.4
* @date    :  6/10/09
* @author  : ONDIS DM
*****************************************************************************
*   @brief Fonction commune employe par les modules SYSMAS
*   Les fonctions suivantes sont globales a la librairie :
*    - courbe de correctionen reception sh
*    - courbe de correction en emission sv
*    - courbe niveau max emission
*
* - int _SPM_ts_calc_global_filter(SPM_TS *ts) 
* - int _SPM_ts_interp_filter(float * filter, unsigned int Nfilter, float * filter_0,  float * filter_0_f, int Nfilter_0, float  fmin, float  fmax)
* - int _SPM_ts_calc_bp_filter(float * filter, unsigned int Nfilter, float fmin, float fmax, float slope)
* - int SPM_ts_calc_to_spectrum(float * spectrum, float *fs, unsigned int Nfreq, float * f_to, unsigned int Nto, float* spectrum_to)
* - int SPM_ts_set_sv_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
* - int SPM_ts_set_sh_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
* - int SPM_ts_set_cag_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
* - int SPM_ts_global_init(void)
* - int _SPM_ts_malloc(SPM_TS *ts)
* - int _SPM_ts_free(SPM_TS *ts)
* - int SPM_ts_init(SPM_TS*  ts, float Fsamp)
* - int SPM_ts_set_Nmem(SPM_TS *ts, unsigned int *value)
* - int SPM_global_close(void)
* - int SPM_ts_close(SPM_TS *ts)
* - static int SPM_ts_compact_cag(SPM_TS * ts) 
* - int SPM_ts_cag_ctrl(SPM_TS * ts, float * spectrum, int Nfreq) 
* - int SPM_ts_get_cag(SPM_TS * ts, float *gain_cor, float *niveau_max) 
* - int SPM_ts_fft(SPM_TS * ts, short * data, int Ndata, float* spectrum, int *Nfreq)
* - int SPM_ts_filter_cyc(SPM_TS * ts, float * data_in, int Ndata, float * data_out,int * delay)
* - static int SPM_ts_compact_dop_mem(SPM_TS * ts)  
* - int SPM_ts_dop_mem(SPM_TS * ts, float * data_in, int Ndata_in, float doppler, float** data_out, int * Ndata_out)
* - int SPM_ts_set_cf_low(SPM_TS * ts, float * value)
* - int SPM_ts_set_cf_high(SPM_TS * ts, float * value)  
* - int SPM_ts_set_Nfft(SPM_TS *ts, unsigned int *value)
* - int SPM_ts_set_mode(SPM_TS *ts, unsigned int *value)
* - int SPM_ts_set_Windowing(SPM_TS *ts, unsigned int *value)
*
*****************************************************************************
* @attention MODIFICATIONS :
*
*
*
*
******************************************************************************/

//#define _FULL_DEBUG_
#include <math.h>
#include "SPM_ts.h"
#include "toolbox.h"

/*! @var  _SPM_hdll_fftw3f 
*   @brief reference sur la librairie dynamique chargee dans SPM_init()
*/
HINSTANCE _SPM_hdll_fftw3f;

/*!  @var  FFTW_PLAN fn_fftwf_plan_dft_r2c_1d
*   @brief Pointeur sur la fonction de creation de plan de la librairie fftw3f
*/
FFTWF_PLAN_R2C fn_fftwf_plan_dft_r2c_1d;

/*! @var  FFTW_PLAN fn_fftwf_plan_dft_c2r_1d
*   @brief Pointeur sur la fonction de creation de plan de la librairie fftw3f
*/
FFTWF_PLAN_C2R fn_fftwf_plan_dft_c2r_1d;

/*! @var  FFTW_MALLOC fn_fftwf_malloc;
*   @brief Pointeur sur la fonction de creation d'allocation memoire de la librairie fftw3f
*/
FFTWF_MALLOC fn_fftwf_malloc;

/*! @var  FFTW_FREE fn_fftwf_free
*   @brief Pointeur sur la fonction de liberation de la librairie fftw3f
*/
FFTWF_FREE fn_fftwf_free;


/*! @var  FFTW_EXECUTE fn_fftwf_execute
*   @brief Pointeur sur la fonction d'execution du plan de la librairie fftw3f
*/
FFTWF_EXECUTE fn_fftwf_execute;

/*! @var  FFTWF_DESTROY_PLAN fn_fftwf_destroy_plan
*   @brief Pointeur sur la fonction de la destruction de plan de la librairie fftw3f
*/
FFTWF_DESTROY_PLAN fn_fftwf_destroy_plan;

/*! @var FFTWF_CLEANUP fn_fftwf_cleanup;
*   @brief Pointeur sur la fonction de nettoyage de la librairie fftw3f
*/
FFTWF_CLEANUP fn_fftwf_cleanup;



/* Fonctions privees */

int _SPM_ts_calc_bp_filter(float * filter, unsigned int Nfilter, float fmin, float fmax, float slope);
int _SPM_ts_interp_filter(float * filter, unsigned int Nfilter, float * filter_0,  float * filter_0_f, int Nfilter_0, float fmin, float fmax);


/******************************************************************************/
/*!
* @fn  int _SPM_ts_calc_global_filter(SPM_TS* ts)
*  @brief Calcule le filtre global applique en fonction des parametres choisis
*   
*  @param[in] ts Pointeur sur la structure de parametres SPM_TS 
*   
*  @return -1 Erreur, 1 avertissement, 0 
*  
*/
/******************************************************************************/
int _SPM_ts_calc_global_filter(SPM_TS *ts)
{
int err;
int i ;
	
	unsigned int mode = ts->filter_mode;
	float * filter = ts->filter;
	unsigned int Nfilter = ts->Nfft;
	
	SPM_LOG_MSG("SPM_calc_ts_global_filter : %d\n",ts->filter_mode);
	if (filter==NULL)
	{
		SPM_set_msg("_SPM_ts_calc_global_filter : pointeur sur la variable filter non alloue\n");
		goto Error;
	}
	for (i=0;i<Nfilter;i++)
	{
			filter[i]=1.0;
	}
	
	if (mode==0)
	{
		SPM_LOG_MSG("%s\n"," _SPM_calc_ts_global_filter : NO_FILTER\n");
		return(0);
	}
	
	if (mode&TS_FILTER_PB)
	{
		_SPM_ts_calc_bp_filter(filter,Nfilter,ts->cf_low,ts->cf_high,ts->slope_rate);
		SPM_LOG_MSG("%s\n"," _SPM_calc_ts_global_filter : FILTER_PB\n");
	}
	
	if (mode&TS_FILTER_SV)
	{
		if (ts->_TS_sv_filter==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_sv_filter non allouee\n");
			goto Error;
		}
		if (ts->_TS_sv_f_axis==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_sv_f_axis non allouee\n");
			goto Error;
		}
		
		float * f_sv = (float*) malloc(Nfilter*sizeof(float));
		
		if ((err = _SPM_ts_interp_filter(f_sv,Nfilter,ts->_TS_sv_filter, ts->_TS_sv_f_axis,ts->_TS_sv_Nfilter,ts->cf_low,ts->cf_high))==-1)
		{
			free(f_sv);
			goto Error;
		}
		for (i=0;i<Nfilter;i++)
		{
			filter[i] = filter[i]*f_sv[i];
		}
		free(f_sv);
		SPM_LOG_MSG("%s\n"," _SPM_calc_ts_global_filter : FILTER_SV\n");
	}
	
	if (mode&TS_FILTER_SH)
	{
		if (ts->_TS_sh_filter==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_sh_filter non allouee\n");
			goto Error;
		}
		if (ts->_TS_sh_f_axis==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_sh_f_axis non allouee\n");
			goto Error;
		}
		
		float * f_sh = (float*) malloc(Nfilter*sizeof(float));
		if ((err = _SPM_ts_interp_filter(f_sh,Nfilter,ts->_TS_sh_filter, ts->_TS_sh_f_axis,ts->_TS_sh_Nfilter,ts->cf_low,ts->cf_high))==-1)
		{
			free(f_sh);
			goto Error;
		}
		for (i=0;i<Nfilter;i++)
		{
			filter[i] = filter[i]*f_sh[i];
		}
		free(f_sh);
		SPM_LOG_MSG("%s\n"," _SPM_calc_ts_global_filter : FILTER_SH\n");
	}
	if (mode&TS_CAG_CTRL)
	{
		if (ts->_TS_cag_ctrl==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_cag_ctrl non allouee\n");
			goto Error;
		}
		if (ts->_TS_cag_f_axis==NULL)
		{
			SPM_set_msg("_SPM_ts_calc_global_filter : variable _TS_cag_f_axis non allouee\n");
			goto Error;
		}
		
		float * cag_ctrl = (float*) malloc(Nfilter*sizeof(float));
		float fmin = (FREQ_MIN/ts->Fsamp);
		float fmax = (FREQ_MAX/ts->Fsamp);
//printf("min=%f fsamp=%f\n", fmin, fmax);
		if ((err = _SPM_ts_interp_filter(cag_ctrl,Nfilter,ts->_TS_cag_ctrl, ts->_TS_cag_f_axis,ts->_TS_cag_Nctrl,fmin,fmax))==-1)
		{
			goto Error;
		}
		ts->cag_ctrl = cag_ctrl; // on ne libere pas!
		
		SPM_LOG_MSG("%s\n"," _SPM_calc_ts_global_filter : FILTER_CAG\n");
	}
	return(0);
Error :
	return(-1);
}

/******************************************************************************/
/*!
* @fn  int _SPM_ts_interp_filter(float * filter, unsigned int Nfilter, float * filter_0,  float * filter_0_f, int Nfilter_0, float  fmin, float  fmax)
*  @brief Calcule le gabarit du filtre correcteur Sv/sh
*
*   @param[in] filter pointeur sur les valeurs d'attenuation du filtre en dB 
*   @param[in] Nfilter nombre de points constituants le filtre
*   @param[in] filter_0
*   @param[in] filter_0_f
*   @param[in] Nfilter_0 
*   @param[in] fmin frequence de coupure min (frequence reduite de 0 a 0.5;
*   @param[in] fmax frequence de coupure min (frequence reduite de 0 a 0.5;
*   
*   @return -1 Erreur, 1 avertissement, 0 
*   @note Le filtre suppose que l'echelle de frequence reduite va de 0 a 0.5 (demi spectre reel)
*   @note 
*/
/******************************************************************************/
int _SPM_ts_interp_filter(float * filter, unsigned int Nfilter, float * filter_0,  float * filter_0_f, int Nfilter_0, float  fmin, float  fmax)
{
	int i,j;
	float temp;
	
	SPM_LOG_MSG("_SPM_ts_interp_filter : Nfilter=%d, Nfilter_0=%d\n",Nfilter,Nfilter_0);
//printf("_SPM_ts_interp_filter : Nfilter=%d, Nfilter_0=%d min=%.4f max=%.2f\n",Nfilter,Nfilter_0,fmin, fmax);
	
	if (filter==NULL)
	{
		SPM_set_msg("_SPM_ts_interp_filter : pointeur sur la variable filter non allouee\n");
		goto Error;
	}
	if (filter_0==NULL)
	{
		SPM_set_msg("_SPM_ts_interp_filter : pointeur sur la variable filter_0 non allouee\n");
		goto Error;
	}
	//Passage de dB a lin
	/*
	for (i=0;i<Nfilter_0;i++)
	{
		f0[i] = pow(10.0,filter_0[i]/20);
		//printf("f0[%d]=%f @ %f\n",i,f0[i],filter_0_f[i]);
	}
	*/
	filter[0]=0.0;
	j=0;
    for (i=1;i<=Nfilter/2;i++)
	{
		temp = ((float)i)/Nfilter;
		if ((FP_Compare(temp,fmin) >=0) && (FP_Compare(temp,fmax) <=0))
		{
		   while (FP_Compare(filter_0_f[j],temp) <0)
		   {
				j=j+1;
				if (j>=Nfilter_0)
				{
					filter [i] = pow(10.0,filter_0[Nfilter_0-1]/20);
					break;
				}
		   }
		   if (j==0)
		   {
			   filter [i] = pow(10.0,filter_0[0]/20);
		   } else {
			   //filter[i] = f0[j-1] + (f0[j]-f0[j-1])*(temp-filter_0_f[j-1])/(filter_0_f[j]-filter_0_f[j-1])
			   // interpolation : la linearite se situe dans l'espace LOG pour les frequences
			   filter[i] = filter_0[j-1] + (filter_0[j]-filter_0[j-1])*(log10(temp)-log10(filter_0_f[j-1]))/(log10(filter_0_f[j])-log10(filter_0_f[j-1]));
		   	   filter[i] = pow(10.0,filter[i]/20); //Passage de dB a lineaire 
		   }
		} else
		{
			filter[i]=1.0;
		}
	}
	for (i=Nfilter/2+1;i<Nfilter;i++)
	{	
		filter[i]=filter[Nfilter-i]; 	
	}
	
	
    return (0);
Error :
	return(-1);	
}

/******************************************************************************/
/*!
* @fn  int _SPM_ts_calc_bp_filter(float * filter, unsigned int Nfilter, float fmin, float fmax, float slope)
*  @brief Calcule le gabarit du filtre en fonction de la bande min et max
*   @param[in] filter pointeur sur les valeurs d'attenuation du filtre en dB 
*   @param[in] Nfilter nombre de poinst constituants le filtre
*   @param[in] fmin frequence de coupure min (frequence reduite de 0 a 0.5;
*   @param[in] fmax frequence de coupure min (frequence reduite de 0 a 0.5;
*   @param[in] slope du filtre en dB/octave;
*   @return -1 Erreur, 1 avertissement, 0 
*   @note Le filtre suppose que l'echelle de frequence reduite va de 0 a 0.5 (demi spectre reel)
*   @note 
*/
/******************************************************************************/
int _SPM_ts_calc_bp_filter(float * filter, unsigned int Nfilter, float fmin, float fmax, float slope)
{

	int i ;
	float fc;
	float temp;
	if (filter==NULL)
	{
		SPM_set_msg("_SPM_ts_calc_bp_filter : pointeur sur la variable filter non alloue\n");
		goto Error;
	}

//printf("_SPM_ts_calc_bp_filter : Nfilter=%d, min=%.4f max=%.2f\n",Nfilter,fmin, fmax);
	// i=0, fc=0, i=Nfilter/2, fc=0.5
	filter[0]=0.0;
    for (i=1;i<Nfilter;i++)
	{
		if (i<=Nfilter/2)
		{
    		fc= ((float)i)/Nfilter;
    		if (FP_Compare(fc,fmin) <0 )
			{
    			temp = 1e-20; //2.0*(1-a)*fc/fmin+2*a-1.0;
				if (FP_Compare(temp,0.) <=0) *(filter+i)=0;
				else *(filter+i) = temp; 
    		} 
			else
				if (FP_Compare(fc,fmax) > 0)
				{
				 	temp = 1e-20; //(a-1)*fc/fmax+2.0-a;
    				if (FP_Compare(temp,0.) <0) *(filter+i) = 0;
					else *(filter+i) = temp;
    			}
				else
				{
    				*(filter+i)=1.0;
				}
		} 
		else
		{
		   *(filter+i)=*(filter+Nfilter-i); 	
		}
    }
    return (0);
Error :
	return(-1);	
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_calc_to_spectrum(float * spectrum, float * fs, unsigned int Nfreq, float *f_to, unsigned int Nto, float* spectrum_to)
*  @brief Calcule le spectre dans les bandes tiers d'octave
*   
*   @return -1 Erreur, 1 avertissement, 0 
*   @note Le filtre suppose que l'echelle de frequence reduite va de 0 a 0.5 (demi spectre reel)
*   @note 
*/
/******************************************************************************/
int SPM_ts_calc_to_spectrum(float * spectrum, float *fs, unsigned int Nfreq, float * f_to, unsigned int Nto, float* spectrum_to)
{
	int i,j,indfreq ;
	float amin=0.74;
	float amax=1.26;
	// i=0, fc=0, i=Nfilter/2, fc=0.5
    for (i=0;i<Nto;i++)
	{
		spectrum_to[i]=0.0;
		indfreq=0;
		for (j=0;j<Nfreq;j++)
		{
			if ( (FP_Compare(fs[j],(f_to[i]*amin)) >=0) && (FP_Compare(fs[j],(f_to[i]*amax)) <=0) )
			{
				spectrum_to[i]=spectrum_to[i]+spectrum[j];
				indfreq++;
			}
		}
		if (indfreq ==0 )
		{
			spectrum_to[i]=1;
		}  
		else 
		{
		   spectrum_to[i] = spectrum_to[i]  / indfreq;
		}
    }
    return (0);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_set_sv_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq) 
*  @brief Setter du filtre correcteur de la sensibilite en reception
* 
*  Ce filtre correcteur definit un gain relatif (en dB) par rapport a une reference
* donnee.
*/
/******************************************************************************/
int SPM_ts_set_sv_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
{
	
	SPM_LOG_MSG("SPM_ts_global_set_sv_filter : Nfreq=%d\n",Nfreq);
	 ts->_TS_sv_filter =  filter;
     ts->_TS_sv_f_axis = f_axis;
     ts->_TS_sv_Nfilter = Nfreq;
	return(0);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_set_sh_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq) 
*  @brief Setter du filtre correcteur de la sensibilite en emission
*   Ce filtre correcteur definit un gain relatif (en dB) par rapport a une reference
* donnee.
*/
/******************************************************************************/
int SPM_ts_set_sh_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
{
	ts->_TS_sh_filter	=  filter;
    ts->_TS_sh_f_axis	= f_axis;
    ts->_TS_sh_Nfilter	= Nfreq;
	return(0);
}

/******************************************************************************/
/*!
* @fn  int SPM_ts_set_cag_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)  
*  @brief Setter du filtre servant au controle automatique du gain
* 
*/
/******************************************************************************/
int SPM_ts_set_cag_filter(SPM_TS *ts, float * filter, float * f_axis, int Nfreq)
{
	ts->_TS_cag_ctrl	= filter;
	ts->_TS_cag_f_axis	= f_axis;
	ts->_TS_cag_Nctrl 	= Nfreq;
	return(0);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_global_init(void);
*	 @brief Fonction initialisant la librairie commune SPM
*    
*  Cette fonction initialise la librairie fftw3f (libfft3f-3.dll)
* 
* @retval 0 sans erreur
* @retval -1 avec erreur (voir SPM_get_msg())
* @retval 1 avec avertissement
*/
/******************************************************************************/
int SPM_ts_global_init(void)
{
// Chargement explicite de la librairie libffw3f.dll
	
	if ( (_SPM_hdll_fftw3f = LoadLibrary("libfftw3f-3")) == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la librairie fftw3f (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
 	fn_fftwf_plan_dft_r2c_1d = (FFTWF_PLAN_R2C) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_plan_dft_r2c_1d");
 
 	if (fn_fftwf_plan_dft_r2c_1d == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_plan_dft_r2c_1d (libfftw3f-3.dll)\n");
	 	goto  Error;									
 	}
    fn_fftwf_plan_dft_c2r_1d = (FFTWF_PLAN_C2R) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_plan_dft_c2r_1d");
 
 	if (fn_fftwf_plan_dft_c2r_1d == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_plan_dft_c2r_1d (libfftw3f-3.dll)\n");
	 	goto  Error;
 	} 
 	fn_fftwf_malloc = (FFTWF_MALLOC) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_malloc");
  	if (fn_fftwf_malloc == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_malloc (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
 
  	fn_fftwf_free = (FFTWF_FREE) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_free");
  	if (fn_fftwf_free == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_free (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
  
 	fn_fftwf_execute = (FFTWF_EXECUTE) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_execute"); 
 	if (fn_fftwf_execute == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_execute (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
 
 	fn_fftwf_destroy_plan = (FFTWF_DESTROY_PLAN) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_destroy_plan"); 
 	if (fn_fftwf_destroy_plan == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_destroy_plan (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
 	fn_fftwf_cleanup = (FFTWF_CLEANUP) GetProcAddress(_SPM_hdll_fftw3f,"fftwf_cleanup"); 
 	if (fn_fftwf_cleanup == NULL)
	{
	 	SPM_set_msg("Erreur chargement de la fonction fftwf_cleanup (libfftw3f-3.dll)\n");
	 	goto  Error;
 	}
	SPM_LOG_MSG("%s\n"," Initialisation globale SPM_ts OK");
 return(0);
	Error :
	return(-1);		
}


/******************************************************************************/
/*!
* @fn  int _SPM_ts_malloc(SPM_TS *ts)
*	 @brief Fonction allouant les variables de la structure SPM_TS
*
* @retval 0 sans erreur
* @retval -1 avec erreur (voir SPM_get_msg())
* @retval 1 avec avertissement
*/
/******************************************************************************/
int _SPM_ts_malloc(SPM_TS *ts)
{
int i;	
float * filter;

	if ( (filter = (float*) malloc(sizeof(float)*ts->Nfft)) == NULL )
	{
		SPM_set_msg("_SPM_ts_malloc :  Erreur allocation memoire de la variable filter\n");
		goto Error;
	}
	for (i=0;i<ts->Nfft;i++)
	{
		*(filter+i) = 1.0;
	}
	ts->filter = filter;
#ifdef SPM_FFT_USE_FFTW
	ts->buffer_t = (float *) (fn_fftwf_malloc)(sizeof(float)*ts->Nfft);
	ts->buffer_tinv =  (float *) (fn_fftwf_malloc)(sizeof(float)*ts->Nfft);
	ts->buffer_f = (fftwf_complex *) (fn_fftwf_malloc)(sizeof(fftwf_complex)*ts->Nfft);
	ts->p = (fn_fftwf_plan_dft_r2c_1d)(ts->Nfft, ts->buffer_t, ts->buffer_f,FFTW_ESTIMATE);
	if(ts->p == NULL)
	{
		SPM_set_msg("_SPM_ts_malloc :  Erreur appel fn_fftwf_plan_dft_r2c_1d (ts->p est NULL)\n");
		goto Error;
	}
	ts->pinv = (fn_fftwf_plan_dft_c2r_1d)(ts->Nfft, ts->buffer_f, ts->buffer_tinv, FFTW_ESTIMATE);
	if(ts->pinv == NULL)
	{
		SPM_set_msg("_SPM_ts_malloc :  Erreur appel fn_fftwf_plan_dft_c2r_1d (ts->pinv est NULL)\n");
		goto Error;
	}
    memset((void *)(ts->buffer_t),0,ts->Nfft);
	ts->spectrum = (float*) malloc(ts->Nfft*sizeof(float));
#endif
	return(0);
Error :
	return(-1);		
}

/******************************************************************************/
/*!
* @fn  int _SPM_ts_free(SPM_TS *ts)
*	 @brief Fonction desallouant les variables de la structure SPM_TS
*  
* @retval 0 sans erreur
* @retval -1 avec erreur (voir SPM_get_msg())
* @retval 1 avec avertissement
*/
/******************************************************************************/
int _SPM_ts_free(SPM_TS *ts)
{
	
	free(ts->filter); 						ts->filter = 0;
	free(ts->spectrum);						ts->spectrum = 0;
#ifdef SPM_FFT_USE_FFTW
	(fn_fftwf_free)(ts->buffer_t); 			ts->buffer_t = 0;  
	(fn_fftwf_free)(ts->buffer_tinv); 		ts->buffer_tinv = 0;
	(fn_fftwf_free)(ts->buffer_f);			ts->buffer_f = 0;
	(fn_fftwf_destroy_plan)(ts->p);			ts->p = 0;
	(fn_fftwf_destroy_plan)(ts->pinv);		ts->pinv = 0;
#endif
	return(0);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_init(SPM_TS*  ts, float Fsamp);
*	 @brief Fonction initialisant la librairie commune SPM
*    
*  Cette fonction initialise la librairie fftw3f (libfft3f-3.dll)
*
* @retval 0 sans erreur
* @retval -1 avec erreur (voir SPM_get_msg())
* @retval 1 avec avertissement
*/
/******************************************************************************/
int SPM_ts_init(SPM_TS*  ts, float Fsamp)
{
	int err;
	
	if (ts==NULL)
	{
	    SPM_set_msg("Pointeur sur les parametres de la librairie ts non initialise\n");
		goto Error;
	}
	
	memset(ts,0,sizeof(SPM_TS));
	
	ts->Fsamp = Fsamp;
//printf("Init Fsamp=%.0f\n", Fsamp);
	ts->Ngrain= 512;
	ts->Nbord = 512;
	ts->Nfft = 1024;
	ts->slope_rate = 48;
	
	
	unsigned int size = 10*ts->Ngrain;
	SPM_ts_set_Nmem(ts,&size); 


	//setting the specific
	ts->cf_low = FREQ_MIN / ts->Fsamp;
	ts->cf_high = FREQ_MAX / ts->Fsamp;
	ts->filter_mode = 0;
	if ((err=_SPM_ts_malloc(ts))!=0)
	{
		goto Error;
	}
 
	return(0);
Error :
	return(-1);	
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_set_Nmem(SPM_TS *ts, unsigned int * value) 
*    @brief Setter du parametre Nmem
*/
/******************************************************************************/
int SPM_ts_set_Nmem(SPM_TS *ts, unsigned int *value)
{
	int i=0;
	
	/* buffer gardant en memoire le signal dopplerise (fonction repeteur)*/
	ts->_TS_Nmem = *value; 
	ts->_TS_Nmem = (((int)(ts->_TS_Nmem/ts->Ngrain)) + 1)*ts->Ngrain; // multiple de Ngrain immediatement superieur
	
	// nettoyage des allocations precentes
	if(ts->_TS_mem_buf) free(ts->_TS_mem_buf);
	if(ts->_TS_cag_buf_cor) free(ts->_TS_cag_buf_cor);
	if(ts->_TS_cag_buf_freq) free(ts->_TS_cag_buf_freq);
	if(ts->_TS_cag_buf_nivmax) free(ts->_TS_cag_buf_nivmax);
	
	// gestion du signal dopllerise
	if ( (ts->_TS_mem_buf = (float*) malloc(sizeof(float)*2*ts->_TS_Nmem)) == NULL )
	{
		SPM_set_msg("SPM_TS_init :  Erreur allocation memoire de la variable _TS_mem_buf\n");
		goto Error;
	}
	ts->_TS_ind_mem = 0; // on part du debut
    ts->_TS_iStamp = 0;
	ts->_TS_dop_res=0;
	ts->_TS_dop_start=1;
	ts->_TS_dop_last=0;
	
	// gestion du CAG
	ts->_TS_cag_Nbuf = ((float)ts->_TS_Nmem)/ts->Ngrain;
	ts->_TS_ind_cag = 0; // on part du debut  
	
	if ( (ts->_TS_cag_buf_cor = (float*) malloc(sizeof(float)*2*ts->_TS_cag_Nbuf)) == NULL )
	{
		SPM_set_msg("SPM_TS_init :  Erreur allocation memoire de la variable _TS_cag_buf\n");
		goto Error;
	}
	for(i=0;i<(2*ts->_TS_cag_Nbuf);i++)
	{
		ts->_TS_cag_buf_cor[i] = 1;
	}
	if ( (ts->_TS_cag_buf_freq = (float*) malloc(sizeof(float)*2*ts->_TS_cag_Nbuf)) == NULL )
	{
		SPM_set_msg("SPM_TS_init :  Erreur allocation memoire de la variable _TS_cag_buf_freq\n");
		goto Error;
	}
	if ( (ts->_TS_cag_buf_nivmax = (float*) malloc(sizeof(float)*2*ts->_TS_cag_Nbuf)) == NULL )
	{
		SPM_set_msg("SPM_TS_init :  Erreur allocation memoire de la variable _TS_cag_buf_nivmax\n");
		goto Error;
	}
	
	
	return(0);
Error:
	return(-1);
	
}






/******************************************************************************/
/*!
* @fn  int SPM_global_close(void);
*	 @brief Fonction fermant la librairie commune SPM
*    
*  Cette fonction decharge la librairie fftw3f (libfft3f-3.dll)
* 
* @retval 0 sans erreur
* @retval -1 avec erreur (voir SPM_get_msg())
* @retval 1 avec avertissement
*/
/******************************************************************************/
int SPM_global_close(void)
{
	if (FreeLibrary(_SPM_hdll_fftw3f)==0)
	{
		SPM_set_msg("Erreur free library libfft3f-3.dll\n");
		goto Error;
	}
	
	return(0);

Error :
	return(-1);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_close(SPM_TS *ts) 
*    @brief Nettoyage des ressources ts
*/
/******************************************************************************/
int SPM_ts_close(SPM_TS *ts)
{
	int err;
	if ((err=_SPM_ts_free(ts))!=0)
	{
		goto Error;
	}
	
	// liberation de tous les pointeurs alloues pour les filtres et le CAG et la dopplerisation
	if(ts->_TS_sv_filter) free(ts->_TS_sv_filter);
	if(ts->_TS_sv_f_axis) free(ts->_TS_sv_f_axis);
	
	if(ts->_TS_sh_filter) free(ts->_TS_sh_filter);
	if(ts->_TS_sh_f_axis) free(ts->_TS_sh_f_axis);
	
	if(ts->cag_ctrl) 		free(ts->cag_ctrl);
	if(ts->_TS_cag_ctrl)	free(ts->_TS_cag_ctrl);
	if(ts->_TS_cag_f_axis)	free(ts->_TS_cag_f_axis);

	if(ts->_TS_mem_buf)			free(ts->_TS_mem_buf);
	if(ts->_TS_cag_buf_cor)		free(ts->_TS_cag_buf_cor);
	if(ts->_TS_cag_buf_freq)	free(ts->_TS_cag_buf_freq);
	if(ts->_TS_cag_buf_nivmax)	free(ts->_TS_cag_buf_nivmax);

	return(0);
Error:
	return(-1);
	
}




/******************************************************************************/
/*!
* @fn static int SPM_ts_compact_cag(SPM_TS * ts) 
*
// remettre toutes les infos CAG au debut du buffer correspondant
*/
/******************************************************************************/
static int SPM_ts_compact_cag(SPM_TS * ts)
{
	int i=0;
	for(i=0;i<ts->_TS_cag_Nbuf ;i++)
	{
		ts->_TS_cag_buf_cor[i] = ts->_TS_cag_buf_cor[ts->_TS_cag_Nbuf+i] ;
		ts->_TS_cag_buf_freq[i] = ts->_TS_cag_buf_freq[ts->_TS_cag_Nbuf+i] ;
		ts->_TS_cag_buf_nivmax[i] = ts->_TS_cag_buf_nivmax[ts->_TS_cag_Nbuf+i] ;
	}
	// la prochaine place libre est au milieu
	ts->_TS_ind_cag=ts->_TS_cag_Nbuf;
	
	
	return(0);
}


/******************************************************************************/
/*!
* @fn int SPM_ts_cag_ctrl(SPM_TS * ts, float * spectrum, int Nfreq);
*	 @brief Fonction calculant le depassement d'un spectre relativement a la courbe de controle
*    
*/
/******************************************************************************/
int SPM_ts_cag_ctrl(SPM_TS * ts, float * spectrum, int Nfreq)
{
	
	int i,ifmax;
	float * cag_ctrl = ts->cag_ctrl;
	float cag_cor,cag_cor_max;
	float amplitude,niv_max;
	
	if (ts->cag_ctrl==NULL)
	{
		SPM_set_msg("SPM_ts_cag_ctrl : courbe de controle non initialisee\n");
		goto Error;
	}
	if (Nfreq!=ts->Nfft/2+1)
	{
		SPM_set_msg("SPM_ts_cag_ctrl : spectre et courbe de controle non coherents\n");
		goto Error;
	}
	
	cag_cor_max=0;
	niv_max=0;
	ifmax=0;
	for (i=1;i<Nfreq;i++)
	{
		amplitude = 2*sqrt(spectrum[i]);
		
		cag_cor = amplitude/cag_ctrl[i];
		//SPM_LOG_MSG("SPM_ts_cag_ctrl : i=%d : cag_cor=%f,  spectrum[i]=%f, cag_ctrl[i] = %f\n",i,cag_cor,spectrum[i],cag_ctrl[i]); 
		
		// recherche depassement maxi ou peak le plus proche de la courbe max
		if (FP_Compare(cag_cor,cag_cor_max) >0)
		{
			cag_cor_max=cag_cor;
			niv_max=amplitude;
			ifmax=i;
			//SPM_LOG_MSG("SPM_ts_cag_ctrl : max --> i = %d f=%f : cag_cor=%f,  spectrum[i]=%f, cag_ctrl[i] = %f\n",
			//	i,(float)i/(float)ts->Nfft,cag_cor,2*sqrt(spectrum[ifmax]),cag_ctrl[i]); 
		}
		
		// recherche peak le plus haut
		if (FP_Compare(amplitude, niv_max) >0)
		{
			niv_max=amplitude;
		}
		
	}
	
	SPM_LOG_MSG("SPM_ts_cag_ctrl : MAX --> i = %d f=%f : cag_cor=%f,  spectrum[i]=%f, cag_ctrl[i] = %f, niv_max=%f\n",
		ifmax,(float)ifmax/(float)ts->Nfft,cag_cor_max,2*sqrt(spectrum[ifmax]),cag_ctrl[ifmax], niv_max); 
	
	ts->_TS_cag_buf_cor[ts->_TS_ind_cag] = cag_cor_max;
	ts->_TS_cag_buf_freq[ts->_TS_ind_cag] = ((float) ifmax)/ts->Nfft;
	ts->_TS_cag_buf_nivmax[ts->_TS_ind_cag] = niv_max;
	ts->_TS_ind_cag++;
	if (ts->_TS_ind_cag>=2*ts->_TS_cag_Nbuf) SPM_ts_compact_cag(ts);
	
	return(0);
Error:
	return(-1);
}


/******************************************************************************/
/*!
* @fn  int SPM_ts_get_cag(SPM_TS * ts, float *gain_cor, float *niveau_max);
*	 @brief Fonction calculant la correction a appliquer depuis le buffer en memoire
*    
*/
/******************************************************************************/
int SPM_ts_get_cag(SPM_TS * ts, float *gain_cor, float *niveau_max)
{
	int i;
	
	*(gain_cor)=0;
	*(niveau_max)=0;

	// nombre de donnees a lire
	int i_mem = ts->_TS_cag_Nbuf;
	if(ts->_TS_ind_cag < ts->_TS_cag_Nbuf) i_mem = ts->_TS_ind_cag;
	
	float max_cag, max_niv, max_max, moy_max;
	max_max = 0;
	moy_max = 0;
	// et on cherche le max
	for (i=0;i<i_mem;i++)
	{
		max_cag= ts->_TS_cag_buf_cor[ts->_TS_ind_cag-i-1];
		max_niv= ts->_TS_cag_buf_nivmax[ts->_TS_ind_cag-i-1];
		
		if (FP_Compare(max_cag,*(gain_cor)) >0) *(gain_cor)=max_cag;
		
		// max du max
		if (FP_Compare(max_niv,max_max) >0) max_max=max_niv;
		
		// moyenne du max
		//moy_max += max_niv;
	}
	
	*(niveau_max)=max_max;
	//*(niveau_max)=moy_max/i_mem;
	
	return(0);
}

/******************************************************************************/
/*!
* @fn  int SPM_ts_fft(SPM_TS * ts, short * data, int Ndata, float* spectrum, int *Nfreq)
*	 @brief Fonction calculant le spectre en amplitude d'un signal
*    
*/
/******************************************************************************/
int SPM_ts_fft(SPM_TS * ts, short * data, int Ndata, float* spectrum, int *Nfreq)
{
	int i =0;
	float * filter = ts->filter;
	
	if (Ndata!=ts->Nfft)
	{
		SPM_set_msg("SPM_ts_fft : Ndata non egal a la taille de FFT (Nfft)\n");
		goto Error;
	}
	
	float * bt = ts->buffer_t;
	fftwf_complex * bf = ts->buffer_f; 
	double deuxpi = 2*Pi();
	double w=1.0;
	double gain=1.0;
	
	for (i=0;i<Ndata;i++)
	{
		switch(ts->window_type)
		{
			case TS_NO_WINDOW:
				w = 1.0;
				gain = 1.0;
				break;
				
			case TS_WINDOW_HANNING:
				gain = 0.5;
	  			w = 0.5*(1-cos(deuxpi*((float)i/(float)Ndata)));
				break;
				
			case TS_WINDOW_FLATTOP:
				gain = 0.22;
	  			w = FLATTOP_A0*cos(0) 
					- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)Ndata));
					+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)Ndata));
					- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)Ndata));
					+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)Ndata));
				break;
				
			default: break;
		}
	  	
		// copie de la valeur
		*(bt+i) = (w/gain) * (float) *(data+i);
	}

#ifdef SPM_FFT_USE_FFTW
	(fn_fftwf_execute) (ts->p);
	
	// on annule la composante continue (DC)
	bf[0][0] = 0;
	bf[0][1] = 0;

	*(Nfreq)=Ndata/2+1;
	for (i=0;i<*(Nfreq);i++)
	{
		*(spectrum+i) = (bf[i][0]*bf[i][0] + bf[i][1]*bf[i][1])*filter[i]*filter[i];
		
	}
	
#endif
	 
	return(0);
Error:
	return(-1);
}


/******************************************************************************/
/*!
* @fn int SPM_ts_filter_cyc(SPM_TS * ts, float * data_in, int Ndata, float * data_out,int * delay) 
*	 @brief Fonction filtrant le signal dans le domaine frequentiel
*
*  Le filtre applique est le filtre filter de la structure initialise dans _SPM_ts_calc_global_filter()
*/
/******************************************************************************/
int SPM_ts_filter_cyc(SPM_TS * ts, float * data_in, int Ndata, float * data_out,int * delay)
{
	
// =====================================================
// type d'algo de filtrage (gestion du buffer glissant)
#define WITH_DELAY
// =====================================================

	int i;
	//printf("read data in...\n");
	//copie dans le buffer
	float nfft = ts->Nfft;
	float * filter = ts->filter;
	float * spectrum = ts->spectrum;
	
#ifdef SPM_FFT_USE_FFTW 
	fftwf_complex * bf = ts->buffer_f;
	
	
	// si on n'a pas assez de points on fait du "padding"
	if(Ndata == ts->Ngrain)
	{
#ifdef WITH_DELAY
		memcpy((void*) (ts->buffer_t+ts->Nbord),(const void*)data_in , sizeof(float) *ts->Ngrain);
#else
		memcpy((void*) (ts->buffer_t+ts->Nbord/2),(const void*)data_in , sizeof(float) *ts->Ngrain);
#endif
	}
	else if (Ndata < ts->Ngrain)
	{
#ifdef WITH_DELAY
		memset((void*) (ts->buffer_t+ts->Nbord),0,sizeof(float) *ts->Ngrain);
		memcpy((void*) (ts->buffer_t+ts->Nbord),(const void*)data_in , sizeof(float) *Ndata);
#else
		memset((void*) (ts->buffer_t+ts->Nbord/2),0,sizeof(float) *ts->Ngrain);
		memcpy((void*) (ts->buffer_t+ts->Nbord/2),(const void*)data_in , sizeof(float) *Ndata);
#endif
	}
	else
	{
		char txt[200]={0};
		sprintf(txt,"SPM_ts_filter_cyc : Ndata (taille des donnes en entrees=%d)  doit etre egale ou inf a Ngrain (granularite=%d)\n",
			Ndata,ts->Ngrain);
		SPM_set_msg(txt);
		goto Error;
	}
	
	
#ifndef WITH_DELAY
	// windowing
	double deuxpi = 2*Pi();
	double w=1.0;
	double gain=1.0;
	
	ts->window_type = TS_WINDOW_FLATTOP; //TS_WINDOW_HANNING;
	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<nfft;i++)
		{
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)i/(float)nfft)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)nfft));
						- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)nfft));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_t+i) = (w/gain) * (float) *(ts->buffer_t+i);
		}
	}
#else
	
	
	// windowing
	double deuxpi = 2*Pi();
	double w=1.0;
	double gain=1.0;
	
	ts->window_type = TS_NO_WINDOW; //TS_WINDOW_HANNING;
	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<nfft;i++)
		{
			
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)i/(float)nfft)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)nfft));
						- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)nfft));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_t+i) = (w/gain) * (float) *(ts->buffer_t+i);
		}
	}
	
	
#endif
	
	// fft
    (fn_fftwf_execute) (ts->p);

	// on annule la composante continue (DC)
	bf[0][0] = 0;
	bf[0][1] = 0;


    // application du filtre
	if (ts->filter_mode==0)
	{
		
    	for (i=0;i<ts->Nfft;i++)
		{
       		bf[i][0] = bf[i][0]/nfft;
       		bf[i][1] = bf[i][1]/nfft;
    	}
	} 
	else
	{
		for (i=0;i<ts->Nfft;i++)
		{
       		bf[i][0] = (bf[i][0]/nfft)*filter[i];
       		bf[i][1] = (bf[i][1]/nfft)*filter[i];
			
    	}
		
		if (ts->filter_mode&TS_CAG_CTRL)
		{
			for (i=0;i<ts->Nfft;i++)
			{
       		   
			   spectrum[i] = bf[i][0] * bf[i][0] + bf[i][1] * bf[i][1];
			   
			}
			SPM_ts_cag_ctrl(ts, spectrum, ts->Nfft/2+1);
    	}
		
	}

	//fft inverse
    (fn_fftwf_execute)(ts->pinv);
	
	
#endif
	
	
#ifdef WITH_DELAY

	
	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<nfft;i++)
		{
			int ii = i + 0.25*nfft;
			
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)ii/(float)nfft)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)ii/(float)nfft));
						+ FLATTOP_A2*cos(2*deuxpi*((float)ii/(float)nfft));
						- FLATTOP_A3*cos(3*deuxpi*((float)ii/(float)nfft));
						+ FLATTOP_A4*cos(4*deuxpi*((float)ii/(float)nfft));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_tinv+i) =  (float) *(ts->buffer_tinv+i) / (w/gain);
			
			
			
		}
	}
	
	

	
	memcpy((void*) data_out, (const void *) (ts->buffer_tinv+ts->Nbord/2),sizeof(float)*ts->Ngrain);

	*(delay)= ts->Nbord/2;
    //copie du bord gauche vers le bord droit
    if (ts->Nbord>0)
	{
       memcpy((void *) ts->buffer_t, (const void *) (ts->buffer_t+ts->Nbord), sizeof (float)*ts->Nbord);
    }
#else
	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<nfft;i++)
		{
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)i/(float)nfft)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)nfft));
						- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)nfft));
						+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)nfft));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_tinv+i) =  (float) *(ts->buffer_tinv+i) / (w/gain);
		}
	}

    memcpy((void*) data_out, (const void *) (ts->buffer_tinv+ts->Nbord/2),sizeof(float)*Ndata);

	*(delay)= 0;
    //copie du bord gauche vers le bord droit
    if (ts->Nbord>0)
	{
       memcpy((void *) ts->buffer_t, (const void *) (ts->buffer_t+ts->Nfft-ts->Nbord/2), sizeof (float)*ts->Nbord/2);
    }
#endif
	
	return(0);
Error :
	return(-1);
}




/*
// ESSAI D'ALGO (ne fonctionne pas suffisamment bien pour etre retenu)




int SPM_ts_filter_cyc(SPM_TS * ts, float * data_in, int Ndata, float * data_out,int * delay)
{
	

	int i;
	//printf("read data in...\n");
	//copie dans le buffer
	float nfft = ts->Nfft;
	float * filter = ts->filter;
	float * spectrum = ts->spectrum;
	
#ifdef SPM_FFT_USE_FFTW 
	fftwf_complex * bf = ts->buffer_f;
	
	
	// on prepare les donnees de sortie par pport au tour precedent
    memcpy((void*) data_out, (const void *) (ts->buffer_tinv+ts->Nbord),sizeof(float)*ts->Ngrain);
	
	// si on n'a pas assez de points on fait du "padding"
	if (Ndata <= ts->Ngrain)
	{
		memset((void*) (ts->buffer_t),0,sizeof(float) *2*ts->Ngrain);
		memcpy((void*) (ts->buffer_t),(const void*)data_in , sizeof(float) *Ndata);
	}
	else
	{
		char txt[200]={0};
		sprintf(txt,"SPM_ts_filter_cyc : Ndata (taille des donnes en entrees=%d)  doit etre egale ou inf a Ngrain (granularite=%d)\n",
			Ndata,ts->Ngrain);
		SPM_set_msg(txt);
		goto Error;
	}
	
	
	// windowing
	double deuxpi = 2*Pi();
	double w=1.0;
	double gain=1.0;
	
	ts->window_type = TS_NO_WINDOW; //TS_WINDOW_HANNING; //TS_WINDOW_FLATTOP; 
	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<ts->Ngrain;i++)
		{
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)i/(float)ts->Ngrain)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)ts->Ngrain));
						+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)ts->Ngrain));
						- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)ts->Ngrain));
						+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)ts->Ngrain));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_t+i) = (w/gain) * (float) *(ts->buffer_t+i);
		}
	}

	
	// fft
    (fn_fftwf_execute) (ts->p);
	

	// on annule la composante continue (DC)
	bf[0][0] = 0;
	bf[0][1] = 0;


    // application du filtre
	if (ts->filter_mode==0)
	{
		
    	for (i=0;i<ts->Nfft;i++)
		{
       		bf[i][0] = bf[i][0]/nfft;
       		bf[i][1] = bf[i][1]/nfft;
    	}
	} 
	else
	{
		for (i=0;i<ts->Nfft;i++)
		{
       		bf[i][0] = (bf[i][0]/nfft)*filter[i];
       		bf[i][1] = (bf[i][1]/nfft)*filter[i];
			
    	}
		
		if (ts->filter_mode&TS_CAG_CTRL)
		{
			for (i=0;i<ts->Nfft;i++)
			{
       		   
			   spectrum[i] = bf[i][0] * bf[i][0] + bf[i][1] * bf[i][1];
			   
			}
			SPM_ts_cag_ctrl(ts, spectrum, ts->Nfft/2+1);
    	}
		
	}

	//fft inverse
    (fn_fftwf_execute)(ts->pinv);
	
	
#endif
	
	

	
	if(ts->window_type != TS_NO_WINDOW)
	{
		for (i=0;i<ts->Ngrain;i++)
		{
			switch(ts->window_type)
			{
				case TS_WINDOW_HANNING:
					gain = 0.5;
		  			w = 0.5*(1-cos(deuxpi*((float)i/(float)ts->Ngrain)));
					break;
					
				case TS_WINDOW_FLATTOP:
					gain = 0.22;
		  			w = FLATTOP_A0*cos(0) 
						- FLATTOP_A1*cos(1*deuxpi*((float)i/(float)ts->Ngrain));
						+ FLATTOP_A2*cos(2*deuxpi*((float)i/(float)ts->Ngrain));
						- FLATTOP_A3*cos(3*deuxpi*((float)i/(float)ts->Ngrain));
						+ FLATTOP_A4*cos(4*deuxpi*((float)i/(float)ts->Ngrain));
					break;
					
				default: break;
			}
	  	
			// copie de la valeur
			*(ts->buffer_tinv+i) =  (float) *(ts->buffer_tinv+i) / (w/gain);
		}
	}
	

	
	// on ajoute le resultat à ce qu'il y a déjà dans data_out
	for(int i=0;i<Ndata;i++) {
		*(data_out+i) += *(ts->buffer_tinv+i);
	}
	
	
	return(0);
Error :
	return(-1);
}

*/

/******************************************************************************/
/*!
* @fn   static int SPM_ts_compact_dop_mem(SPM_TS * ts)
*	 @brief Fonction .
*
*/
/******************************************************************************/
static int SPM_ts_compact_dop_mem(SPM_TS * ts)
{
	int i=0;
	for(i=0;i<ts->_TS_Nmem;i++)
	{
		ts->_TS_mem_buf[i] = ts->_TS_mem_buf[ts->_TS_Nmem+i];
	}
	ts->_TS_ind_mem=ts->_TS_Nmem;
	
	return(0);
}


/******************************************************************************/
/*!
* @fn int SPM_ts_dop_mem(SPM_TS * ts, float * data_in, int Ndata_in, float doppler, float ** data_out, int * Ndata_out)
*	 @brief Fonction dopplerisant et memorisant le signal d'entree.
*
*/
/******************************************************************************/
int SPM_ts_dop_mem(SPM_TS * ts, float * data_in, int Ndata_in, float doppler, float** data_out, int * Ndata_out)
{
	int i;
	float a;
	
	if(FP_Compare(doppler,0.) == 0)
	{
		
		for (i=0;i<Ndata_in;i++)
		{
			// on copie chaque point
		   ts->_TS_mem_buf[ts->_TS_ind_mem] = data_in[i];
		   // on passe au suivant
		   ts->_TS_ind_mem++;
		   // si on arrive a la fin du buffer, on deplace tout vers le debut
	        if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);  
		}
	}
	else
	{
		for (i=0;i<Ndata_in;i++)
		{
			// SI debut de traitement
			if (ts->_TS_dop_start)
			{ 
				// on copie simplement le premier point
			   ts->_TS_mem_buf[ts->_TS_ind_mem] = data_in[i];
			   // on passe au suivant
			   ts->_TS_ind_mem++;
			   // si on arrive a la fin du buffer, on deplace tout vers le debut
		        if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);  
			
				ts->_TS_dop_start=0;
			
				if (FP_Compare(doppler,0)<0)
				{
				   ts->_TS_dop_res=-1;
				}  
				else
				{
				   ts->_TS_dop_res = 0;
				}
				ts->_TS_dop_last = data_in[i];
				//fprintf(stdout,"dop_star dop_res=%f\n",_TS_dop_res);
			
			// SINON on continue le traitement
			} 
			else
			{
			   a = ts->_TS_dop_res+doppler;
			   //fprintf(stdout,"a=%f\n",a);
		       if (FP_Compare(a,0.)<0)
			   {
				   if (FP_Compare(a,-1.) >0)
				   {
					 ts->_TS_mem_buf[ts->_TS_ind_mem] = ts->_TS_dop_last*(1+a)/(1+doppler)+(doppler-a)/(1+doppler)*data_in[i];
					 ts->_TS_ind_mem++;
		             if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);   
				     ts->_TS_dop_res =  a;
				 
				   } 
				   else
					   if (FP_Compare(a,-2.) >0)
					   {
					   		a=a+1;
					   		//fprintf(stdout,"DROP a = %f\n",a);
					   		ts->_TS_dop_last = data_in[i];
					   		ts->_TS_dop_res = a;
				   		}
					   else
					   {
					   		goto Error;
				   		}
			   } 
			   else
				   if (FP_Compare(a,1.) <0)
				   {
				  		ts->_TS_mem_buf[ts->_TS_ind_mem] = ts->_TS_dop_last*a/(1+doppler)+(1+doppler-a)/(1+doppler)*data_in[i];
				  		ts->_TS_ind_mem++;
		          		if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);   
				  		ts->_TS_dop_res =  a;
			  		}
				   else
					   if (FP_Compare(a,2.) <0)
					   {
							ts->_TS_mem_buf[ts->_TS_ind_mem] = ts->_TS_dop_last*a/(1+doppler)+(1+doppler-a)/(1+doppler)*data_in[i]; 
			
							ts->_TS_ind_mem++;
		        			if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);   
							a=a-1;
							//fprintf(stdout,"INSERT a = %f\n",a);
							ts->_TS_mem_buf[ts->_TS_ind_mem] = ts->_TS_dop_last*a/(1+doppler)+(1+doppler-a)/(1+doppler)*data_in[i] ;
			
							ts->_TS_ind_mem++;
		        			if (ts->_TS_ind_mem>=2*ts->_TS_Nmem) SPM_ts_compact_dop_mem(ts);   
							ts->_TS_dop_res =  a;
			  			}
					   else
					   {
				  			goto Error;
			  			}
	    
		  	ts->_TS_dop_last=data_in[i];
		  }
		}
		
	}
	
	
	// preparation de la sortie
	int delta = 0;
	int num=0;
	
	if(ts->_TS_ind_mem < ts->_TS_Nmem)
	{  // cas 'buffer pas plein'
		delta = 0;
		num = ts->_TS_ind_mem;
	}
	else
	{  // cas buffer plein (a moitie en fait)
		delta = ts->_TS_ind_mem-ts->_TS_Nmem;
		num = ts->_TS_Nmem;
	}

	// et on retourne les infos utiles
	*(data_out)=ts->_TS_mem_buf+delta;
	*(Ndata_out) = num;
	
	return(0);
Error :
	return(-1);
}


/******************************************************************************/
/*!
* @fn   int SPM_ts_set_cf_low(SPM_TS * ts, float * value) 
*    @brief Setter du parametre cf_low de la librairie SPM_ts
*/
/******************************************************************************/
int SPM_ts_set_cf_low(SPM_TS * ts, float * value)
{
	int err;
	if (FP_Compare(*value,ts->cf_high) >=0)
	{
		SPM_set_msg("SPM_ts : La frequence de coupure basse ne peut superieure ou egale a la frequence de coupure haute\n");
		goto Error;
	}
	ts->cf_low = *value;
	if ( (err=_SPM_ts_calc_global_filter(ts))==-1)
	{
		goto Error;
	}
	SPM_LOG_MSG("%s\n","SPM_ts_set_cf_low : Filtre global recalcule");
	return(0);
Error:
	return(-1);
}

/******************************************************************************/
/*!
* @fn  int SPM_ts_set_cf_high(SPM_TS * ts, float * value) 
*    @brief Setter du parametre cf_low de la librairie SPM_ts
*/
/******************************************************************************/
int SPM_ts_set_cf_high(SPM_TS * ts, float * value)
{
	int err;
	if (FP_Compare(*value,ts->cf_low) <=0 )
	{
		SPM_set_msg("SPM_ts : La frequence de coupure basse ne peut superieure ou egale a la frequence de coupure haute\n");
		goto Error;
	}
	ts->cf_high = *value;  
	if ( (err=_SPM_ts_calc_global_filter(ts))==-1)
	{
		goto Error;
	}
	SPM_LOG_MSG("%s\n","SPM_ts_set_cf_high : Filtre global recalcule");
	return(0);
Error:
	return(-1);
}

/******************************************************************************/
/*!
* @fn   int SPM_ts_set_Nfft(SPM_TS *ts, unsigned int * value) 
*    @brief Setter du parametre Nfft
*/
/******************************************************************************/
int SPM_ts_set_Nfft(SPM_TS *ts, unsigned int *value)
{
	int err;
	ts->Nfft=*value;
	ts->Ngrain = (ts->Nfft)/2;
	ts->Nbord = ts->Ngrain;
	if ((err=_SPM_ts_free(ts))!=0)
	{
		goto Error;
	}
	
	unsigned int size = ts->_TS_Nmem;
	SPM_ts_set_Nmem(ts,&size); 


	
	if ((err=_SPM_ts_malloc(ts))!=0)
	{
		goto Error;
	}
	return(0);
Error:
	return(-1);
	
}

/******************************************************************************/
/*!
* @fn  int SPM_ts_set_mode(SPM_TS *ts, unsigned int * value) 
*    @brief Setter du parametre Nfft
*/
/******************************************************************************/
int SPM_ts_set_mode(SPM_TS *ts, unsigned int *value)
{
	int err;
	ts->filter_mode = *value;
		
//printf("TS mode=%d \n", ts->filter_mode);		
	if ((err=_SPM_ts_calc_global_filter(ts))!=0)
	{
		goto Error;
	}
	return(0);
Error:
	return(-1);
	
}

/******************************************************************************/
/*!
* @fn  int SPM_ts_set_Windowing(SPM_TS *ts, unsigned int * value) 
*    @brief Setter du parametre window_type TS_NO_WINDOW TS_WINDOW_HANNING TS_WINDOW_FLATTOP
*/
/******************************************************************************/
int SPM_ts_set_Windowing(SPM_TS *ts, unsigned int *value)
{
	ts->window_type=*value;
	return(0);
}

