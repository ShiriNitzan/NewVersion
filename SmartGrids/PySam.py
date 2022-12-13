import PySAM.Pvwattsv7 as pv
from PySAM.PySSC import PySSC

system_model = pv.new()
system_model.SolarResource.solar_resource_file

system_model.SystemDesign.gcr = 0.5