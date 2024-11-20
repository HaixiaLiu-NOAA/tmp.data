;===================================================
;
; Name: assess_diag.pro
;
; Type: IDL Program
;
; Description: 
;       This program interfaces with the read_diags.pro
;       IDL procedure which reads GSI diagnostic files
;       for satellite radiances.  The diagnostic data
;       is save in data structures.
;
; 
;
; Original Code:
;       Kevin Garrett    2011-12-21
;
;
;===================================================

@./read_diags_new.pro
@./plot_map_sat_all.pro

;PRO geosir_maps   ; emily

loadct, 33
close,/all

;---define experiment name and cycle date
CDATE='2020100712'
CDATE='2022053112'
CDATE='2022052906'
CDATE='2022060112'
CDATE='2022043018'

;---diag file created on zeus (0: no, 1: yes)
zeus=1

;---set sensor id/string
SENSOR='amsua_metop-a'
SENSOR='cris-fsr_n20'
SENSOR='abi_g16'
SENSOR='seviri_m11'

;---guess or analysis diag file?
ges=1
anl=0
if (ges eq 1) then TYPSTR='ges'
if (anl eq 1) then TYPSTR='anl'
IF (ges eq 0 and anl eq 0) THEN BEGIN
	print,'GES or ANL flag must be set!'
	STOP
ENDIF

;---define paths to data files
dataPath='/gpfs/dell2/emc/modeling/noscrub/Haixia.Liu/G17/data_diag/v16rt2/'
dataPath='/scratch2/NCEPDEV/stmp1/Haixia.Liu/temp4v16rt2/test_gdas.2020100712.noRcov/'
dataPath='/scratch2/NCEPDEV/stmp1/Haixia.Liu/temp/gdas.20200827/12/atmos/'
dataPath='/scratch1/NCEPDEV/stmp2/Haixia.Liu/CRTM240/crtm240_src_fix_cf.gfdl/'
dataPath='/scratch2/NCEPDEV/stmp1/Haixia.Liu/temp/sevcsr/temp/sevasr/'
dataPath='/scratch2/NCEPDEV/stmp1/Haixia.Liu/temp/sevcsr/temp/temp/sevcsr/'
dataPath='/scratch2/NCEPDEV/stmp1/Haixia.Liu/WORK-C766/v17-sevasr.20220430183/'

;diagFile='diag_'+SENSOR+'_'+TYPSTR+'.'+CDATE+'.nc4'
diagFile=dataPath+'diag_'+SENSOR+'_'+TYPSTR+'.'+CDATE+'.nc4'
;diagFile='/scratch1/NCEPDEV/da/Iliana.Genkova/stmp/ROTDIRS/noAMV_1/enkfgdas.20200609/00/gdas.t00z.gsidiags/dir.0041/'+SENSOR+'_01.nc4'
;diagFile='/scratch2/NCEPDEV/stmp1/Haixia.Liu/temp/temp/diag_amsua_metop-a_ges.2020060900_ensmean.nc4'

;---Define image names and paths
imagePath='/gpfs/dell2/emc/modeling/noscrub/Haixia.Liu/G17/figure/horiz_maps/'
imagePath='./SEVCSR/'
imagePath='./SEVASR/'

verbose=1 ;1-print diagnostic info to screen during read 0-off

print,'Read diagnostic file? (0: No, 1: Yes)'
;read,read_data_answer ; orig
read_data_answer=1     ; emily_test
if (read_data_answer eq 0) then goto, filter
;---Fill data structures with data
print, 'Diagnostic files to read: '
print, diagFile
print, 'Reading...', diagFile
read_diags_new,diagFile,obsdata1,metadata1,nobs1,nchan1,verbose=verbose,ChanInfo=ChanInfo1
print, 'nchan1=',nchan1
print, 'nobs1=',nobs1
print, 'ChanInfo1 channel_number: ', ChanInfo1(*).channel_number
print, 'ChanInfo1 wave number   : ', ChanInfo1(*).wave
print, 'Done reading diagnostic files'

 lat1=metadata1.cenlat
 lon1=metadata1.cenlon
