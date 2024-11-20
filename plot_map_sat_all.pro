pro plot_map_sat_all,var,lat,lon,loncen=loncen,latmin=latmin,latmax=latmax,$
    lonmin=lonmin,lonmax=lonmax,use=use,varmax=varmax,varmin=varmin,$
    title=title,colbar_title=colbar_title,window=window,symsize=symsize,$
    spol=spol,npol=npol,equa=equa,hardcopy=hardcopy,outf=outf

; N.B. Var is the variable to be plotted and must be a 1D vector 


if (keyword_set(latmin) le 0) then latmin=-90.
if (keyword_set(latmax) le 0) then latmax=90.
if (keyword_set(lonmin) le 0) then lonmin=-180.
if (keyword_set(lonmax) le 0) then lonmax=180.
if (keyword_set(loncen) le 0) then loncen=0.
if (keyword_set(window) le 0) then window=0
if (keyword_set(symsize) le 0) then symsize=0.5
if (keyword_set(spol) le 0) then spol=0
if (keyword_set(npol) le 0) then npol=0
if (keyword_set(hardcopy) le 0) then hardcopy=0

;lonmin=0.0

 print, 'loncen=',loncen,lonmin,lonmax
;lat=reform(meta.cenlat)
;lon=reform(meta.cenlon)
;tmp=where(lon gt 180.0)
;lon(tmp)=lon(tmp)-360.

if (keyword_set(use) le 0) then begin
  use=where(lat gt latmin and lat lt latmax and $
              lon gt lonmin and lon lt lonmax,ct)
  if (ct eq 0) then begin
    print,'No points in plot area'
    return
  endif
endif
 
if (keyword_set(varmin) le 0) then begin
  minval=min(var(use))
endif else begin
   minval=varmin
endelse

if (keyword_set(varmax) le 0) then begin
 maxval=max(var(use))
endif else begin
  maxval=varmax
endelse

if (keyword_set(title) le 0) then begin
  title1=' '
endif else begin
  title1=title
endelse 

set_filled_circle
;loadct,5
loadct,33 ; emily_test

if (hardcopy eq 0) then begin
 set_plot,'x'
 !p.font=-1
 cgDisplay,wid=window
endif else begin
  ;outfile='plot_map.ps'
  outfile=outf
  cgPS_Open,outfile,/nomatch,/landscape

  cgDisplay, 1200,600
; cgDisplay, 600,600
; cgDisplay, 900,600
endelse

head=' '

;lat=reform(meta.cenlat)
;lon=reform(meta.cenlon)
 
;Winpos=[0.05, 0.18, 0.98, 0.8] 
Winpos=[0.10, 0.15, 0.85, 0.85] 

if (spol ne 0) then begin
  cgmap_set,-90.,/satellite,limit=[latmin,lonmin,latmax,lonmax],$
   title=title1,/grid,/horizon,Position=winpos,/continents
endif else if (npol ne 0) then begin
  cgmap_set,90.,/satellite,limit=[latmin,lonmin,latmax,lonmax],$
   title=title1,/grid,/horizon,Position=winpos,/continents
endif else if (equa ne 0) then begin
  cgmap_set,-75.0,0.0,/satellite,limit=[latmin,lonmin,latmax,lonmax],$
   title=title1,/grid,/horizon,Position=winpos,/continents
endif else begin
  print, 'loncen=',loncen,lonmin,lonmax
  cgmap_set,0.0,loncen,limit=[latmin,lonmin,latmax,lonmax],charsize=1.2, $
   title=title1,Position=winpos,/continents
endelse

colour=bytscl(var,min=minval,max=maxval)

cgplots,lon(use),lat(use),color=colour(use),psym=8,symsize=symsize,noclip=0
cgmap_continents

if (keyword_set(colbar_title) le 0) then begin
  title1=' '
endif else begin
  title1=colbar_title
endelse
cgColorbar,range=[minval,maxval],title=title1,charsize=1.0, $
    position=[0.10, 0.11, 0.85, 0.15],font=0

if (hardcopy ne 0) then begin
  cgPS_Close
  print, 'Outfile is ',outfile
; cgPS2Raster, outfile, /PNG, Width=600, Density=600, /delete_ps
; cgPS2Raster, outfile, /PNG, Width=900, Density=600
  cgPS2Raster, outfile, /PNG, Width=1200, Density=600, /delete_ps
endif

print, 'harcopy=',hardcopy


return

end
