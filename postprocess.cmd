# continue processing after preprocess.cmd and editing of data
mbm_makedatalist -S.mb261 -P -V

# Edit bathymetry
# mbedit

# 3D bathymetry editor
# mbeditviz -I datalist.mb-1

rm *.lck


# Process the data
mbset -PSSRECALCMODE:1
mbprocess -C4

mbgrid -I datalistp.mb-1 \
    -A2 -F5 -N -C20/2 \
    -O ZTopoInt -V
mbgrdviz -I ZTopoInt.grd &

# process amplitude and sidescan
mbbackangle -I datalist.mb-1 \
            -A1 -A2 -Q -V \
            -N87/86.0 -R50 -G2/85/1500.0/85/100 \
            -T ZTopoInt.grd
mbset -PAMPCORRFILE:datalist.mb-1_tot.aga
mbset -PSSCORRFILE:datalist.mb-1_tot.sga
mbset -PAMPSSCORRTOPOFILE:ZTopoInt.grd

# Process the data
mbprocess -C4

# Filter the sidescan
mbfilter -Idatalistp.mb-1 -S2/5/3 -V

#-------------------------------------------------------------------------------
#
# Generate first cut grid and plots
mbgrid -I datalist.mb-1 \
    -A2 -F5 -N -C4 \
    -O ZTopoRaw -V
mbgrdviz -I ZTopoRaw.grd &

mbgrid -I datalistp.mb-1 \
    -A2 -F5 -N -C4 -E25/25 \
    -O ZTopo -V
mbgrdviz -I ZTopo.grd &

mbm_grdplot -I ZTopo.grd \
	-O ZTopoSlopeNav \
	-G5 -D0/1 -A1 \
	-L"FKt230303 EM124_60 - EMARK":"Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-MNIdatalistp.mb-1 \
	-Pc -MIE300 -MITg -V
ZTopoSlopeNav.cmd
gmt psconvert ZTopoSlopeNav.ps -Tj -E300 -A

mbm_grdplot -I ZTopoRaw.grd \
	-O ZTopoRawSlopeNav \
	-G5 -D0/1 -A1 \
	-L"FKt230303 EM124_60 - EMARK":"Realtime (Raw) Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-MNIdatalist.mb-1 \
	-Pc -MIE300 -MITg -V
ZTopoRawSlopeNav.cmd
gmt psconvert ZTopoRawSlopeNav.ps -Tj -E300 -A

# Topo slope map
mbm_grdplot -I ZTopo.grd \
	-O ZTopoSlope \
	-G5 -D0/1 -A1 \
	-L"FKt230303 EM124_60 - EMARK":"Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZTopoSlope.cmd
gmt psconvert ZTopoSlope.ps -Tj -E300 -A

# Topo shade map
mbm_grdplot -I ZTopo.grd \
	-O ZTopoShade \
	-G2 -A0.2/090/05 \
	-L"FKt230303 EM124_60 - EMARK":"Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZTopoShade.cmd
gmt psconvert ZTopoShade.ps -Tj -E300 -A

mbm_grdplot -I ZTopo.grd \
	-O ZTopoCont \
	-G1 -C100 -A1 -MCW0p \
	-L"FKt230303 EM124_60 - EMARK":"Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZTopoCont.cmd
gmt psconvert ZTopoCont.ps -Tj -E300 -A

# Topo shade map
mbm_grd3dplot -I ZTopo.grd \
	-O ZTopo3DShade \
	-G2 -A0.2/90/05 -E150/15 \
	-L"FKt230303 EM124_60 - EMARK":"Topography (meters)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZTopo3DShade.cmd
gmt psconvert ZTopo3DShade.ps -Tj -E300 -A

#-------------------------------------------------------------------------------
#
# Generate first cut amplitude mosaic and plot
mbmosaic -I datalist.mb-1 \
    -A3 -N -Y6 -F0.05 \
	  -O ZAmpR -V
mbgrdviz -I ZTopoRaw.grd -J ZAmpR.grd &
#
# Generate first cut amplitude mosaic and plot
mbmosaic -I datalistp.mb-1 \
    -A3 -N -Y6 -F0.05 \
	  -O ZAmpC -V
mbgrdviz -I ZTopo.grd -J ZAmpC.grd &

mbm_grdplot -I ZAmpR.grd \
	-O ZAmpRPlot \
	-G1 -W1/4 -D -Z-30/0 \
	-L"FKt230303 EM124_60 - EMARK":"Uncorrected Amplitude (dB)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZAmpRPlot.cmd
gmt psconvert ZAmpRPlot.ps -Tj -E300 -A

mbm_grdplot -I ZAmpC.grd \
	-O ZAmpCPlot \
	-G1 -W1/4 -D -Z-30/0 \
	-L"FKt230303 EM124_60 - EMARK":"Corrected Amplitude (dB)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZAmpCPlot.cmd
gmt psconvert ZAmpCPlot.ps -Tj -E300 -A

# Generate first cut sidescan mosaic and plot
mbmosaic -I datalist.mb-1 \
    -A4 -N -Y6 -F0.05 \
	   -O ZSsR -V
mbgrdviz -I ZTopoRaw.grd -J ZSsR.grd &
#
# Generate first cut sidescan mosaic and plot
mbmosaic -I datalistp.mb-1 \
    -A4F -N -Y6 -F0.05 \
	  -O ZSsCF -V
mbgrdviz -I ZTopo.grd -J ZSsCF.grd &

mbm_grdplot -I ZSsR.grd \
	-O ZSsRPlot \
	-G1 -W1/4 -D -Z-30/0 \
	-L"FKt230303 EM124_60 - EMARK":"Uncorrected Sidescan (dB)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZSsRPlot.cmd
gmt psconvert ZSsRPlot.ps -Tj -E300 -A

mbm_grdplot -I ZSsCF.grd \
	-O ZSsCFPlot \
	-G1 -W1/4 -D -Z-30/0 \
	-L"FKt230303 EM124_60 - EMARK":"Corrected and Filtered Sidescan (dB)" \
	-MGLfx4/2/23.50/5.0+l"km" \
	-Pc -MIE300 -MITg -V
ZSsCFPlot.cmd
gmt psconvert ZSsCFPlot.ps -Tj -E300 -A

#-------------------------------------------------------------------------------