print, 'lon:',lon1

print, 'maxlon,minlon:',max(lon1),min(lon1)
print, 'maxlat,minlat:',max(lat1),min(lat1)

text=''
read, text

filter:

sfc2plot=[0]                     ;0-all, 1-water, 2-ice, 3-land, 4-snow
;sfc2plot=[0,1,2,3,4]            ;0-all, 1-water, 2-ice, 3-land, 4-snow
nsfc=n_elements(sfc2plot)
print, 'nsfc = ', nsfc

;--- Allocate arrays to hold data from diagnostic files
Sim_clr  = fltarr(nobs1,nchan1)
Obs1     = fltarr(nobs1,nchan1)
OmB_BC1  = fltarr(nobs1,nchan1)
OmB_nBC1 = fltarr(nobs1,nchan1)
ErrInv1  = fltarr(nobs1,nchan1)
Obserr1  = fltarr(nobs1,nchan1)
QC_Flag1 = fltarr(nobs1,nchan1)
;SDTB1    = fltarr(nobs1) ; BT stdev
rclrsky1 = fltarr(nobs1)
SDTBarr  = fltarr(nobs1,nchan1) ; BT stdev
OBSTM    = fltarr(nobs1)

;SDTB1[0:nobs1-1]          = metadata1[0:nobs1-1].wind_speed    ; temperally stored BT stdev from chn10.3 in setuprad
rclrsky1[0:nobs1-1]       = 100.-metadata1[0:nobs1-1].cldfrac_clw   

OBSTM[0:nobs1-1]          = metadata1[0:nobs1-1].time      
print, 'max_time,min_time=',max(OBSTM),min(OBSTM)
;stop

;--- Extract desired variables from diagnostic files
FOR iChan=0,nchan1-1 DO BEGIN
    Obs1[0:nobs1-1,ichan]     = obsdata1[0:nobs1-1].Obs[iChan]
    Obs1[where(Obs1 [*,ichan] gt 1000.),ichan] = !Values.F_NAN
    OmB_BC1[0:nobs1-1,ichan]  = obsdata1[0:nobs1-1].Depar_BC[iChan]
    OmB_nBC1[0:nobs1-1,ichan] = obsdata1[0:nobs1-1].Depar_NBC[iChan]
    Sim_clr[0:nobs1-1,ichan]  = Obs1[0:nobs1-1,ichan] - OmB_nBC1[0:nobs1-1,ichan]
    ErrInv1[0:nobs1-1,ichan]  = obsdata1[0:nobs1-1].ErrInv[iChan]
    QC_Flag1[0:nobs1-1,ichan] = obsdata1[0:nobs1-1].QC_Flag[iChan]
    SDTBarr[0:nobs1-1,ichan]= obsdata1[0:nobs1-1].surf_emiss[iChan] ; temperally stored BT stdev
ENDFOR

minlon  =  -80
maxlon  =  80
loncen  = 0
minlat  = -80
maxlat  =  80

 symsize = 0.3
 ctit = ''
 lat1=metadata1.cenlat
 lon1=metadata1.cenlon

print, 'maxlon,minlon:',max(lon1),min(lon1)
print, 'maxlat,minlat:',max(lat1),min(lat1)

text=''
read, text

ichan=5
chidx=5
 outimagefile=imagePath+SENSOR+'_'+TYPSTR+'_cldfrc'+CDATE+'_ch'+strtrim(chidx+1,1)+'.ps'
 tit=strcompress('cloud fraction - '+SENSOR+' Ch '+string(chidx+1)+'!C')
 maxobs=max(metadata1[0:nobs1-1].cldfrac_clw)
 minobs=min(metadata1[0:nobs1-1].cldfrac_clw)
 print, 'maxobs,minobs=', maxobs,minobs
 plot_map_sat_all, metadata1[0:nobs1-1].cldfrac_clw, lat1, lon1, loncen=loncen, $
                  varmax=maxobs, varmin=minobs, $
                  lonmin=minlon,lonmax=maxlon,latmax=maxlat,latmin=minlat,hardcopy=1,$
                  symsize=symsize,title=tit,equa=0,outf=outimagefile

