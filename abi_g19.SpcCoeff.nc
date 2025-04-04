CDF       
      
n_Channels     
      
   write_module_history      F$Id: SpcCoeff_netCDF_IO.f90 2024-02-12 21:46:41Z yingtao.ma@noaa.gov $     creation_date_and_time        2024/09/03, 16:32:20 -0000UTC      Release             Version             	Sensor_Id         abi_g19    WMO_Satellite_Id      ���   WMO_Sensor_Id         ���   Title         iSpectral coefficients for abi_g19 derived from SRF data file abi_g19.osrf.nc and solar data file solar.nc      History       �$Id: Create_SpcCoeff.f90 2023-07-20 06:23:02Z yingtao.ma@noaa.gov $; oSRF Information: abi_g19.osrf.nc created by Yingtao.Ma@hfe10. 2024-09-03 16:32:08; Solar Information: ; ; ; AER extract_solar.f      Comment       �; oSRF Information: Test generating coeff for a IR sensor; Solar Information: Data for use with IR+VIS channel SRFs; Boxcar average of original data; ; Data extracted from AER solar.kurucz.rad.mono.full_disk.bin file.            Sensor_Type              	long_name         Sensor Type    description       <Sensor type to identify MW, IR, VIS, UV, etc sensor channels   units         N/A    
_FillValue                    L   Sensor_Channel                  	long_name         Sensor Channel     description       List of sensor channel numbers     units         N/A    
_FillValue                  (  P   Polarization                	long_name         Polarization type flag     description       Polarization type flag.    units         N/A    
_FillValue                  (  x   Polarization_Angle                  	long_name         Polarization Angle     description       Polarization angle offset      units         degrees (^o)   
_FillValue                      P  �   Channel_Flag                	long_name         Channel flag   description       Bit position flags for channels    units         N/A    
_FillValue                  (  �   	Frequency                   	long_name         	Frequency      description       Channel central frequency, f   units         Gigahertz (GHz)    
_FillValue                      P     
Wavenumber                  	long_name         
Wavenumber     description       Channel central wavenumber, v      units         Inverse centimetres (cm^-1)    
_FillValue                      P  h   	Planck_C1                   	long_name         	Planck C1      description        First Planck coefficient, c1.v^3   units         mW/(m^2.sr.cm^-1)      
_FillValue                      P  �   	Planck_C2                   	long_name         	Planck C2      description       Second Planck coefficient, c2.v    units         
Kelvin (K)     
_FillValue                      P     Band_C1                 	long_name         Band C1    description       $Polychromatic band correction offset   units         
Kelvin (K)     
_FillValue                      P  X   Band_C2                 	long_name         Band C2    description       #Polychromatic band correction slope    units         K/K    
_FillValue                      P  �   Cosmic_Background_Radiance                  	long_name         Cosmic Background Radiance     description       5Planck radiance for the cosmic background temperature      units         mW/(m^2.sr.cm^-1)      
_FillValue                      P  �   Solar_Irradiance                	long_name         Kurucz Solar Irradiance    description       *TOA solar irradiance using Kurucz spectrum     units         mW/(m^2.cm^-1)     
_FillValue                      P  H            	   
                                                                                                                                                              @��<�lZ@�Z��i�@�kR��@���z:�@�<H(�u@ފ:Rʐ@�c��s@�)�tAM�@��s�Y��@�[�GƐ@����B @�H�s��@�����@�O{�tc@�e�3�$�@�L�����@�M���No@��Q�z�@����:o@�����t�Aq�&x��@�o<�|�@�d���y�@݀�[I�@��R(��@�g�dH�$@�64�|��@��Q8�U�@�Yv^ղ�@�ܝ��<@�˽`u�@�/�|uU@�1ل�'@���S�R�@�x0DSAo@�sqб��@���$� Z@�!�-�@�\�pUN+@��i;��W?��|��?�����?�M����}?��C_ ��?�H^�/ax?��`�Q�?�k�Why?��� �?�c��F\?��Qv�[?��$�F�?�᳃�ag?����?������N?���2xb?���T�E�?����r��?��h/\�?��I��]U?���m�B                                                                                @-+�|+��@�:wA�@�A��:@�V���8@
�D�\q@0��̲g@c��&�7?�`79?�R�2	b?�o�u�v