ichan=5
chidx=5
 outimagefile=imagePath+SENSOR+'_'+TYPSTR+'_stdev'+CDATE+'_ch'+strtrim(chidx+1,1)+'.ps'
 tit=strcompress('BT stdev - '+SENSOR+' Ch '+string(chidx+1)+'!C')
 maxobs=max(SDTBarr[0:nobs1-1,ichan])
 minobs=min(SDTBarr[0:nobs1-1,ichan])
 print, 'maxobs,minobs=', maxobs,minobs
 plot_map_sat_all, SDTBarr[0:nobs1-1,ichan], lat1, lon1, loncen=loncen, $
;                 varmax=maxobs, varmin=minobs, $
                  varmax=1., varmin=0., $
                  lonmin=minlon,lonmax=maxlon,latmax=maxlat,latmin=minlat,hardcopy=1,$
                  symsize=symsize,title=tit,equa=0,outf=outimagefile

openw, lun, 'stats.txt', /get_lun
free_lun, lun

   openw, 1, 'stats.txt', / append
   qc_clrsky=where(rclrsky1[0:nobs1-1] LT 98, nobs_fail_clrsky)
   printf, 1, '#of obs tossed by rclrsky<98% : ', nobs_fail_clrsky
   qc_stdev=where(SDTBarr[0:nobs1-1,5] GT 0.5, nobs_fail_stdev)
   printf, 1, '#of obs tossed by stdev_chn10.8>0.5K : ',nobs_fail_stdev
   qc_2=where(SDTBarr[0:nobs1-1,5] GT 0.5 or rclrsky1[0:nobs1-1] LT 98, nobs_fail_2qc)
   printf, 1, '#of obs tossed by stdev_chn10.8>0.5K or rclrsky<98%: ',nobs_fail_2qc
   close, 1

stop
ichan=1
for ichan=0,nchan1-1 do begin

   chidx=ichan

   outimagefile=imagePath+SENSOR+'_'+TYPSTR+'_obs'+CDATE+'_ch'+strtrim(chidx+1,1)+'.ps'
;  outimagefile=imagePath+SENSOR+'_'+TYPSTR+'_obs'+CDATE+'_ch'+strtrim(chidx+1,1)+'_qc.ps'
   tit=strcompress('Obs Tb - '+SENSOR+' Ch '+string(chidx+1)+'!C')
   maxobs=max(Obs1[0:nobs1-1,ichan])
   minobs=min(Obs1[0:nobs1-1,ichan])
   qcindx=where(ErrInv1[0:nobs1-1,ichan] GT 0.000001,nobsqc)
  print, 'maxobs,minobs,nobs1,nobsqc=', maxobs,minobs,nobs1,nobsqc
   openw, 1, 'stats.txt', / append
   printf, 1, 'ichan=',ichan
   printf, 1, 'maxobs,minobs,nobs1,nobsqc=', maxobs,minobs,nobs1,nobsqc
   close, 1
   if(ichan eq 1) then begin
     maxobs=260
     minobs=225
   endif
   plot_map_sat_all, Obs1[0:nobs1-1,ichan], lat1, lon1, loncen=loncen, $
;  plot_map_sat_all, Obsdata1(qcindx).Obs[ichan], lat1(qcindx), lon1(qcindx), loncen=loncen, $
                    varmax=maxobs, varmin=minobs, $
                    lonmin=minlon,lonmax=maxlon,latmax=maxlat,latmin=minlat,hardcopy=1,$
                    symsize=symsize,title=tit,equa=0,outf=outimagefile

ENDFOR

END
